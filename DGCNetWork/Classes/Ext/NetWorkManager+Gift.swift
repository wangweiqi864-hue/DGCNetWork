//
//  DGCNetWorkManager+DGCGift.swift
//  Pods
//
//  Created by mango-linwieyan on 2024/6/25.
//

import Foundation


public enum DGCGiftType {
    case normal // 普通默认
    case bag // 背包礼物
}

extension DGCNetWorkManager {
 
    
    public static func nw_sendGift(toIds : [Int64],
                                   giftId: UInt32,
                                   giftType: DGCGiftType = .normal,
                                   giftNum: Int32,
                                   msg: String = "",
                                   ifOutsideRoom: Bool,
                                   sendType: DGCGift_SendGiftType,
                                   sendGiftAction: DGCGift_SendGiftAction,
                                   success: DGCNetWorkSuccess<DGCGift_GiftPresentRes>? = nil,
                                   fail : DGCNetWorkFail? = nil) {
        
        if toIds.count == 1 {
            
            DGCNetWorkManager.nw_giftPresentReq(toId: toIds.first ?? 0,
                                             giftId: UInt32(giftId),
                                             giftType: giftType,
                                             giftNum: giftNum,
                                             msg: msg,
                                             ifOutsideRoom: ifOutsideRoom,
                                             sendType: sendType,
                                             sendGiftAction: sendGiftAction,
                                             success: success,
                                             fail: fail)
            
        } else {
            
            DGCNetWorkManager.nw_giftBatchPresentReq(toIds: toIds,
                                                  giftId: giftId,
                                                  giftType: giftType,
                                                  giftNum: giftNum,
                                                  msg: msg,
                                                  success: success,
                                                  fail: fail)
        }
    }
    
    //普通赠送
    private static func nw_giftPresentReq(toId : Int64,
                                          giftId: UInt32,
                                          giftType: DGCGiftType = .normal,
                                          giftNum: Int32,
                                          msg: String = "",
                                          ifOutsideRoom: Bool,
                                          sendType: DGCGift_SendGiftType,
                                          sendGiftAction: DGCGift_SendGiftAction,
                                          success : DGCNetWorkSuccess<DGCGift_GiftPresentRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCGift_GiftPresentReq()
        dgc_body.toID = toId
        dgc_body.giftNum = UInt32(giftNum)
        dgc_body.giftEntry = giftId
        dgc_body.ifOutsideRoom = ifOutsideRoom
        dgc_body.sendType = sendType
        dgc_body.action = sendGiftAction
        dgc_body.msg = msg
        
        let dgc_req = DGCNetWorkRequest<DGCGift_GiftPresentRes>(
            cmd: giftType == .bag ? .presentBag : .presentBuy,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
 
    //批量普通赠送
    private static func nw_giftBatchPresentReq(toIds : [Int64],
                                               giftId: UInt32,
                                               giftType: DGCGiftType = .normal,
                                               giftNum: Int32,
                                               msg: String = "",
                                               success : DGCNetWorkSuccess<DGCGift_GiftPresentRes>? = nil,fail : DGCNetWorkFail? = nil) {
        var dgc_body = DGCGift_GiftBatchPresentReq()
        dgc_body.giftEntry = giftId
        dgc_body.giftNum = UInt32(giftNum)
        dgc_body.msg = msg
        dgc_body.toIds = toIds
        
        let dgc_req = DGCNetWorkRequest<DGCGift_GiftPresentRes>(
            cmd: giftType == .bag ? .batchPresentBag : .batchPresentBuy,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_giftConfigReq(cacheType : DGCNetWorkCacheType = .cacheFromReq,success: DGCNetWorkSuccess<DGCGift_GiftConfigRes>? = nil,fail : DGCNetWorkFail? = nil) {
        let dgc_body = DGCGift_GiftConfigReq()
        let dgc_req = DGCNetWorkRequest<DGCGift_GiftConfigRes>(
            cmd: .GetGiftConfig,
            channel: .short,
            cacheType: cacheType,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_giftRoomGiftReq(roomId: Int64, success: DGCNetWorkSuccess<DGCGift_GiftRoomGiftRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCGift_GiftRoomGiftReq()
        dgc_body.roomID = roomId
        
        let dgc_req = DGCNetWorkRequest<DGCGift_GiftRoomGiftRes>(
            cmd: .GiftRoomGift,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_buyGiftReq(giftId: Int32, amount: Int32, success: DGCNetWorkSuccess<DGCGift_BuyGiftRes>? = nil,fail : DGCNetWorkFail? = nil) {
        var dgc_body = DGCGift_BuyGiftReq()
        dgc_body.giftID = giftId
        dgc_body.amount = amount
        
        let dgc_req = DGCNetWorkRequest<DGCGift_BuyGiftRes>(
            cmd: .GiftRoomGift,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    
    // 礼物面板获取整蛊列表
    public static func fetchGiftPanelPrankGameList(success: DGCNetWorkSuccess<DGCSystem_GiftPrankEnumGiftRes>? = nil,
                                            fail: DGCNetWorkFail? = nil
    ) {
        let dgc_body = DGCSystem_GiftPrankEnumGiftReq()
        let dgc_req = DGCNetWorkRequest<DGCSystem_GiftPrankEnumGiftRes>(
            cmd: .prankEnum,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
}
