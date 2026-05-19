//
//  DGCNetWorkManager+RoomOpt.swift
//  Pods
//
//  Created by mango-linwieyan on 2024/6/6.
//

import Foundation

extension DGCNetWorkManager {
 
    //
    public static func nw_forbidRoomActionReq(playerId: Int64, roomId:Int64, action:DGCLive_PlayerRoomActionType, success: @escaping DGCNetWorkSuccess<DGCLive_ForbidRoomActionRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_ForbidRoomActionReq()
        dgc_body.playerID = playerId
        dgc_body.roomID = roomId
        dgc_body.action = action
        
        let dgc_req = DGCNetWorkRequest<DGCLive_ForbidRoomActionRes>(
            cmd: .LiveForbidRoomAction,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_unforbidRoomActionReq(playerId: Int64, roomId:Int64, action:DGCLive_PlayerRoomActionType, success: @escaping DGCNetWorkSuccess<DGCLive_UnforbidRoomActionRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_UnforbidRoomActionReq()
        dgc_body.playerID = playerId
        dgc_body.roomID = roomId
        dgc_body.action = action
        
        let dgc_req = DGCNetWorkRequest<DGCLive_UnforbidRoomActionRes>(
            cmd: .LiveUnforbidRoomAction,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_queryRoomActionForbidListReq(page: Int32, roomId:Int64, action:DGCLive_PlayerRoomActionType, success: @escaping DGCNetWorkSuccess<DGCLive_QueryRoomActionForbidListRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_QueryRoomActionForbidListReq()
        dgc_body.page = page
        dgc_body.roomID = roomId
        dgc_body.action = action
        
        let dgc_req = DGCNetWorkRequest<DGCLive_QueryRoomActionForbidListRes>(
            cmd: .LiveQueryRoomActionForbidList,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_queryRoomActionForbidStatusReq(playerId: Int64, roomId:Int64, success: @escaping DGCNetWorkSuccess<DGCLive_QueryRoomActionForbidStatusRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_QueryRoomActionForbidStatusReq()
        dgc_body.playerIds = [playerId]
        dgc_body.roomID = roomId
        
        let dgc_req = DGCNetWorkRequest<DGCLive_QueryRoomActionForbidStatusRes>(
            cmd: .LiveQueryRoomActionForbidStatus,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 禁/开 设备 麦克风/摄像头
    public static func nw_liveSeatSpeakReq(device: DGCLive_SeatSetType, targetID:Int64,isBan : Bool, success: DGCNetWorkSuccess<DGCLive_SeatSpeakRes>? = nil,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_SeatSpeakReq()
        dgc_body.device = device
        dgc_body.targetID = targetID
        dgc_body.seatBan = isBan
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SeatSpeakRes>(
            cmd: .LiveSetSeatSpeak,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_liveSetAdmin(targetID: Int64, adminType: DGCCommon_RoomAdminType, success: DGCNetWorkSuccess<DGCLive_SetRoomAdminRes>? = nil,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_SetRoomAdminReq()
        dgc_body.toPlayerID = targetID
        dgc_body.adminType = adminType
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SetRoomAdminRes>(
            cmd: .LiveSetAdmin,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
}
