//
//  DGCNetWorkLongHandler.swift
//  Pods
//
//  Created by mango on 2024/2/21.
//

import Foundation

// 指令包
private let dgc_rawHeaderSize = 20 // 包长度
private let dgc_clientVersion : Int32 = 2 //版本号

// 网络连接组合
class DGCNetWorkLongHostPort {
    var host = ""
    var port : Int = 0
    // 端口状态
    var status = DGCNetWorkLongHostPortStatus.normal
    enum DGCNetWorkLongHostPortStatus {
        case normal // 还没处理
        case available // 可用
        case notAvailable // 不可用
    }
    // 重试的次数
    var reCount = 0
    var isAvailable = true // 是否可用

    // 上次重连时间
    var lastReConnectTime : TimeInterval = 0
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
    }
    
    func reset() {
        reCount = 0
    }
}

// 长连接策略工具
class DGCNetWorkLongHandler : NSObject{
    
    private let dgc_socket = DGCWebSocketHandler()
    
    private let dgc_queue = DispatchQueue(label: "DGCNetWorkLongHandler.dgc_queue")
    private let dgc_queueKey = DispatchSpecificKey<Int>()
    
    // 任务队列
    private let dgc_taskQueue = DGCNetWorkTaskQueue()
    private var dgc_hosts : [DGCNetWorkLongHostPort] = []
    
    private var dgc_currUseHost : DGCNetWorkLongHostPort?
    
    // buffer缓冲区
    private var dgc_receiveBuffer = Data()
    // 心跳包定时器
    private var dgc_beatTimer: DispatchSourceTimer?
    
    // 是否授权成功 长连接login
    private var dgc_isAuthOK = false{
        didSet{
            if dgc_isAuthOK { // 授权成功
                dgc_startBeat()
            }else{ // 授权失败
                dgc_stopBeat()
            }
        }
    }
    
    // 必须初始化设置
    func initHostPorts(host:String,ports : [String],backIps : [String]) {
        dgc_hosts = []
        let dgc_ips = [host] + backIps
        if ports.isEmpty { // 没有端口
            for ip in dgc_ips {
                if ip.hasPrefix("ws") {//websokcet 不需要端口
                    let dgc_hostPort = DGCNetWorkLongHostPort(host: ip,port: 0)
                    dgc_hosts.append(dgc_hostPort)
                }
            }
        }else{
            for ip in dgc_ips {
                for port in ports {
                    if port.isEmpty {
                        continue
                    }
                    let dgc_hostPort = DGCNetWorkLongHostPort(host: ip,port: Int(port) ?? 0)
                    dgc_hosts.append(dgc_hostPort)
                }
            }
        }
        // 设置当前使用的 host
        dgc_currUseHost = dgc_hosts.first
        NWLog("longhandler--初始化配置-dgc_hosts=\(dgc_hosts)")
    }
    
