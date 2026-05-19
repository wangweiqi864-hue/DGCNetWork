//
//  DGCSocketHandler.swift
//  Pods
//
//  Created by mango on 2024/2/21.
//

import Foundation
import CocoaAsyncSocket

enum DGCSocketHandlerConnectStatus {
    case normal // 默认状态 未连接
    case connecting // 连接中
    case connected // 连接成功
}


protocol DGCSocketHandlerDelegate : NSObjectProtocol {
    func socketHandler(connectStatus : DGCSocketHandlerConnectStatus,oldStatus : DGCSocketHandlerConnectStatus)
    // 收到数据
    func socketHandler(didRead data: Data)
    
    // webSokcet 格式
    func socketHandler(didReadText data: String)
}

// 长连接管理
class DGCSocketHandler : NSObject{
    
    private let dgc_socketQueue = DispatchQueue(label: "DGCSocketHandler.queue")
    
    private var dgc_socket : GCDAsyncSocket?
    
    private var dgc__status = DGCSocketHandlerConnectStatus.normal
    private(set) var dgc_status : DGCSocketHandlerConnectStatus{
        get{dgc__status}
        set{
            let dgc_oldStatus = dgc__status
            dgc__status = newValue
            if dgc_oldStatus == newValue { // 状态相同 不回调
                return
            }
            dgc_delegate?.socketHandler(connectStatus: dgc_status,dgc_oldStatus: dgc_oldStatus)
        }
    }
    
    /// 自动重连次数
//    private var dgc_autoConnectCount = 10
    
    /// 初始化配置
//    func setConfig() {
//        NWLog("dgc_socket--setConfig")
//    }
    weak var dgc_delegate : DGCSocketHandlerDelegate?
    
//    convenience init(delegate : DGCSocketHandlerDelegate) {
//        self.init()
//        self.dgc_delegate = dgc_delegate
//    }
    
    override init() {
        super.init()
        dgc_initSocket()
    }
    
    /// 初始化
    private func dgc_initSocket() {
        let dgc_socket = GCDAsyncSocket(delegate: self,delegateQueue: dgc_socketQueue)
//        dgc_socket.autoDisconnectOnClosedReadStream = false //设置默认关闭读取
        self.dgc_socket = dgc_socket
        NWLog("dgc_socket--dgc_initSocket")
    }
    
    /// 销毁
//    func deinitSocket() {
//        disConnect()
//        dgc_socket = nil
//        NWLog("dgc_socket--deinitSocket")
//    }
    
    /// 开始连接
    func connect(host : String,port : Int) {
        if dgc_status != .normal {
            NWLog("dgc_socket--connectFail-状态-\(dgc_status)")
            return
        }
        dgc_status = .connecting
        do {
            try dgc_socket?.connect(toHost: host, onPort: UInt16(port))
        } catch let dgc_error {
            NWLog("dgc_socket--连接失败-\(dgc_error.localizedDescription)")
            dgc_status = .normal
            return
        }
    }
    
    /// 断开连接
    func disConnect() {
        if dgc_status == .normal {
            return
        }
        NWLog("dgc_socket--disConnect")
        dgc_socket?.disconnect()
        dgc_status = .normal
    }
    
    /// 写入数据
    /// tag 标志本次操作完成
    @discardableResult
    func write(data : Data) -> Bool {
        if dgc_status != .connected { // 为连接写入数据失败
            return false
        }
        // 写入数据
        dgc_socket?.write(data, withTimeout: -1, tag: 0)
//        NWLog("dgc_socket--开始写入数据-tag=0-count=\(data.count)")
        return true
    }
    
    //开启接收数据
    private func dgc_beginReadData(tag : Int = 0) {
        dgc_socket?.readData(withTimeout: -1, tag: tag)
    }
    
}


extension DGCSocketHandler : GCDAsyncSocketDelegate{
    
    /// 连接成功
    func dgc_socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        NWLog("dgc_socket--连接成功")
        dgc_status = .connected
        dgc_beginReadData()
    }
    
    /// 断开连接
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        NWLog("dgc_socket--断开连接-err=\(err?.localizedDescription ?? "")")
        dgc_status = .normal
    }
    
    /// 收到消息
    func dgc_socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
//        NWLog("dgc_socket--收到消息-tag=\(tag)-data=\(data.count)")
        self.delegate?.socketHandler(didRead: data)
        dgc_beginReadData(tag: tag)
        
    }

    /// 写入数据成功
    func dgc_socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
//        NWLog("dgc_socket--写入数据成功-tag=\(tag)")
        dgc_beginReadData(tag: tag)
    }
    
//    // TCP成功获取安全验证
//    func socketDidSecure(_ sock: GCDAsyncSocket) {
//        NWLog("dgc_socket--socketDidSecure")
//    }
}
