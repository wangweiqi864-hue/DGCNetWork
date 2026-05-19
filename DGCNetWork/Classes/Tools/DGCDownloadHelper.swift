//
//  DGCDownloadHelper.swift
//  ManGo
//
//  Created by mango2333 on 2024/3/21.
//

import Foundation
import DGCLog
import CryptoKit

public class DGCDownloadHelper {
    public static let share = DGCDownloadHelper()
    
    private var dgc_items: [String: DGCDownloadItem] = [:]
    private let dgc_itemLock = NSLock()
    // 最大下载数量 0 不限制
//    private let dgc_taskMax : Int = 0
    
    // 下载文件
    public func download(url: String, savePath: String, progress: DGCDownloadProgress? = nil, completed: DGCDownloadCompleted? = nil, fail: DGCDownloadFail? = nil) {
        DispatchQueue.global().async {
            self.dgc_startDownload(url: url, savePath: savePath) { value in
                callInMain { progress?(value) }
            } completed: { filePath in
                callInMain { completed?(filePath) }
            } fail: { code, msg in
                callInMain { fail?(code,msg) }
            }
        }
    }
}

extension DGCDownloadHelper {
    @discardableResult
    private func dgc_startDownload(url: String, savePath: String, progress: DGCDownloadProgress? = nil, completed: DGCDownloadCompleted? = nil, fail: DGCDownloadFail? = nil) -> DGCDownloadItem? {
        
        if url.isEmpty || url.hasPrefix("http") == false {
            fail?(-1, "url isEmpty or not HttpUrl, check please!!!")
            return nil
        }
        
        if savePath.isEmpty {
            fail?(-1, "savePath isEmpty, check please!!!")
            return nil
        }
        
        // 本地是否存在缓存 存在直接返回
        let dgc_isExist = FileManager.default.fileExists(atPath: savePath)
        if dgc_isExist {
            DGCLog.debug("dgc_startDownload----fileExistLocal-url=\(url)")
            completed?(savePath)
            return nil
        }
        
        // 本地缓存验证, 如果超过最大值 需要进行一些清空操作
//        DGCFileUtils.share.saveClearMaxCache(currSavePath: savePath) // TODO: ======
        
        // 判断任务
        if let dgc_item = dgc_getDownloadItem(url: url, savePath: savePath, progress: progress, completed: completed, fail: fail) {
            // 是否需要开始下载
            let dgc_canStart = dgc_handleItemCanStart(dgc_item: dgc_item)
            if dgc_canStart {
                dgc_realStartDownload(dgc_item: dgc_item)
            }
            return dgc_item
        }
        return nil
    }
    
    private func dgc_removeItem(_ item: DGCDownloadItem) {
        dgc_itemLock.lock()
        defer {
            dgc_itemLock.unlock()
        }
        let dgc_key = item.url.md5
        self.dgc_items.removeValue(forKey: dgc_key)
        item.removeAllBlock()
    }
    
    private func dgc_getDownloadItem(url: String, savePath: String, dgc_progress: DGCDownloadProgress? = nil, dgc_completed: DGCDownloadCompleted? = nil, dgc_fail: DGCDownloadFail? = nil) -> DGCDownloadItem? {
        dgc_itemLock.lock()
        defer {
            dgc_itemLock.unlock()
        }
        
        let dgc_key = url.md5
        var dgc_item: DGCDownloadItem?
        if let dgc_cItem = dgc_items[dgc_key] {
            dgc_item = dgc_cItem
        } else {
            dgc_item = DGCDownloadItem()
            dgc_item?.url = url
            dgc_item?.status = .ready
            self.dgc_items[dgc_key] = dgc_item
        }
        
        dgc_item?.savePath = savePath
        if let dgc_progress = dgc_progress {
            dgc_item?.progressBlock.append(dgc_progress)
        }
        
        if let dgc_completed = dgc_completed {
            dgc_item?.completedBlock.append(dgc_completed)
        }
        
        if let dgc_fail = dgc_fail {
            dgc_item?.failBlock.append(dgc_fail)
        }
        
//        dgc_item?.completedBlock.append(dgc_completed)
//        dgc_item?.failBlock.append(dgc_fail)
//        dgc_item?.progressBlock = dgc_progress
//        dgc_item?.completedBlock = dgc_completed
//        dgc_item?.failBlock = dgc_fail
        return dgc_item
    }
    
