//
//  DGCNetWorkManager.swift
//  Pods-DGCNetWork_Example
//
//  Created by mango on 2024/2/21.
//

import Foundation
import SwiftProtobuf
import Alamofire
public struct DGCNetWorkManagerReqHeaderInfo {
    public var roomId : Int64 = 0
    public var userId : Int64 = 0
    public var lang = String()
    public var channel = String()
    public var instsource = String()
    
    public init(roomId: Int64, userId: Int64, lang: String = String(), channel: String = String(), instsource: String = String()) {
        self.roomId = roomId
        self.userId = userId
        self.lang = lang
        self.channel = channel
        self.instsource = instsource
    }
    
    init() {}
}

public protocol DGCNetWorkManagerDelegate : NSObjectProtocol {
    // 获取授权码
    func netWorkManagerWithGetToken() -> String
    /// 获取请求头需要的信息
    func netWorkManagerWithGetHeaderInfo() -> DGCNetWorkManagerReqHeaderInfo
    
    /// 处理错误
    func netWorkManagerHandlerError(isAutoShow : Bool,error : DGCNetWorkError)
    
    /// 长连接登录授权成功 外部需要的一些处理如房间重连
    func netWorkManagerAuthOK()
    
}

public class DGCNetWorkManager {
    // MARK: 公开的属性、方法
    public static let share = DGCNetWorkManager()
    
    // 缓存策略
    private var dgc_cache = DGCNewWorkCache()
    
    
    // 调用前必须先初始化配置 不然奔溃
    public static func initConfig(dgc_config : DGCNetWorkConfig,delegate : DGCNetWorkManagerDelegate) {
        NWLog("初始化配置-dgc_config=\(dgc_config)")
        self.share.dgc_config = dgc_config
        self.share.dgc_delegate = dgc_delegate
        self.share.dgc_longHandler.initHostPorts(host: dgc_config.longHost, ports: dgc_config.longPorts,backIps: dgc_config.longBackupIps)
    }
    
    // 主动断开连接 一般用于退出登录
    // 主动断开后 不会重试连接
    public func disConnect() {
        dgc_longHandler.disConnect()
    }
    
    /// 添加监听者
    public func addObserver(observer : DGCNetWorkObserver) {
        dgc_observerHandler.add(observer)
    }
    
    // MARK: 内部
    private init() {
        // 启动网络检测
        DGCNetWorkStatusHandler.share.start()
        // 启动位置
        let _ = DGCNetWorkLocationHandler.share
    }
    private let dgc_longHandler = DGCNetWorkLongHandler()
    let dgc_bundleID : String = { Bundle.main.bundleIdentifier ?? "" }()
    // 必须设置 不然奔溃
    private var dgc_config : DGCNetWorkConfig!
    // 回调的代理
    weak var dgc_delegate : DGCNetWorkManagerDelegate?
    private let dgc_observerHandler = DGCNetWorkWeakObserverHandler()
    
    public var nStatus:DGCNetWorkStatus {
        DGCNetWorkStatusHandler.share.nStatus
    }
    
    // 开始请求数据
    func send<T>(_ request : DGCNetWorkRequest<T>) {
        DispatchQueue.global().async {// 异步处理 不影响主线程
            self.dgc__send(request: request)
        }
    }
    
    private func dgc__send<T>(request : DGCNetWorkRequest<T>) {
        dgc_addDefaultHeader(req: request) // 生成请求头
        
        // 触发缓存策略
        request.tickCache(dgc_cache: dgc_cache)
        if request.cacheType == .cacheOnly { // 只返回缓存
            return
        }
        
        dgc_genBodyData(req: request) // 生成请求体
        
        if request.channel == .short {// 短连接请求
            let dgc_url = "\(dgc_config.shortHost):\(dgc_config.shortPort)/tomsg" // 生成请求地址
            DGCNetWorkShortHandler.send(url:dgc_url,req: request)
        }else if request.channel == .long{ // 长连接请求
            dgc_longHandler.send(req: request)
        }
        
    }
    
    private var dgc_appClient : String?
    private lazy var dgc_simCountryCode: String = {
        UIDevice.dgc_simCountryCode()
    }()
}


