//
//  DGCNetWorkManager+VIP.swift
//  DGCNetWork
//
//  Created by apple on 2025/12/29.
//

import Foundation

extension DGCNetWorkManager {
    
    // vip全局配置
    public static func nw_vipConfig(success:@escaping DGCNetWorkSuccess<DGCVip_UserVipInfoRes>,
                                              fail:@escaping DGCNetWorkFail) {
        let dgc_body = DGCVip_UserVipInfoReq()
        
        let dgc_req = DGCNetWorkRequest<DGCVip_UserVipInfoRes>(
            cmd: .VIPGlobalConfigs,
            channel:.long,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // vip购买
    public static func nw_vip4buy(lv:Int64, success:@escaping DGCNetWorkSuccess<DGCVip_BuyVipRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCVip_BuyVipReq()
        dgc_body.vipLevel = lv
        let dgc_req = DGCNetWorkRequest<DGCVip_BuyVipRes>(
            cmd: .VIPPurchase,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // vip特权设置
    public static func nw_vipPrivilegeSet(setType:DGCVip_UserAnonSettingType, status:Bool, success:@escaping DGCNetWorkSuccess<DGCVip_UserAnonSettingRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCVip_UserAnonSettingReq()
        dgc_body.setting = setType
        dgc_body.stat = status
        let dgc_req = DGCNetWorkRequest<DGCVip_UserAnonSettingRes>(
            cmd: .VIPPrivilegeSettingReq,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // vip特权设置查询
    public static func nw_vipPrivilegeSetList(success:@escaping DGCNetWorkSuccess<DGCVip_UserAnonSettingListRes>,
                                              fail:@escaping DGCNetWorkFail) {
        let dgc_body = DGCVip_UserAnonSettingListReq()
        
        let dgc_req = DGCNetWorkRequest<DGCVip_UserAnonSettingListRes>(
            cmd: .VIPPrivilegeListReq,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
}