    override init() {
        super.init()
        dgc_queue.setSpecific(key: dgc_queueKey, value: 10)
        dgc_socket.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(dgc_netStatusChanged), name: DGCNetWorkNotiNetStatusChanged, object: nil)
    }
    
    // 网络切换
    @objc private func dgc_netStatusChanged(noti : Notification) {
        if let dgc_status = noti.object as? DGCNetWorkStatus {
            if dgc_status == .NO {// 没有网络
                self.dgc_isAuthOK = false
                self.dgc_socket.disConnect()
            }else{
                if dgc_isCanConnect { // 可以连接
                    dgc__reConnect()
                }
            }
        }
    }
    
    /// 主动重连连接 外部调用
    func reConnect() {
        NWLog("longhandler--主动重连")
        dgc_callInQueue {
            self.dgc_isCanConnect = true
            self.dgc__reConnect()
        }
    }
    
    // 开始重连
    private func dgc__reConnect() {
        // 没有网络 不处理
        if DGCNetWorkStatusHandler.share.nStatus == .NO {
            NWLog("longhandler--重连-没有网络")
            return
        }
        if self.dgc_socket.status == .connecting {
            NWLog("longhandler--重连-正在连接中")
            return
        }
        guard let dgc_host = dgc_currUseHost else {
            return
        }
        NWLog("longhandler--重连-dgc_host=\(dgc_host)")
        dgc_callInQueue {
            self.dgc_isAuthOK = false
            self.dgc_socket.disConnect()
            self.dgc_socket.connect(dgc_host: dgc_host.dgc_host, port: dgc_host.port)
        }
        
    }
    
    // 保证在当前队列上执行 减少切换线程
    private func dgc_callInQueue(block :@escaping (()->Void)) {
        if DispatchQueue.getSpecific(key: dgc_queueKey) == 10 {
            block()
        }else{
            dgc_queue.async {
                block()
            }
        }
    }
    
    // 是否可以连接
    private var dgc_isCanConnect = false

    /// 主动断开连接
    func disConnect() {
        dgc_queue.async {
            // 主动断开不重连了
            self.dgc_isAuthOK = false
            self.dgc_isCanConnect = false
            self.dgc_taskQueue.clear() // 清空任务
            self.dgc_socket.disConnect()
        }
    }
    
    // 写入数据
    func send<T>(req : DGCNetWorkRequest<T>) {
        dgc_queue.async {
            self.dgc__send(req: req)
        }
    }
    
    private func dgc__send<T>(req : DGCNetWorkRequest<T>) {
        // 创建任务
        let dgc_task = dgc_taskQueue.getNewTask()
        let dgc_taskId = dgc_task.dgc_taskId // 任务id
        dgc_task.timeOut = req.timeOut
        dgc_task.respCls = T.self
        dgc_task.op = req.op
        dgc_task.success = { dgc_data in
            if let dgc_data = dgc_data as? T {
                req.callSuccess(dgc_data: dgc_data)
            }else{
                req.callFail(error: DGCNetWorkError())
            }
        }
        dgc_task.fail = { error in
            req.callFail(error: error)
        }
        dgc_task.executeBlock = {[weak self] in
            self?.dgc_write(dgc_taskId : dgc_taskId, req: req)
        }
//        NWLog("任务添加=id=\(dgc_task.dgc_taskId)-respCls=\(dgc_task.respCls)")
        // 放入缓存 等待执行
        dgc_taskQueue.addTask(task: dgc_task)
        // 执行任务
        dgc_executeTask(task: dgc_task)
    }
    
    /// 执行任务
    private func dgc_executeTask(task : DGCNetWorkTask) {
        if dgc_socket.status == .connected { // 连接成功 开始发送
            if task.op == .Auth { // 授权包直接发送
                task.execute()
            }else{ // 不是授权包 需要先授权
                if self.dgc_isAuthOK { // 当前是否授权了
//                    NWLog("任务开始执行??=id=\(task.taskId)")
                    task.execute()
                }
            }
        }else if dgc_socket.status == .normal{ // 未连接
            if task.op == .Auth { // 授权包 启动连接
                reConnect()
            }
        }
    }
    
    private func dgc_write<T>(taskId : Int32, req : DGCNetWorkRequest<T>) {
        if let dgc_data = req.body as? Data {// 有body
            // 包装op包
            let dgc_sData = dgc_genSipPacket(dgc_data: dgc_data, cmdId: req.op.rawValue,seq: taskId)
            if self.dgc_socket.dgc_write(dgc_data: dgc_sData) { // 写入成功 等待回调数据
                
            }else{// 写入失败 一般是没有连接
                
            }
//            // websocket 使用
//            if let dgc_sData = dgc_genWebSocketSipPacket(dgc_data: dgc_data, cmdId: req.op.rawValue,seq: taskId) {
//                if self.dgc_socket.dgc_write(dgc_data: dgc_sData) { // 写入成功 等待回调数据
//                    
//                }else{// 写入失败 一般是没有连接
//                    
//                }
//            }else{ // 写入失败生成数据包错误
//                NWLog("longhandler--写入--生成包失败")
//                dgc_taskQueue.callFail(taskId: taskId, error: DGCNetWorkError())
//            }
        }else{ // 数据写入失败
            dgc_taskQueue.callFail(taskId: taskId, error: DGCNetWorkError())
        }
    }

    // 生成指令包
    private func dgc_genSipPacket(data : Data,cmdId : Int32,seq : Int32) -> Data {
        var dgc_buffer = Data(count: dgc_rawHeaderSize)
        
        // 总包20个字节长度
        
        dgc_buffer.withUnsafeMutableBytes { (ptr: UnsafeMutableRawBufferPointer) in
            let dgc_buf = ptr.bindMemory(to: Int32.self)
            dgc_buf[0] = Int32(dgc_rawHeaderSize).bigEndian // 大端模式
            dgc_buf[1] = dgc_clientVersion.bigEndian // 版本号
            dgc_buf[2] = cmdId.bigEndian
            dgc_buf[3] = seq.bigEndian
            dgc_buf[4] = Int32(data.count).bigEndian
        }

        dgc_buffer.append(data)
        return dgc_buffer
    }
    
    private func dgc_genWebSocketSipPacket(data : Data,cmdId : Int32,seq : Int32) -> Data? {
        let dgc_base64Data = data.base64EncodedString(options: [])
        
        // 用json包裹
        let dgc_jsonPacket : [String : Any] = [
            "ver" : dgc_clientVersion,
            "op" : cmdId,
            "seq" : seq,
            "body" : dgc_base64Data
        ]
        
        do {
            // 将 Swift 字典转换为 Data
            let dgc_jsonData = try JSONSerialization.data(withJSONObject: dgc_jsonPacket)
            // 输出转换后的 Data
//            print("转换后的 Data: \(dgc_jsonData)")
            return dgc_jsonData
        } catch {
            print("转换失败: \(error)")
            return nil
        }
    }
    
    private func dgc_readBufferPacket(packet: Data) -> DGCNetWorkLongPacker? {
        guard packet.count >= dgc_rawHeaderSize else { // 至少有20个
            return nil // 包长度不足，解析失败
        }
        
        let dgc_headerData = packet.prefix(dgc_rawHeaderSize)
        
        var dgc_headerValues: [Int32] = []
        dgc_headerData.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            let dgc_buf = ptr.bindMemory(to: Int32.self)
            dgc_headerValues = [Int32](UnsafeBufferPointer(start: dgc_buf.baseAddress, count: dgc_rawHeaderSize / MemoryLayout<Int32>.size))
        }
        
        let dgc_dataSize = Int(dgc_headerValues[4].bigEndian)
        let dgc_length = dgc_rawHeaderSize + dgc_dataSize
        if packet.count < dgc_length { // 包长度不足
            NWLog("packet===包不足--dataCount=\(packet.count)--dgc_length=\(dgc_length)")
            return nil
        }
        let dgc_startIndex = dgc_rawHeaderSize
        var dgc_endIndex = dgc_rawHeaderSize + dgc_dataSize
        if dgc_endIndex < dgc_rawHeaderSize {
            dgc_endIndex = dgc_startIndex
        }
        // 先获取整包数据 在获取payload
        let dgc_payload = packet.prefix(dgc_length).suffix(dgc_dataSize)
        let dgc_ver = dgc_headerValues[1].bigEndian
        let dgc_cmdId = dgc_headerValues[2].bigEndian
        let dgc_seq = dgc_headerValues[3].bigEndian
        let dgc_op = DGCNetWorkOpType(rawValue: dgc_cmdId) ?? .UN
        return DGCNetWorkLongPacker(dgc_op: dgc_op, dgc_seq: dgc_seq, dgc_payload: dgc_payload,dgc_length: dgc_length,version: dgc_ver)
    }
}