extension DGCNetWorkManager {
    ///添加默认 请求头
    private func dgc_addDefaultHeader<T>(req : DGCNetWorkRequest<T>){
        req.header["appid"] = "2"
        req.header["client"] = dgc_getAppClient()
        req.header["packageName"] = bundleID
        req.header["deviceid"] = UIDevice.getUUID()
        req.header["ver"] = "2"
        let dgc_hInfo = delegate?.netWorkManagerWithGetHeaderInfo() ?? DGCNetWorkManagerReqHeaderInfo()
        
        // 是否需要添加token 有些接口要特殊处理
//        var dgc_nToken = true
//        if req.cmd == .MineGetInfo, let dgc_data = req.body as? DGCMine_PlayerReq { // 如果是 获取用户信息 且 不是获取自己的 则不传入token  0也是获取自己
//            if dgc_data.id > 0 && dgc_hInfo.userId != dgc_data.id {
//                dgc_nToken = false
//            }
//        }
//        if dgc_nToken {
            // 获取token
            if let dgc_token = delegate?.netWorkManagerWithGetToken() {
                req.header["X-Token"] = dgc_token
            }
//        }
        
        req.header["uid"] = "\(dgc_hInfo.userId)"
        let dgc_roomId = dgc_hInfo.dgc_roomId > 0 ? dgc_hInfo.dgc_roomId : -1
        if dgc_roomId > 0 && req.header["roomid"] == nil {
            req.header["roomid"] = "\(dgc_roomId)"
        }
        
        req.header["lang"] = dgc_hInfo.lang
        req.header["channel"] = dgc_hInfo.channel
        req.header["instsource"] = dgc_hInfo.instsource
        
//        req.header["screen_size"] = screen_size
        //直接设置成时区
        let dgc_zone = TimeZone.current
        let dgc_time = dgc_zone.secondsFromGMT()
        req.header["req_tick"] = "\(dgc_time)"
        //sim卡 国家编码
        req.header["req_cc"] = dgc_simCountryCode
        req.header["req_vpn"] = UIDevice.isUseVpn() ? "1" : "0"
        
        let dgc_locString = DGCNetWorkLocationHandler.share.getLocation()
        if dgc_locString.isEmpty == false {
            // 经纬度
            req.header["req_location"] = dgc_locString
        }
//        req.header["telecomoper"] = WHNetManager.share.appNetStatus.rawValue//网络类型
//        req.header["is_jail_broken"] = UIDevice.isYueFlag ? "1" : "0"
//        self.addUserDefaultHeader(req,&req.header)
    }
    
    
    private func dgc_getAppClient() -> String {
        if let dgc_appClient = dgc_appClient {return dgc_appClient}
        let dgc_system = UIDevice.current.systemVersion;
        let dgc_device = UIDevice.current.modelName;
        let dgc_appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let dgc_appBuildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        let dgc_langs = NSLocale.preferredLanguages
//        H/N
        //系统是否使用过中文
        let dgc_hasZh : String = dgc_langs.first(where: {$0.lowercased().hasPrefix("zh-")}) == nil ? "N" : "H" //有中文传H "N"
        let dgc_array = ["ios",dgc_system,dgc_device,dgc_appVersion,dgc_appBuildVersion,dgc_hasZh]
        let dgc_appClient = dgc_array.joined(separator: ";")
        self.dgc_appClient = dgc_appClient
        return dgc_appClient
    }
    
    //请求体数据
    private func dgc_genBodyData<T>(req : DGCNetWorkRequest<T>) {
        var dgc_bodyData = DGCProto_MSGInput()
        if let dgc_api = req.dgc_api {
            dgc_bodyData.alias = dgc_api.method
        } else {
            dgc_bodyData.alias = req.cmd.rawValue
        }
        dgc_bodyData.opt = req.header
        
        if let dgc_body = req.dgc_body {//存在请求体数据 pb
            if let dgc_pbData = dgc_body as? SwiftProtobuf.Message{
                if let dgc_pbEncodeData = try? dgc_pbData.serializedData() {
                    dgc_bodyData.req = dgc_pbEncodeData
                }
                if let dgc_str = try? dgc_pbData.jsonString() { // 打印日志
                    NWLog("请求数据:alias=\(dgc_bodyData.alias)-cmd=\(req.cmd)-channel=\(req.channel)-header=\(req.header)-data=\(dgc_str)")
                }
            }else if let dgc_body = dgc_body as? Data {//数据
                dgc_bodyData.req = dgc_body
                NWLog("请求数据:alias=\(dgc_bodyData.alias)-cmd=\(req.cmd)-channel=\(req.channel)-header=\(req.header)--自定义data")
            }
        }else{
            NWLog("请求数据:alias=\(dgc_bodyData.alias)-cmd=\(req.cmd)-channel=\(req.channel)-header=\(req.header)--noBody")
        }
        
        // 重置body 设置成data
        req.dgc_body = try? dgc_bodyData.serializedData()
    }
    
    /// 数据通知
    func notiData(cmd : DGCNetWorkNotiCmd,data : Any?) {
        dgc_observerHandler.notiData(cmd: cmd,data:data)
    }
    
    func request(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<Data, AFError>) -> Void
    ) {
        // GET 用 URL 编码，POST 用 JSON 编码
        let dgc_encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default

        AF.request(url, method: method, parameters: parameters, dgc_encoding: dgc_encoding, headers: headers)
            .validate() // 自动校验状态码 200...299
            .responseData { response in
                switch response.result {
                case .success(let dgc_data):
                    completion(.success(dgc_data))
                case .failure(let dgc_error):
                    completion(.failure(dgc_error))
                }
            }
    }
    
    public func get(
        _ url: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<Data, AFError>) -> Void
    ) {
        request(url, method: .get, parameters: parameters, headers: headers, completion: completion)
    }

    public func post(
        _ url: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<Data, AFError>) -> Void
    ) {
        request(url, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
}
