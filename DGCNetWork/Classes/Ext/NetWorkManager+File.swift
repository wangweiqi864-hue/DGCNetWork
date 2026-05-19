//
//  DGCNetWorkManager+File.swift
//  Pods
//
//  Created by mango2333 on 2024/3/21.
//

import Foundation

// 管理文件的上传和下载
extension DGCNetWorkManager {
    /// 下载文件
    public static func nw_download(url: String, savePath: String, downloadProgress: DGCNetWorkDownloadProgress? = nil, result: DGCNetWorkDownloadResponse? = nil) {
        let dgc_saveURL = URL(fileURLWithPath: savePath)
        DGCNetWorkShortHandler.download(url: url, dgc_saveURL: dgc_saveURL, result: result)
    }
}
