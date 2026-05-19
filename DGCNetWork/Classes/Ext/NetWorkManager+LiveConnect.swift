//
//  DGCNetWorkManager+LiveConnect.swift
//  Pods
//
//  Created by mango2333 on 2025/4/8.
//

import Foundation

// 视频房 连线pk相关接口
extension DGCNetWorkManager {
    // 获取PK推荐房间列表
    public static func nw_LiveConnectRoomListReq(optType: DGCLive_RoomBattleOptType, success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattleRoomListRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_RoomBattleRoomListReq()
        dgc_body.optType = optType
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattleRoomListRes>(
            cmd: .Live_Connect_RoomList,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // PK邀请 type
    public static func nw_LiveConnectInviteReq(optType: DGCLive_RoomBattleOptType, inviteId: Int64, cancel: Bool, success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattleInviteRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_RoomBattleInviteReq()
        dgc_body.optType = optType
        dgc_body.inviteID = inviteId
        dgc_body.cancel = cancel
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattleInviteRes>(
            cmd: .Live_Connect_Invite,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 自动匹配PK type: 操作类型:1 匹配 2 取消
    public static func nw_LiveConnectMatchReq(type: Int32, optType: DGCLive_RoomBattleOptType, success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattleMatchRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_RoomBattleMatchReq()
        dgc_body.type = type
        dgc_body.optType = optType
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattleMatchRes>(
            cmd: .Live_Connect_Match,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 拒绝PK邀请 type  // 邀请类型:1直接邀请 2自动邀请
    public static func nw_LiveConnectRejectReq(id: Int64, inviteOrMatch: Int32, success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattleRejectRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_RoomBattleRejectReq()
        dgc_body.id = id
        dgc_body.inviteOrMatch = inviteOrMatch
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattleRejectRes>(
            cmd: .Live_Connect_Reject,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 接受PK邀请
    public static func nw_LiveConnectAcceptReq(id: Int64, inviteOrMatch: Int32, success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattleAcceptRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_RoomBattleAcceptReq()
        dgc_body.id = id
        dgc_body.inviteOrMatch = inviteOrMatch
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattleAcceptRes>(
            cmd: .Live_Connect_Accept,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 请求视频连线pk相关信息
    public static func nw_LiveConnectPKInfoReq(roomId: Int64, success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattlePkInfoRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_RoomBattlePkInfoReq()
        dgc_body.roomID = roomId
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattlePkInfoRes>(
            cmd: .Live_Connect_Info,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 请求pk历史记录
    public static func nw_LiveConnectPKHistoryReq(success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattlePkHistoryRes>,fail: DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCLive_RoomBattlePkHistoryReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattlePkHistoryRes>(
            cmd: .Live_Connect_PKHistory,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 取消pk cancelType = 1; // 1结束连线 2结束pk 3结束直播
    public static func nw_LiveConnectCancleReq(cancelType: Int32, success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattleCancelPkRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_RoomBattleCancelPkReq()
        dgc_body.cancelType = cancelType
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattleCancelPkRes>(
            cmd: .Live_Connect_Cancle,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 开始pk startType: 1连线 2再来一局
    public static func nw_LiveConnectPkStartReq(startType: Int32, success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattleStartPkRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_RoomBattleStartPkReq()
        dgc_body.startType = startType
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattleStartPkRes>(
            cmd: .Live_Connect_StartPK,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 关闭对方的声音
    public static func nw_LiveConnectCloseMicReq(isCloseOtherMic: Bool, success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattleCloseMicRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_RoomBattleCloseMicReq()
        dgc_body.isCloseOtherMic = isCloseOtherMic
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattleCloseMicRes>(
            cmd: .Live_Connect_CloseMic,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 获取pk贡献榜单
    public static func nw_LiveConnectHistoryRankReq(pkId: Int64, roomId: Int64, success: @escaping DGCNetWorkSuccess<DGCLive_RoomBattlePkHistoryRankRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_RoomBattlePkHistoryRankReq()
        dgc_body.pkID = pkId
        dgc_body.roomID = roomId
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBattlePkHistoryRankRes>(
            cmd: .Live_Connect_PKHistoryRank,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
}
