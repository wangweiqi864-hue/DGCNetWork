//
//  DGCNetWorkManager+MadeGift.swift
//  DGCNetWork
//
//  Created by admin on 2026/1/15.
//

import Foundation

extension DGCNetWorkManager{
  
    ///  定制礼物
    public static func nw_submitMadeGift(giftName: String, giftCover: String, giftFile: String, success: @escaping DGCNetWorkSuccess<DGCGift_CustomGiftSubmitRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCGift_CustomGiftSubmitReq()
        dgc_body.name = giftName
        dgc_body.icon = giftCover
        dgc_body.file = giftFile
        let dgc_req = DGCNetWorkRequest<DGCGift_CustomGiftSubmitRes>(
            cmd: .DGCCustomGiftSubmit,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    // 请求我的定制礼物数据
    public static func nw_mineMadeGiftList(success: @escaping DGCNetWorkSuccess<DGCGift_CustomGiftInfoRes>, fail: @escaping DGCNetWorkFail) {
        let dgc_body = DGCGift_CustomGiftInfoReq()
        let dgc_req = DGCNetWorkRequest<DGCGift_CustomGiftInfoRes>(
            cmd: .CustomGiftInfo,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 删除自定义礼物数据
    public static func nw_delegeMadeGift(giftId: Int64, success: @escaping DGCNetWorkSuccess<DGCGift_CustomGiftDeleteRes>, fail: @escaping DGCNetWorkFail) {
        var dgc_body = DGCGift_CustomGiftDeleteReq()
        dgc_body.id = giftId
        let dgc_req = DGCNetWorkRequest<DGCGift_CustomGiftDeleteRes>(
            cmd: .CustomGiftDelete,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    // 续期自定义礼物
    public static func nw_renewMadeGift(giftId: Int64, success: @escaping DGCNetWorkSuccess<DGCGift_CustomGiftRenewRes>, fail: @escaping DGCNetWorkFail) {
        var dgc_body = DGCGift_CustomGiftRenewReq()
        dgc_body.id = giftId
        let dgc_req = DGCNetWorkRequest<DGCGift_CustomGiftRenewRes>(
            cmd: .CustomGiftRenew,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    // 请求定制礼物榜单数据
    public static func nw_madeGiftRankList(page: Int64,
                                           pageSize: Int64,
                                           success: @escaping DGCNetWorkSuccess<DGCGift_CustomGiftRankRes>, fail: @escaping DGCNetWorkFail) {
        var dgc_body = DGCGift_CustomGiftRankReq()
        dgc_body.page = page
        dgc_body.pageSize = pageSize
        
        let dgc_req = DGCNetWorkRequest<DGCGift_CustomGiftRankRes>(
            cmd: .DGCCustomGiftRank,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
}

