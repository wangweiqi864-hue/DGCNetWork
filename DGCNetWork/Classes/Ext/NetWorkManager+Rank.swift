//
//  DGCNetWorkManager+Rank.swift
//  Pods
//
//  Created by mango-linwieyan on 2024/8/27.
//

import Foundation

extension DGCNetWorkManager {
    
    // 获取平台排行榜相关数据
    public static func nw_GetRankReq(type: DGCRank_RankType, playerId: Int64, roomId: Int64, success:@escaping DGCNetWorkSuccess<DGCRank_GetRankRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCRank_GetRankReq()
        dgc_body.type = type
        dgc_body.playerID = playerId
        dgc_body.roomID = roomId
        
        let dgc_req = DGCNetWorkRequest<DGCRank_GetRankRes>(
            cmd: .GetRankReq,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_GetRoomHourRankReq(playerId: Int64, success:@escaping DGCNetWorkSuccess<DGCRank_GetRoomHourRankRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCRank_GetRoomHourRankReq()
        dgc_body.playerID = playerId
        
        let dgc_req = DGCNetWorkRequest<DGCRank_GetRoomHourRankRes>(
            cmd: .GetRoomHourRankReq,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }

    public static func nw_GetRoomRankReq(type: Int32, rank_flag:Int32, success:@escaping DGCNetWorkSuccess<DGCRank_GetRoomRankRes>,
                                         fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCRank_GetRoomRankReq()
        dgc_body.rankFlag = rank_flag
        dgc_body.type = type
        
        let dgc_req = DGCNetWorkRequest<DGCRank_GetRoomRankRes>(
            cmd: .GetRoomRankReq,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
}
