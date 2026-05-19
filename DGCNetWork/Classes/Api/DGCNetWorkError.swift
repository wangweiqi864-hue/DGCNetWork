//
//  DGCNetWorkError.swift
//  Pods
//
//  Created by mango on 2024/2/21.
//

import Foundation

// 自定义的错误码
public let DGCNetWorkErrorCode_System = 999999 // 系统异常
public let DGCNetWorkErrorCode_NetErr = 999998 // 网络异常
public let DGCNetWorkErrorCode_TimeOut = 999997 // 请求超时


public enum DGCNetworkErrorCode: Int {
    case unknown = -1
    
    // 常规错误码
    case tokenExpired = 1001
    case userNotFound = 1002
    case permissionDenied = 1003
    case liveBroadcastForbid = 71076 // 直播间封禁
    
    // 公共错误码
    case system = 999999 // 系统异常
    case network = 999998 // 网络异常
    case timeout = 999997 // 请求超时

    /// 多语言 key
    public var localizationKey: String {
        switch self {
            // TODO: - 演示用例 业务需要准确替换
        case .tokenExpired: return "TokenExpired"
        case .userNotFound: return "UserNotFound"
        case .permissionDenied: return "PermissionDenied"
        case .liveBroadcastForbid: return "LiveBroadcastForbid"
        
        // 网络层错误
        case .system: return "SystemError"
        case .network: return "NetError"
        case .timeout: return "NetError"
            
        case .unknown: return "UnknownError"
        }
    }
}

// 错误码过滤器
class DGCErrorDisplayFilter {
    /// 被过滤的错误码（无需 toast）
    private static let filteredCodes: Set<DGCNetworkErrorCode> = [
        .tokenExpired,
        .liveBroadcastForbid
    ]
    /// 判断是否需要展示 Toast
    static func shouldDisplayToast(for code: Int) -> Bool {
        let dgc_errorCode = DGCNetworkErrorCode(rawValue: code) ?? .unknown
        return !filteredCodes.contains(dgc_errorCode)
    }
}

public class DGCNetWorkError {
    public internal(set) var code = 0
    public var msg: String?
    
    public let rawCode: DGCNetworkErrorCode
    // 显示信息
    public private(set) var displayMessage: String?

    public init(code: Int = DGCNetWorkErrorCode_System, msg: String? = nil) {
        self.code = code
        self.msg = msg
        // 映射客户端本地 error code
        self.rawCode = DGCNetworkErrorCode(rawValue: code) ?? .unknown
    }

    /// 外部调用多语言工具转化为内部展示内容 一次性绑定本地化展示文案， 供外部使用
    public func bindDisplayMessage(localizedTransform: (String) -> String) {
        if rawCode == .unknown {
            // 本地映射后未定义 则直接使用服务端
            self.displayMessage = msg
            return
        }
        // 使用 DGCNetworkErrorCode 提供的 本地化 key
        let dgc_localizedKey = rawCode.localizationKey
        self.displayMessage = localizedTransform(dgc_localizedKey)
    }
}




//public class DGCNetWorkError {
//    public internal(set) var code = 0
//    public var msg : String?
//    
//    // 默认系统异常
//    public init(code: Int = DGCNetWorkErrorCode_System, msg: String? = nil) {
//        self.code = code
////        if msg == nil {
////            if code == DGCNetWorkErrorCode_System {
//////                self.msg = "系统异常"
////            }else if code == DGCNetWorkErrorCode_NetErr {
//////                self.msg = "网络异常"
////            }
////        }else{
////            self.msg = msg
////        }
//        self.msg = msg
//    }
//    
//    public init(){}
//}
//



