//
//  DGCNetWorkManager+Launch.swift
//  Pods
//
//  Created by mango on 2024/10/22.
//

import Foundation

extension DGCNetWorkManager{
    
    public static func nw_lanuchGetFutureSplashAds(pId : Int64, success : DGCNetWorkSuccess<DGCLanuch_GetFutureSplashAdsRes>?,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLanuch_GetFutureSplashAdsReq()
        dgc_body.playerID = pId
        
        let dgc_req = DGCNetWorkRequest<DGCLanuch_GetFutureSplashAdsRes>(
            cmd: .Lanuch_GetFutureSplashAds,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip : false, 
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
}
