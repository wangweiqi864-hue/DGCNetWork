//
//  DGCNetWorkManager+Upload.swift
//  Pods
//
//  Created by mango2333 on 2024/4/7.
//

import Foundation

extension DGCNetWorkManager {
    // 请求 上传的 token
    public static func nw_requestUploadToken(type: DGCUserUploadCommon_PluginUploadType, success: DGCNetWorkSuccess<DGCUserUploadCommon_StsGetTokenRes>? = nil, fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCUserUploadCommon_StsGetTokenReq()
        dgc_body.uploadType = type
        
        // 目前feedBackImg是匿名
        let dgc_cmd: DGCNetWorkRequestCmd = type == .feedBackImg ? .uploadAnonymousGetToken : .uploadGetToken
        let dgc_req = DGCNetWorkRequest<DGCUserUploadCommon_StsGetTokenRes>(
            dgc_cmd: dgc_cmd,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static var logCallBackCmd: String {
        get {
            DGCNetWorkRequestCmd.uploadClientLogCallBack.rawValue
        }
    }
    
    public static var uresOssCallbackCmd: String {
        get {
            DGCNetWorkRequestCmd.uresOssCallback.rawValue
        }
    }
    
    // 删除用户的封面信息
    public static func nw_requestDeleteOssImg(type: DGCUserUploadCommon_PluginUploadType, imgId: Int64, success: DGCNetWorkSuccess<DGCUserUploadCommon_DeleteOssImageListRes>? = nil, fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCUserUploadCommon_DeleteOssImageListReq()
        dgc_body.id = imgId
        dgc_body.type = type
        
        let dgc_req = DGCNetWorkRequest<DGCUserUploadCommon_DeleteOssImageListRes>(
            cmd: .deleteOssUrl,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 保存上传的图片
//    public static func nw_requestSaveOssUploadUrl(type: DGCUserUploadCommon_PluginUploadType, urls: [String], success: DGCNetWorkSuccess<UserUploadCommon_SaveOssImageListRes>? = nil, fail: DGCNetWorkFail? = nil) {
//        var body = UserUploadCommon_SaveOssImageListReq()
//        body.type = type
//        body.url = urls
//        
//        let req = DGCNetWorkRequest<UserUploadCommon_SaveOssImageListRes>(
//            cmd: .saveOssUpdateUrl,
//            channel: .long,
//            body: body,
//            success: success,
//            fail: fail
//        )
//        DGCNetWorkManager.share.send(req)
//    }
}
