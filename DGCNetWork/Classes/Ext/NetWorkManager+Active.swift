//
//  DGCNetWorkManager+Active.swift
//  DGCNetWork
//
//  Created by Runyalsj on 2025/7/9.
//

import Foundation


extension DGCNetWorkManager {
    // 请求banner
    public static func fetchBannerDatas(type: DGCHome_BannerJoinType,
                                        success: @escaping DGCNetWorkSuccess<DGCHome_GetJoinBannerDataRes>,
                                        fail: @escaping DGCNetWorkFail
    ) {
        var dgc_body = DGCHome_GetJoinBannerDataReq()
        dgc_body.type = type
        
        let dgc_req = DGCNetWorkRequest<DGCHome_GetJoinBannerDataRes>(
            cmd: .activeBannerData,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
}
