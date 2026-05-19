//
//  DGCNetWorkManager+PrankGame.swift
//  DGCNetWork
//
//  Created by Runyalsj on 2025/6/25.
//

import Foundation


extension DGCNetWorkManager {
    public static func requestPrankGameMenuUpdate(list: [DGCPb_PrankEnumInfo],
                                                  success: DGCNetWorkSuccess<DGCPb_PrankEnumUpdateRes>? = nil,
                                                  fail: DGCNetWorkFail? = nil
    ) {
        var dgc_body = DGCPb_PrankEnumUpdateReq()
        dgc_body.list = list
        
        let dgc_req = DGCNetWorkRequest<DGCPb_PrankEnumUpdateRes>(
            cmd: .LivePrankGameGiftsMenuUpdate,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    // 切换整蛊
    public static func changePrankGame(isStart: Bool,
                                      success: DGCNetWorkSuccess<DGCPb_PrankOptionRes>? = nil,
                                      fail: DGCNetWorkFail? = nil
    ) {
        var dgc_body = DGCPb_PrankOptionReq()
        dgc_body.option = isStart ? 1 : 2
        
        let dgc_req = DGCNetWorkRequest<DGCPb_PrankOptionRes>(
            cmd: .LivePrankGameOption,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    
    // 获取整蛊列表
    public static func fetchPrankGameList(roomID: Int64,
                                      success: DGCNetWorkSuccess<DGCPb_PrankEnumRes>? = nil,
                                      fail: DGCNetWorkFail? = nil
    ) {
        var dgc_body = DGCPb_PrankEnumReq()
        dgc_body.playerID = roomID
        
        let dgc_req = DGCNetWorkRequest<DGCPb_PrankEnumRes>(
            cmd: .LivePrankGameInfo,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
}
