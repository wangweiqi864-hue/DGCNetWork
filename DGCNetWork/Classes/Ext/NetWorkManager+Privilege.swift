//
//  DGCNetWorkManager+Privilege.swift
//  Pods
//
//  Created by mango-linwieyan on 2024/7/8.
//

import Foundation

extension DGCNetWorkManager {
 
    public static func nw_GetPrivilegeConfReq(md5: String,cacheType : DGCNetWorkCacheType = .cacheFromReq,
                                              success:@escaping DGCNetWorkSuccess<DGCPrivilege_GetPrivilegeConfRes>,
                                              fail:@escaping DGCNetWorkFail) {
        
        var dgc_body = DGCPrivilege_GetPrivilegeConfReq()
        dgc_body.md5 = md5
        
        let dgc_req = DGCNetWorkRequest<DGCPrivilege_GetPrivilegeConfRes>(
            cmd: .GetPrivilegeConf,
            channel: .long,
            cacheType: cacheType,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_GetUserPrivilegesReq(playerId: Int64,
                                               ifWithInvalid: Bool,
                                               success:@escaping DGCNetWorkSuccess<DGCPrivilege_GetUserPrivilegesRes>,
                                               fail:@escaping DGCNetWorkFail) {
        
        var dgc_body = DGCPrivilege_GetUserPrivilegesReq()
        dgc_body.playerID = playerId
        dgc_body.ifWithInvalid = ifWithInvalid
        
        let dgc_req = DGCNetWorkRequest<DGCPrivilege_GetUserPrivilegesRes>(
            cmd: .GetUserPrivileges,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    public static func nw_SwitchUserPrivilege(userPrivilegeID: Int64,
                                              privilegeConfID: Int64,
                                              isOn: Bool,
                                              success:@escaping DGCNetWorkSuccess<DGCPrivilege_SwitchUserPrivilegeRes>,
                                              fail:@escaping DGCNetWorkFail) {
        
        var dgc_body = DGCPrivilege_SwitchUserPrivilegeReq()
        dgc_body.ifOn = isOn
        dgc_body.userPrivilegeID = userPrivilegeID
        dgc_body.privilegeConfID = privilegeConfID
        
        let dgc_req = DGCNetWorkRequest<DGCPrivilege_SwitchUserPrivilegeRes>(
            cmd: .SwitchUserPrivilege,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_liveFrameListReq(success:@escaping DGCNetWorkSuccess<DGCPrivilege_RoomFrameListRes>,
                                              fail:@escaping DGCNetWorkFail) {
        let dgc_body = DGCPrivilege_RoomFrameListReq()
        let dgc_req = DGCNetWorkRequest<DGCPrivilege_RoomFrameListRes>(
            cmd: .Live_FrameListReq,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
}