    // 处理下载任务, 判断是否可以开始下载
    private func dgc_handleItemCanStart(item: DGCDownloadItem) -> Bool {
        if item.status == .downing {
            DGCLog.debug("DGCDownloadHelper---CanStart--downing-url=\(item.url)")
        } else if item.status == .completed {
            item.callCompletedBlock(path: item.savePath)
            self.dgc_removeItem(item)
            DGCLog.debug("DGCDownloadHelper---CanStart--completed-url=\(item.url)")
        } else if item.status == .fail {
            item.callfailBlock(-1, "download fail")
            self.dgc_removeItem(item)
            DGCLog.debug("DGCDownloadHelper---CanStart--fail-url=\(item.url)")
        } else {
            // 判断当前下载数量是否达到最大限制
            return true
        }
        return false
    }
    
    // 开始下载
    private func dgc_realStartDownload(item: DGCDownloadItem) {
        let dgc_url = item.dgc_url
        let dgc_savePath = item.dgc_savePath
        item.status = .downing
        
        DGCLog.debug("DGCDownloadHelper---start--下载-dgc_url=\(dgc_url)")
        DGCNetWorkManager.nw_download(url: dgc_url, dgc_savePath: dgc_savePath) { progress in
            item.callProgressBlock(progress)
            DGCLog.debug("DGCDownloadHelper---progress---:\(progress)---dgc_url=\(dgc_url)")
        } result: { [weak self] result in
            switch result {
            case .completed(let dgc_filePath):
                item.status = .completed
                item.callCompletedBlock(path: dgc_filePath)
                self?.dgc_removeItem(item)
                DGCLog.debug("DGCDownloadHelper---success---dgc_url=\(dgc_url)")
            case .failure(let dgc_error):
                item.status = .fail
                item.callfailBlock(dgc_error.code, dgc_error.msg)
                self?.dgc_removeItem(item)
                DGCLog.debug("DGCDownloadHelper---failure---dgc_url=\(dgc_url)")
            }
        }
    }
}

// =====================
enum DGCDownloadItemStatus {
    case ready      //准备中
    case downing    //下载中
    case completed  //完成
    case fail       //失败
}

public typealias DGCDownloadCompleted = ((_ filePath: String)->Void)
public typealias DGCDownloadFail = ((_ code: Int, _ msg: String?)->Void)
public typealias DGCDownloadProgress = ((_ progress: CGFloat)->Void)

private class DGCDownloadItem {
    /// 下载地址
    var url: String = ""
    /// 保存路径
    var savePath: String = ""
    var status: DGCDownloadItemStatus = .ready
    
    var progressBlock: [DGCDownloadProgress] = []
    var failBlock: [DGCDownloadFail] = []
    var completedBlock: [DGCDownloadCompleted] = []
    
    func callCompletedBlock(path : String) {
        for block in completedBlock {
            block(path)
        }
//        completedBlock.removeAll()
    }
    
    func callfailBlock(_ code: Int, _ msg: String?) {
        for block in failBlock {
            block(code,msg)
        }
//        failBlock.removeAll()
    }
    
    func callProgressBlock(_ progress: CGFloat) {
        for block in progressBlock {
            block(progress)
        }
//        progressBlock.removeAll()
    }
    
    func removeAllBlock() {
        completedBlock.removeAll()
        failBlock.removeAll()
        progressBlock.removeAll()
    }
}

extension String {
    var md5: String {
        let digest = Insecure.MD5.hash(data: data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