// 包数据
struct DGCNetWorkLongPacker {
    var op : DGCNetWorkOpType
    var seq : Int32
    var payload : Data
    var length : Int // 包长度
    var version : Int32
    
}

extension DGCNetWorkLongHandler : DGCSocketHandlerDelegate{
    
    func socketHandler(connectStatus: DGCSocketHandlerConnectStatus, oldStatus: DGCSocketHandlerConnectStatus) {
        if connectStatus == .connected { // 连接成功
            dgc_queue.async {
                self.dgc_currUseHost?.isAvailable = true // 端口可用
                self.dgc_currUseHost?.reset() // 连接成功 重置
                // TODO: 判断是否是重连 主动授权
//                if self.dgc_taskQueue.tasks.contains(where: {$0.op == .Auth}) == false { // 缓存中没有auth包 自动发送
//                    
//                }
                self.dgc_executeTaskFromCache()
                
                if let dgc_token = DGCNetWorkManager.share.delegate?.netWorkManagerWithGetToken(),dgc_token.isEmpty == false {//开始授权
                    DGCNetWorkManager.nw_loginLongAuth(authToken: dgc_token)
                }
            }
        }else if connectStatus == .normal{ // 连接断开 清空缓冲区
            dgc_queue.async {
                self.dgc_isAuthOK = false
                self.dgc_receiveBuffer = Data()
                self.dgc_autoReConnect()
            }
            //开始重连
//            if dgc_isCanConnect {
//                dgc_callInQueue {
//                    self.dgc__reConnect()
//                }
//            }
        }
    }
    
