//
//  DGCNetWorkManager+IM.swift
//  Pods
//
//  Created by mango on 2024/3/11.
//

import Foundation

extension DGCNetWorkManager{
    
    /// im 登录授权
    public static func nw_imAuth(success :@escaping DGCNetWorkSuccess<DGCIM_UserSigRes>,fail :@escaping DGCNetWorkFail) {
        let dgc_body = DGCIM_UserSigReq()
        
        let dgc_req = DGCNetWorkRequest<DGCIM_UserSigRes>(
            cmd: .imLogin,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
}
