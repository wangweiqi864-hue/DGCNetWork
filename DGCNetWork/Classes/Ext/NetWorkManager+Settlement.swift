//
//  DGCNetWorkManager+Settlement.swift
//  DGCNetWork
//
//  Created by apple on 2025/5/27.
//

import Foundation

extension DGCNetWorkManager{
    
    /// 视频直播结算页数据
    public static func nw_queryLiveRoomFinalData(success : DGCNetWorkSuccess<DGCLive_QueryLiveRoomFinalDataRes>?,fail : DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCLive_QueryLiveRoomFinalDataReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_QueryLiveRoomFinalDataRes>(
            cmd: .Live_QueryLiveRoomFinalData,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
}