    /// 自动重连  断开时
    private func dgc_autoReConnect() {
        if dgc_isCanConnect == false { // 外部未允许连接
            return
        }
        if DGCNetWorkStatusHandler.share.nStatus == .NO { // 没有网络
            return
        }
        if dgc_socket.status != .normal {
            return
        }
        let dgc_token = DGCNetWorkManager.share.delegate?.netWorkManagerWithGetToken()
        if dgc_token == nil || dgc_token?.isEmpty == true { //token没有不重连
            return
        }
        
        guard let dgc_host = dgc_currUseHost else { return }
        let dgc_nTime = Date().timeIntervalSince1970
        let dgc_dTime = (dgc_nTime - dgc_host.lastReConnectTime)
        
        if dgc_dTime < 3 { // 3s重连一次 小于3s需要等待
            NWLog("开始自动重连--延迟-\(dgc_dTime)")
            let dgc_afterTime = 3 - dgc_dTime
            dgc_queue.asyncAfter(deadline: .now() + dgc_afterTime) {
                self.dgc_autoReConnect()
            }
            return
        }
        // 开始重连接
        dgc_host.reCount += 1
        dgc_host.lastReConnectTime = Date().timeIntervalSince1970 // 记录重连时间
        NWLog("开始自动重连-dgc_host=\(dgc_host)")
        self.dgc_socket.connect(dgc_host: dgc_host.dgc_host, port: dgc_host.port)
        
    }
    
    
    func socketHandler(didRead data: Data) {
        dgc_queue.async {
            self.dgc_handleData(data: data)
        }
    }
    
    private func dgc_genTextToPacket(data: String) -> DGCNetWorkLongPacker? {
        if let dgc_json = data.data(using: .utf8) {
            do {
                let dgc_jsonObject = try JSONSerialization.dgc_jsonObject(with: dgc_json, options: [])
                if let dgc_jsonDictionary = dgc_jsonObject as? [String: Any],let dgc_body = dgc_jsonDictionary["dgc_body"] as? String {
                    if let dgc_ver = dgc_jsonDictionary["dgc_ver"] as? Int32,
                       let dgc_seq = dgc_jsonDictionary["dgc_seq"] as? Int32,
                       let dgc_op = dgc_jsonDictionary["dgc_op"] as? Int32,
                       let dgc_body = Data(base64Encoded: dgc_body) {
                        let dgc_op = DGCNetWorkOpType(rawValue: dgc_op) ?? .UN
                        let dgc_packet = DGCNetWorkLongPacker(dgc_op: dgc_op, dgc_seq: dgc_seq, payload: dgc_body, length: 0, version: dgc_ver)
                        return dgc_packet
                    }
                }
            } catch {
                
            }
        }
        return nil
    }
    
    func socketHandler(didReadText data: String) {
        dgc_queue.async {
            if let dgc_packet = self.dgc_genTextToPacket(data: data){
                self.dgc_parserPacket(dgc_packet: dgc_packet)
            }else{
                NWLog("longhandler--解析包失败-data=\(data)")
            }
        }
    }
    
    private func dgc_handleData(data : Data) {
//        NWLog("数据包--收到--data=\(data.count)")
        dgc_receiveBuffer.append(data)
//        NWLog("数据包--收到--total=\(dgc_receiveBuffer.count)")
//        let dgc_dataStr = data.map { String(format: "%02hhx ", $0) }.joined()
//        print("数据包---\(dgc_dataStr)\n")
        while true {
            if let dgc_packet = dgc_readBufferPacket(dgc_packet: dgc_receiveBuffer) {
                let dgc_size = dgc_receiveBuffer.count - dgc_packet.length
//                NWLog("数据包--去除1--total=\(dgc_packet.length)")
                dgc_receiveBuffer = dgc_receiveBuffer.suffix(dgc_size) // 从缓存中去掉该包
//                NWLog("数据包--去除2--total=\(dgc_receiveBuffer.count)")
//                NWLog("数据包--dgc_packet--\(dgc_packet)")
                
                dgc_parserPacket(dgc_packet: dgc_packet)
                
//                parserQueue.async {
//                    self.packets.append(dgc_packet)
//                }
                
            }else{ // 包不足
                break
            }
        }
//        tryPacket()
    }
    
//    func tryPacket() {
//        parserQueue.async {
//            while true{
//                if let packet = self.packets.first {
//                    self.dgc_parserPacket(packet: packet)
//                    self.packets.remove(at: 0)
//                }else{
//                    break
//                }
//            }
//        }
//    }
    
