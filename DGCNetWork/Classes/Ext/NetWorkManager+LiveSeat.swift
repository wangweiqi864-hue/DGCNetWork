//
//  DGCNetWorkManager+LiveSeat.swift
//  Pods
//
//  Created by mango on 2024/6/5.
//

import Foundation

extension DGCNetWorkManager{
    
    /// 上麦 0:正常上麦 1:邀请上麦
    public static func nw_live_seatUp(seatID : Int32, source:Int32, success: DGCNetWorkSuccess<DGCLive_SeatSitRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_SeatSitReq()
        dgc_body.seatID = seatID
        dgc_body.source = source
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SeatSitRes>(
            cmd: .LiveSeatUp,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 移麦
    public static func nw_live_seatMove(from : Int32,to : Int32, success: DGCNetWorkSuccess<DGCLive_SeatMoveRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_SeatMoveReq()
        dgc_body.fromSeatID = from
        dgc_body.toSeatID = to
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SeatMoveRes>(
            cmd: .LiveSeatMove,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 下麦
    public static func nw_live_seatLeave(playerId : Int64,seatID : Int32, success: DGCNetWorkSuccess<DGCLive_SeatLeaveRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_SeatLeaveReq()
        dgc_body.targetID = playerId
        dgc_body.seatID = seatID
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SeatLeaveRes>(
            cmd: .LiveSeatLeave,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 设置坑位发言开关
    public static func nw_live_setSeatSpeakOnOff(seatSpeakOnoff : Bool,success: DGCNetWorkSuccess<DGCLive_SeatSpeakOnOffRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_SeatSpeakOnOffReq()
        dgc_body.seatSpeakOnoff = seatSpeakOnoff
        dgc_body.device = .utMic
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SeatSpeakOnOffRes>(
            cmd: .LiveSetSeatSpeakOnOff,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 是否打开摄像头
    public static func nw_live_switchCameraStatus(isCameraOn : Bool,reason : DGCLive_CameraChangeReason,success: DGCNetWorkSuccess<DGCLive_SwitchCameraStatusRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_SwitchCameraStatusReq()
        dgc_body.isCameraOn = isCameraOn
        dgc_body.reason = reason
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SwitchCameraStatusRes>(
            cmd: .LiveSwitchCameraStatus,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 邀请上麦
    public static func nw_live_seatInvite(playerId : Int64,seatID : Int32,success: DGCNetWorkSuccess<DGCLive_InviteChairRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_InviteChairReq()
        dgc_body.playerID = playerId
        dgc_body.chairID = seatID
        
        let dgc_req = DGCNetWorkRequest<DGCLive_InviteChairRes>(
            cmd: .LiveSeatInvite,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 踢下麦
    public static func nw_live_seatKick(playerId : Int64,success: DGCNetWorkSuccess<DGCLive_KickChairRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_KickChairReq()
        dgc_body.playerID = playerId
        
        let dgc_req = DGCNetWorkRequest<DGCLive_KickChairRes>(
            cmd: .LiveSeatKick,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 麦位禁音或者解禁
    public static func nw_live_muteChair(chairId : Int32, muted: Bool, success: DGCNetWorkSuccess<DGCLive_MuteChairRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_MuteChairReq()
        dgc_body.chairID = chairId
        dgc_body.muted = muted
    
        let dgc_req = DGCNetWorkRequest<DGCLive_MuteChairRes>(
            cmd: .LiveMuteChair,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }

    public static func nw_live_lockChairReq(chairId : Int32, lockStatus: DGCLive_ChairLockStatus,success: DGCNetWorkSuccess<DGCLive_LockChairRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_LockChairReq()
        dgc_body.chairID = chairId
        dgc_body.status = lockStatus
        
        let dgc_req = DGCNetWorkRequest<DGCLive_LockChairRes>(
            cmd: .LiveLockChair,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
}
