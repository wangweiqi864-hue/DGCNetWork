//
//  DGCNetWorkAttr.swift
//  Pods
//
//  Created by mango on 2024/2/21.
//

import Foundation
import DGCLog

// MARK: 外部公开的属性
//成功回调
public typealias DGCNetWorkSuccess<T> = ((T) -> Void)

//成功回调 空
public typealias DGCNetWorkEmptySuccess = (() -> Void)

//失败回调
public typealias DGCNetWorkFail = ((_ error : DGCNetWorkError) -> Void)

/// 网络状态改变的通知
public let DGCNetWorkNotiNetStatusChanged = Notification.Name(rawValue: "DGCNetWorkNotiNetStatusChanged")

public enum DGCNetWorkStatus {
    case NO // 没网
    case GG // 蜂窝网络
    case WIFI // Wi-Fi
}

// MARK: 只能内部使用的属性

// 回到主线程
internal func callInMain(_ block :@escaping (()->Void)) {
    if Thread.isMainThread{ block() }
    else{DispatchQueue.main.async {block()}}
}


internal func NWLog(_ msg : String, file: String = #file){
//    DGCLog.info("DGCNetWork--\(msg)")
    DGCLog.log("DGCNetWork--\(msg)",file: file)
}

// 下载结果回调
public typealias DGCNetWorkDownloadResponse = ((_ result: DGCNetWorkDownloadResult) -> Void)
// 下载进度回调
public typealias DGCNetWorkDownloadProgress = ((CGFloat) -> Void)

public enum DGCNetWorkDownloadResult {
    // String is savePath
    case completed(String)
    case failure(DGCNetWorkError)
}