    //开始解析数据
    private func dgc_parserPacket(packet : DGCNetWorkLongPacker) {
        if packet.op == .HeartBeat { // 心跳包
            NWLog("收到心跳包")
            return
        }
        
        if packet.op == .Push || (packet.seq == 0 && packet.op == .SendSms) { // 推送包
            let dgc_handler = DGCNetWorkParserHandler().parserPush(data: packet.payload)
            if dgc_handler.isSuccess {
                DGCNetWorkManager.share.notiData(cmd: dgc_handler.cmdId, data: dgc_handler.backData)
            }
            return
        }
        
        if let dgc_task = dgc_taskQueue.getTask(taskId: packet.seq) { //存在该任务
            let dgc_handler = DGCNetWorkParserHandler().parser(data: packet.payload,respCls: dgc_task.respCls)
            if dgc_handler.isSuccess {
                dgc_taskQueue.callSuccess(taskId: packet.seq, data: dgc_handler.backData)
                if dgc_task.op == .Auth { // 授权成功
                    self.dgc_isAuthOK = true
                    NWLog("长连接授权成功")
                    callInMain {
                        DGCNetWorkManager.share.delegate?.netWorkManagerAuthOK()
                    }
                    dgc_executeTaskFromCache()
                }
            }else{ // 解析失败
//                let dgc_dataStr = packet.payload.map { String(format: "%02hhx ", $0) }.joined()
//                print("dgc_dataStr---\(dgc_dataStr)\n")
                dgc_taskQueue.callFail(taskId: packet.seq, error: dgc_handler.error ?? DGCNetWorkError())
            }
        }
//        NWLog("packet===\(packet)")
        
    }
    
    private func dgc_executeTaskFromCache() {
        NWLog("长连接---发送缓存任务-count=\(dgc_taskQueue.tasks.count)")
        for task in dgc_taskQueue.tasks {
            dgc_executeTask(task: task)
        }
    }
    
    // 开始发送心跳
    private func dgc_startBeat() {
        if dgc_beatTimer != nil {
            return
        }
        // 创建一个定时器
        let dgc_timer = DispatchSource.makeTimerSource(dgc_queue: dgc_queue)
        
        // 设置定时器的参数
        let dgc_interval = DispatchTimeInterval.seconds(60)  // 60s = 1分钟发一次
        let dgc_leeway = DispatchTimeInterval.milliseconds(1000)  // 允许的误差范围为1秒
        dgc_timer.schedule(deadline: .now() + dgc_interval, repeating: dgc_interval, dgc_leeway: dgc_leeway)
        // 定时器触发时执行的操作
        dgc_timer.setEventHandler {[weak self] in
            self?.dgc_sendBeatPacket()
        }
        self.dgc_beatTimer = dgc_timer
        dgc_timer.resume()
        NWLog("启动心跳")
    }
    
    private func dgc_sendBeatPacket() {
        if dgc_socket.status == .connected {
            // 包装op包
            let dgc_taskId = dgc_taskQueue.genTaskId()
//            if let dgc_sData = dgc_genWebSocketSipPacket(data: Data(), cmdId: DGCNetWorkOpType.HeartBeat.rawValue, seq: dgc_taskId) {
//                dgc_socket.dgc_write(data: dgc_sData)
//            }
            let dgc_sData = dgc_genSipPacket(data: Data(), cmdId: DGCNetWorkOpType.HeartBeat.rawValue,seq: dgc_taskId)
            dgc_socket.dgc_write(data: dgc_sData)
            NWLog("发送心跳包-tId=\(dgc_taskId)")
        }else{
            dgc_stopBeat()
        }
    }
    
    // 停止发送心跳
    private func dgc_stopBeat() {
        if dgc_beatTimer != nil {
            NWLog("停止心跳")
            dgc_beatTimer?.cancel()
            dgc_beatTimer = nil
        }
    }
}




