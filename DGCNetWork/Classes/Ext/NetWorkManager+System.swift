//
//  DGCNetWorkManager+System.swift
//  Pods
//
//  Created by mango on 2024/6/24.
//

import Foundation

extension DGCNetWorkManager {
    
    // 获取开关状态
    public static func nw_SystemGetOOStatus(playerID: Int64, success:@escaping DGCNetWorkSuccess<DGCSystem_GetOOListRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCSystem_GetOOListReq()
        // 服务端说用户ID不需要传
        dgc_body.playerID = playerID
        
        let dgc_req = DGCNetWorkRequest<DGCSystem_GetOOListRes>(
            cmd: .MineGetOOStatus,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 获取表情包配置
    public static func nw_SystemGetExpressionConfig(success:@escaping DGCNetWorkSuccess<DGCPBExpression_PlayerMicFaceCategoryRes>,
                                              fail:@escaping DGCNetWorkFail) {
        let dgc_body = DGCPBExpression_PlayerMicFaceCategoryReq ()
        
        let dgc_req = DGCNetWorkRequest<DGCPBExpression_PlayerMicFaceCategoryRes>(
            cmd: .SystemGetExpressionConfig,
            channel: .short,
            cacheType: .cacheFromReq,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 获取表情分组下的列表
    public static func nw_SystemGetGroupToExpressionList(gId : Int32, success:@escaping DGCNetWorkSuccess<DGCPBExpression_MicFaceListRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCPBExpression_MicFaceListReq()
        dgc_body.micFaceCategoryID = gId
        
        let dgc_req = DGCNetWorkRequest<DGCPBExpression_MicFaceListRes>(
            cmd: .SystemGetGroupToExpressionList,
            channel: .short,
            cacheType: .cacheFromReq,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_SystemGetNoAuthBeforeLoginReq(version: String, success:@escaping DGCNetWorkSuccess<DGCSystem_GetNoAuthBeforeLoginRes>, fail:@escaping DGCNetWorkFail) {
        
        var dgc_body = DGCSystem_GetNoAuthBeforeLoginReq()
        dgc_body.device = DGCCommon_DeviceType.dtIosPhone
        dgc_body.version = version
        
        let dgc_req = DGCNetWorkRequest<DGCSystem_GetNoAuthBeforeLoginRes>(
            cmd: .SystemGetNoAuthBeforeLoginReq,
            channel: .short,
            cacheType: .reqAfterCache,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_QueryRedEnvelopeConfInfo(success:@escaping DGCNetWorkSuccess<DGCPb_QueryRedEnvelopeConfRes>, fail:@escaping DGCNetWorkFail) {
        
        let dgc_body = DGCPb_QueryRedEnvelopeConfReq()
        
        let dgc_req = DGCNetWorkRequest<DGCPb_QueryRedEnvelopeConfRes>(
            cmd: .LiveLuckyBagConfig,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_SystemGetVersionInfo(uId: Int64, success:@escaping DGCNetWorkSuccess<DGCSystem_DeviceReportRes>, fail:@escaping DGCNetWorkFail) {
        
        var dgc_body = DGCSystem_DeviceReportReq()
        
        let dgc_device = UIDevice.current.modelName;
        let dgc_appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        let dgc_nStatus = DGCNetWorkStatusHandler.share.dgc_nStatus
        var dgc_network: DGCSystem_NetworkType = .ntZero
        if dgc_nStatus == .WIFI {
            dgc_network = .ntWifi
        }else if dgc_nStatus == .GG {
            dgc_network = .nt4G
        }
        dgc_body.dgc_network = dgc_network
        dgc_body.phoneBrand = dgc_device
        dgc_body.uid = uId
        
        dgc_body.deviceID = UIDevice.getUUID()
        dgc_body.deviceType = .dtIosPhone
        dgc_body.clientVersion = dgc_appVersion
        
        let dgc_req = DGCNetWorkRequest<DGCSystem_DeviceReportRes>(
            cmd: .System_VersionInfo,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // h5游戏
    public static func nw_SystemGetWebGame(success:@escaping DGCNetWorkSuccess<DGCSystem_GetH5GameConfRes>, fail:@escaping DGCNetWorkFail) {
        
        let dgc_body = DGCSystem_GetH5GameConfReq()
        
        let dgc_req = DGCNetWorkRequest<DGCSystem_GetH5GameConfRes>(
            cmd: .System_WebGame,
            channel: .long,
            cacheType: .cacheFromReq,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_SystemGetGiftEffect(cacheType : DGCNetWorkCacheType, success:@escaping DGCNetWorkSuccess<DGCSystem_GetGiftEffectRes>, fail:@escaping DGCNetWorkFail) {
        
        let dgc_body = DGCSystem_GetGiftEffectReq()
        
        let dgc_req = DGCNetWorkRequest<DGCSystem_GetGiftEffectRes>(
            cmd: .System_GetGiftEffect,
            channel: .short,
            cacheType: cacheType,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
            )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_QueryHaveSaudiFlagReq(uid : Int64, success:@escaping DGCNetWorkSuccess<DGCSystem_QueryHaveSaudiFlagResp>, fail:@escaping DGCNetWorkFail) {
        
        var dgc_body = DGCSystem_QueryHaveSaudiFlagReq()
        dgc_body.playerID = uid
        let dgc_req = DGCNetWorkRequest<DGCSystem_QueryHaveSaudiFlagResp>(
            cmd: .queryHaveSaudiFlag,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
            )
        DGCNetWorkManager.share.send(dgc_req)
    }
}
