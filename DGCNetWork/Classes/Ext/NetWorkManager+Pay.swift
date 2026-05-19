//
//  DGCNetWorkManager+Pay.swift
//  Pods
//
//  Created by mango2333 on 2024/6/21.
//

import Foundation

extension DGCNetWorkManager {
    // 获取用户资产
    public static func nw_requestMinePayAssets(success: DGCNetWorkSuccess<DGCPay_AssetsMoneyRes>? = nil, fail: DGCNetWorkFail? = nil) {
        let dgc_body = DGCPay_AssetsMoneyReq()
        
        let dgc_req = DGCNetWorkRequest<DGCPay_AssetsMoneyRes>(
            cmd: .PayAssets,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 获取内购列表
    public static func nw_requestPayIAPList(success: DGCNetWorkSuccess<DGCPay_IapListRes>? = nil, fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCPay_IapListReq()
        dgc_body.packageName = DGCNetWorkManager.share.bundleID
        dgc_body.platform = "ios"
        
        let dgc_req = DGCNetWorkRequest<DGCPay_IapListRes>(
            cmd: .PayIAPList,
            channel: .long,
            cacheType: .cacheFromReq,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 验证iap票据
    public static func nw_requestPayVerifyIAP(targetId: Int64, transactionID: String, receipt: String, orderNo: String, orderSource: Bool, success: DGCNetWorkSuccess<DGCPay_VerifyIAPRes>? = nil, fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCPay_VerifyIAPReq()
        dgc_body.packageName = DGCNetWorkManager.share.bundleID
        dgc_body.accountID = targetId
        dgc_body.receipt = receipt
        dgc_body.transactionID = transactionID
        dgc_body.orderNo = orderNo
        dgc_body.orderSource = orderSource
        
        let dgc_req = DGCNetWorkRequest<DGCPay_VerifyIAPRes>(
            cmd: .PayVerifyIAP,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 创建内购订单
    public static func nw_requestPayCreateIAP(productID: String,success: DGCNetWorkSuccess<DGCPay_CreateOrderRes>? = nil, fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCPay_CreateOrderReq()
        dgc_body.packageName = DGCNetWorkManager.share.bundleID
        dgc_body.productID = productID
        
        let dgc_req = DGCNetWorkRequest<DGCPay_CreateOrderRes>(
            cmd: .PayCreateIAP,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 砖石兑换金币
    public static func nw_TicketChangeCoin(ticket: Int32,success: DGCNetWorkSuccess<DGCPay_TicketChangCoinRes>? = nil, fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCPay_TicketChangCoinReq()
        dgc_body.passwd = ""
        dgc_body.diamond = ticket
        
        let dgc_req = DGCNetWorkRequest<DGCPay_TicketChangCoinRes>(
            cmd: .PayTicketChange,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
}
