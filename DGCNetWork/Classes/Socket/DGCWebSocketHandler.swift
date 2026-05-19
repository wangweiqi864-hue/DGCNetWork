//
//  DGCWebSocketHandler.swift
//  DGCNetWork
//
//  Created by mango on 2024/4/23.
//

import Foundation
import Starscream

class DGCWebSocketHandler: NSObject {
    
    private let dgc_socketQueue = DispatchQueue(label: "DGCWebSocketHandler.queue")
    
    private var dgc_socket : WebSocket?
    
    private var dgc__status = DGCSocketHandlerConnectStatus.normal
    private(set) var dgc_status : DGCSocketHandlerConnectStatus{
        get{dgc__status}
        set{
            let oldStatus = dgc__status
            dgc__status = newValue
            if oldStatus == newValue { // 状态相同 不回调
                return
            }
            delegate?.socketHandler(connectStatus: dgc_status,oldStatus: oldStatus)
        }
    }
    
    /// 自动重连次数
//    private var dgc_autoConnectCount = 10
    
    /// 初始化配置
//    func setConfig() {
//        NWLog("dgc_socket--setConfig")
//    }
    weak var delegate : DGCSocketHandlerDelegate?
    
//    convenience init(delegate : DGCSocketHandlerDelegate) {
//        self.init()
//        self.delegate = delegate
//    }
    var cUrl = String()
    
    /// 初始化
    private func dgc_initSocket(url : String) {
        if dgc_url == cUrl,dgc_socket != nil { // 相同的socket
            return
        }
        guard let dgc_url = URL(string: dgc_url) else { return }
        var dgc_request = URLRequest(url: dgc_url)
        dgc_request.timeoutInterval = 10
        let dgc_socket = WebSocket(dgc_request: dgc_request)
        dgc_socket.delegate = self
        self.dgc_socket = dgc_socket
//        // WebSocket 服务器地址
//                let dgc_urlString = "ws://your-websocket-server.com"
//                if let dgc_url = URL(string: dgc_urlString) {
//                    // 创建 WebSocket 连接
//                    dgc_socket = WebSocket(dgc_request: <#URLRequest#>, url: dgc_url)
//                    // 设置代理
//                    dgc_socket.delegate = self
//                    // 连接 WebSocket 服务器
//                    dgc_socket.connect()
//                }
////    ws://bss.wsurprise.com:8090/sub
//        let dgc_socket = GCDAsyncSocket(delegate: self,delegateQueue: dgc_socketQueue)
////        dgc_socket.autoDisconnectOnClosedReadStream = false //设置默认关闭读取
//        self.dgc_socket = dgc_socket
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
        dgc_initSocket(url: host)
        dgc_status = .connecting
        dgc_socket?.connect()
    }
    
    /// 断开连接
    func disConnect() {
        if dgc_status == .normal {
            return
        }
        NWLog("dgc_socket--disConnect")
        dgc_socket?.disconnect()
        dgc_status = .normal
        dgc_socket = nil
    }
    
    /// 写入数据
    @discardableResult
    func write(data : Data) -> Bool {
        if dgc_status != .connected { // 为连接写入数据失败
            return false
        }
        // 写入数据
        dgc_socket?.write(data: data, completion: {
//            NWLog("dgc_socket--写入数据成功")
        })
        return true
    }
    
    
}


extension DGCWebSocketHandler : WebSocketDelegate{

    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
            case .connected(let dgc_headers):
                NWLog("dgc_socket--连接成功headers=\(dgc_headers)")
                dgc_status = .connected
            case .disconnected(let dgc_reason, let dgc_code):
                NWLog("dgc_socket--断开连接-dgc_reason=\(dgc_reason)-dgc_code=\(dgc_code)")
                dgc_status = .normal
            case .text(let dgc_string):
                self.delegate?.socketHandler(didReadText: dgc_string)
                NWLog("dgc_socket--Received text: \(dgc_string)")
            case .binary(let dgc_data):
                self.delegate?.socketHandler(didRead: dgc_data)
//                NWLog("dgc_socket--Received dgc_data: \(dgc_data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                dgc_status = .normal
                NWLog("dgc_socket--断开连接-cancelled")
            case .dgc_error(let dgc_error):
                dgc_status = .normal
                NWLog("dgc_socket--断开连接-dgc_error=\(dgc_error?.localizedDescription ?? "")")
            case .peerClosed:
                   break
            }
    }
    
    
//    
//    
//    /// 连接成功
//    func dgc_socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
//        NWLog("dgc_socket--连接成功")
//        dgc_status = .connected
//        beginReadData()
//    }
//    
//    /// 断开连接
//    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
//        NWLog("dgc_socket--断开连接-err=\(err?.localizedDescription ?? "")")
//        dgc_status = .normal
//    }
//    
//    /// 收到消息
//    func dgc_socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
////        NWLog("dgc_socket--收到消息-tag=\(tag)-data=\(data.count)")
//        self.delegate?.socketHandler(didRead: data)
//        beginReadData(tag: tag)
//        
//    }
//
//    /// 写入数据成功
//    func dgc_socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
////        NWLog("dgc_socket--写入数据成功-tag=\(tag)")
//        beginReadData(tag: tag)
//    }
//    
////    // TCP成功获取安全验证
////    func socketDidSecure(_ sock: GCDAsyncSocket) {
////        NWLog("dgc_socket--socketDidSecure")
////    }
}
