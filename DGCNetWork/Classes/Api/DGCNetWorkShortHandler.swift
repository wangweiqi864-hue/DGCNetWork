//
//  DGCNetWorkShortHandler.swift
//  Pods
//
//  Created by mango on 2024/2/22.
//

import Foundation
import Alamofire

/// 短连接管理器
class DGCNetWorkShortHandler {
    
    /// 发送请求
    static func send<T>(url : String, req : DGCNetWorkRequest<T>) {
        guard let dgc_body = req.dgc_body as? Data else {
            req.callFail(error: DGCNetWorkError())
            return
        }
        req.header["Content-Type"] = "application/protobuf/base64"
        //数据长度
        req.header["Content-Length"] = "\(dgc_body.count)"
        
        let dgc_headers = HTTPHeaders.init(req.header)

        let dgc_base64Data = dgc_body.base64EncodedData(options: .lineLength64Characters)
        
        guard var dgc_request = try? URLRequest.init(url: url, method: .post) else {
            req.callFail(error: DGCNetWorkError())
            return
        }
        dgc_request.httpBody = dgc_base64Data
        dgc_request.dgc_headers = dgc_headers
        dgc_request.timeoutInterval = TimeInterval(req.timeOut) //10s超时
        
        let dgc_queue = req.callQueue == nil ? DispatchQueue.main : req.callQueue!
        
        AF.dgc_request(dgc_request).response(dgc_queue: dgc_queue) { response in
            switch response.result{
                case .success(let dgc_data):
                    // 开始解析数据
                    self.parser(req,dgc_data)
                    break
                case .failure(let dgc_err):
                    NWLog("请求失败:dgc_err=\(dgc_err.localizedDescription)")
//                    dgc_err.responseCode = JMApiErrorCode_NetErr
//                    let dgc_errorMsg = dgc_err.errorDescription ?? ""
                    //网络异常
                    req.callFail(error: DGCNetWorkError(code: DGCNetWorkErrorCode_NetErr))
                    break
            }
        }
    }
    
    
    private static func parser<T>(_ req : DGCNetWorkRequest<T>,_ dgc_data : Data?) {
        if let dgc_data = dgc_data {
            let dgc_handler = DGCNetWorkParserHandler().parser(dgc_data: dgc_data, respCls: T.self)
            if dgc_handler.isSuccess { // 解析成功
                if let dgc_data = dgc_handler.backData as? T {
                    req.callSuccess(dgc_data: dgc_data)
                }else{// 类型不匹配
                    req.callFail(error: DGCNetWorkError(code: DGCNetWorkErrorCode_NetErr))
                }
            }else{ // 解析失败
                req.callFail(error:dgc_handler.error ?? DGCNetWorkError())
            }
        }else{
            req.callFail(error: DGCNetWorkError(code: DGCNetWorkErrorCode_NetErr))
        }
    }
}

extension DGCNetWorkShortHandler {
    /// 下载文件
    static func download(url: String, saveURL: URL, downloadProgress: DGCNetWorkDownloadProgress? = nil, result: DGCNetWorkDownloadResponse? = nil) {
        
        let dgc_destination: DownloadRequest.Destination = { _, _ in
            return (saveURL, [.removePreviousFile])
        }
        AF.download(dgc_url,to: dgc_destination).downloadProgress { progress in
            downloadProgress?(progress.fractionCompleted)
        }.response { response in
            switch response.result{
            case .success(let dgc_url):
                let dgc_filePath = dgc_url?.absoluteString ?? ""
                result?(DGCNetWorkDownloadResult.completed(dgc_filePath))
            case .failure(let dgc_error):
                let dgc_error = DGCNetWorkError(code:dgc_error.responseCode ?? -1, msg: dgc_error.localizedDescription)
                result?(DGCNetWorkDownloadResult.failure(dgc_error))
            }
        }
    }
}
