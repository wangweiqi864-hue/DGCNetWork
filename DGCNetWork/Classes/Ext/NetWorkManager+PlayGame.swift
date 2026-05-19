//
//  DGCNetWorkManager+PlayGame.swift
//  Pods
//
//  Created by mango on 2024/10/14.
//

import Foundation

extension DGCNetWorkManager{
    
    /// 真心话大冒险操作
    public static func nw_liveTrueTalkOpt(dgc_req : DGCLive_TrueTalkOptReq,autoShowErrTip : Bool = true, success: @escaping DGCNetWorkSuccess<DGCLive_TrueTalkOptRes>,fail: DGCNetWorkFail? = nil) {

        let dgc_req = DGCNetWorkRequest<DGCLive_TrueTalkOptRes>(
            cmd: .Live_TrueTalkOpt,
            channel: .long,
            body: dgc_req,
            autoShowErrTip: autoShowErrTip,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
}
