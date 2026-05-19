//
//  DGCNetWorkManager+LuckBag.swift
//  DGCNetWork
//
//  Created by apple on 2025/7/17.
//

import Foundation

extension DGCNetWorkManager{
    
    /// 发福袋
    public static func nw_messageSendLuckBag(body:DGCPb_SendRedEnvelopeReq,success:DGCNetWorkSuccess<DGCPb_SendRedEnvelopeRes>?,fail:DGCNetWorkFail? = nil) {
        
        let dgc_req = DGCNetWorkRequest<DGCPb_SendRedEnvelopeRes>(
            cmd: .LiveLuckyBagSend,
            channel: .long,
            cacheType: .no,
            body: body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 发福袋记录
    public static func nw_querySendLuckBagRecords(page:Int64 = 1,pageSize:Int64 = 15,success:DGCNetWorkSuccess<DGCPb_QueryRedEnvelopeSendRes>?,fail:DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCPb_QueryRedEnvelopeSendReq()
        dgc_body.page = page
        dgc_body.size = pageSize
        
        let dgc_req = DGCNetWorkRequest<DGCPb_QueryRedEnvelopeSendRes>(
            cmd: .LiveLuckyBagSendRecords,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 单个福袋领取记录
    public static func nw_querySendLuckBagDetail(record_id:Int64 ,success:DGCNetWorkSuccess<DGCPb_QueryRedEnvelopeSendDetailRes>?,fail:DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCPb_QueryRedEnvelopeSendDetailReq()
        dgc_body.recordID = record_id
        
        let dgc_req = DGCNetWorkRequest<DGCPb_QueryRedEnvelopeSendDetailRes>(
            cmd: .LiveLuckyBagSendDetail,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    ///领取福袋记录
    public static func nw_queryLuckBagReceiveRecords(page:Int64 = 1,pageSize:Int64 = 15, success:DGCNetWorkSuccess<DGCPb_QueryRedEnvelopeReceiveRes>?,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCPb_QueryRedEnvelopeReceiveReq()
        dgc_body.page = page
        dgc_body.size = pageSize
        
        let dgc_req = DGCNetWorkRequest<DGCPb_QueryRedEnvelopeReceiveRes>(
            cmd: .LiveLuckyBagReceiveRecords,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    ///查询用户可领取的红包
    public static func nw_queryAvailableLuckBag(success:DGCNetWorkSuccess<DGCPb_QueryAvailableRedEnvelopeRes>?,fail:DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCPb_QueryAvailableRedEnvelopeReq()
     
        let dgc_req = DGCNetWorkRequest<DGCPb_QueryAvailableRedEnvelopeRes>(
            cmd: .LiveLuckyBagAvailable,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    ///查询红包的详情
    public static func nw_queryLuckBagDesc(bagID:Int64,success:DGCNetWorkSuccess<DGCPb_QueryRedEnvelopeInfoRes>?,fail:DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCPb_QueryRedEnvelopeInfoReq()
        dgc_body.bagID = bagID
        let dgc_req = DGCNetWorkRequest<DGCPb_QueryRedEnvelopeInfoRes>(
            cmd: .LiveLuckyBagDesc,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    ///领取红包
    public static func nw_receiveLuckBag(bagID:Int64,success:DGCNetWorkSuccess<DGCPb_ReceiveRedEnvelopeRes>?,fail:DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCPb_ReceiveRedEnvelopeReq()
        dgc_body.bagID = bagID
        let dgc_req = DGCNetWorkRequest<DGCPb_ReceiveRedEnvelopeRes>(
            cmd: .LiveLuckyBagReceive,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
}
