//
//  DGCNetWorkManager+GiftWall.swift
//  Pods
//
//  Created by mango-linwieyan on 2024/9/20.
//

import Foundation

extension DGCNetWorkManager {
 
    public static func nw_wallListReq(playerId: Int64,
                                      success: DGCNetWorkSuccess<DGCGift_WallListResp>? = nil,
                                      fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCGift_WallListReq()
        dgc_body.playerID = playerId
        
        let dgc_req = DGCNetWorkRequest<DGCGift_WallListResp>(
            cmd: .WallListReq,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_grayGiftWallReq(playerId: Int64,
                                   success: DGCNetWorkSuccess<DGCGift_GrayGiftWallRes>? = nil,
                                   fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCGift_GrayGiftWallReq()
        dgc_body.playerID = playerId
        
        let dgc_req = DGCNetWorkRequest<DGCGift_GrayGiftWallRes>(
            cmd: .GrayGiftWallReq,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
        
    }
}
