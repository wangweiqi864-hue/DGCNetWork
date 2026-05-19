//
//  DGCNetWorkManager+DGCRoom.swift
//  DGCNetWork
//
//  Created by mango on 2024/2/28.
//

import Foundation

extension DGCNetWorkManager{
    
    public struct DGCNWEnterRoomFollowInfo {
        ///跟随id
        public var followID: Int64 = 0
        ///跟随昵称
        public var followName: String = String()
        /// 跟随类型，默认为0=原来跟随进来，1=xxx被xxx接引进来, 2=xxx在广播交友跟随xxx的脚步进入房间 3=第三方
        public var followType: Int32 = 0
        public var followMsg: String = String()
        public init() {}
    }
    
    /// 进入房间
    public static func nw_enterRoom(rId: Int64, pwd: String, enter_way: Int32, dgc_followInfo : DGCNWEnterRoomFollowInfo? = nil, success: @escaping DGCNetWorkSuccess<DGCLive_EnterRoomRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_EnterRoomReq()
        dgc_body.roomID = rId
        dgc_body.password = pwd
        dgc_body.enterWay = enter_way
        if let dgc_followInfo = dgc_followInfo {
            dgc_body.followID = dgc_followInfo.followID
            dgc_body.followName = dgc_followInfo.followName
            dgc_body.followType = dgc_followInfo.followType
            dgc_body.followMsg = dgc_followInfo.followMsg
        }
        
        let dgc_req = DGCNetWorkRequest<DGCLive_EnterRoomRes>(
            cmd: .RoomEnter,
            channel: .long,
            op: .RoomChange,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            header: ["roomid":"\(rId)"],
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 获取房间列表
    public static func nw_roomGetPlayerList(success: @escaping DGCNetWorkSuccess<DGCLive_PlayerListRes>,fail: DGCNetWorkFail? = nil) {
        let dgc_body = DGCLive_RoomPlayerListReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_PlayerListRes>(
            cmd: .RoomGetPlayerList,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 退出房间
    public static func nw_roomLeave(roomID : Int64,success: DGCNetWorkSuccess<DGCLive_LeaveRoomRes>? = nil,fail: DGCNetWorkFail? = nil) {
        if roomID <= 0 {//房间id不存在 不请求
            return
        }
        let dgc_body = DGCLive_LeaveRoomReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_LeaveRoomRes>(
            cmd: .RoomLeave,
            channel: .long,
            op: .RoomChange,
            dgc_body: dgc_body,
            autoShowErrTip: false, 
            header: ["roomid":"-1"],
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 投掷篝火
    public static func nw_roomBonfireThrow(success: @escaping DGCNetWorkSuccess<DGCLive_BonfireThrowRes>,fail: DGCNetWorkFail? = nil) {
        let dgc_body = DGCLive_BonfireThrowReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_BonfireThrowRes>(
            cmd: .RoomBonfireThrow,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 点赞
    public static func nw_roomLike(like : Int64, success: @escaping DGCNetWorkSuccess<DGCLive_RoomLikeRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_RoomLikeReq()
        dgc_body.like = like
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomLikeRes>(
            cmd: .RoomLike,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    //发送弹幕
    public static func nw_sendChat(content : String, quickMsgID: Int64 = 0,dict : [String : Any] = [:], success: @escaping DGCNetWorkSuccess<DGCLive_ChatRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_ChatReq()
        dgc_body.content = content
        dgc_body.quickMsgID = quickMsgID
        
        if dict.isEmpty == false {
            //转成json data
            let dgc_jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            dgc_body.options = dgc_jsonData ?? Data()
        }
        
        let dgc_req = DGCNetWorkRequest<DGCLive_ChatRes>(
            cmd: .RoomSendChat,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 查询用户的房间权限
    public static func nw_livePlayerAdminType(targetId: Int64, success: @escaping DGCNetWorkSuccess<DGCLive_QueryRoomPlayerAdminTypeRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_QueryRoomPlayerAdminTypeReq()
        dgc_body.playerID = targetId
        
        let dgc_req = DGCNetWorkRequest<DGCLive_QueryRoomPlayerAdminTypeRes>(
            cmd: .LivePlayerAdminType,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    /// 预览视频（用在房主开播前视频预览）
    public static func nw_livePreviewVideo(success: @escaping DGCNetWorkSuccess<DGCLive_PreviewVideoRes>,fail: DGCNetWorkFail? = nil) {
        let dgc_body = DGCLive_PreviewVideoReq()
        let dgc_req = DGCNetWorkRequest<DGCLive_PreviewVideoRes>(
            cmd: .LivePreviewVideo,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 开始视频直播（会自动执行房主进房逻辑）
    public static func nw_liveStartVideo(roomID : Int64, rName : String,deviceSwitch : DGCLive_VideoDeviceSwitch, success: @escaping DGCNetWorkSuccess<DGCLive_StartVideoRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_StartVideoReq()
        dgc_body.roomName = rName
        dgc_body.videoDeviceSwitch = deviceSwitch
        let dgc_req = DGCNetWorkRequest<DGCLive_StartVideoRes>(
            cmd: .LiveStartVideo,
            channel: .long,
            op: .RoomChange,
            dgc_body: dgc_body,
            header: ["roomid":"\(roomID)"],
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    /// 预览房间
    public static func nw_livePreloadedRoom(roomId: Int64, success: @escaping DGCNetWorkSuccess<DGCLive_PreloadedRoomRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_PreloadedRoomReq()
        dgc_body.roomID = roomId
        
        let dgc_req = DGCNetWorkRequest<DGCLive_PreloadedRoomRes>(
            cmd: .LivePreloadedRoom,
            channel: .long,
            op: .SendSms,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_liveLeavePreLoadedReq(roomID : Int64,success: DGCNetWorkSuccess<DGCLive_LeavePreLoadedRes>? = nil,fail: DGCNetWorkFail? = nil) {
        if roomID <= 0 {//房间id不存在 不请求
            return
        }
        var dgc_body = DGCLive_LeavePreLoadedReq()
        dgc_body.roomID = roomID
        
        let dgc_req = DGCNetWorkRequest<DGCLive_LeavePreLoadedRes>(
            cmd: .LiveLeavePreLoaded,
            channel: .long,
            op: .SendSms,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 视频模式 连麦操作 type: 1 申请连麦（用户）,2. 同意连麦（房主）,3. 拒绝连麦（房主）， 4. 邀请连麦（房主）
    public static func nw_liveVideoConnectOpt(type: DGCLive_ChairQueueOpCode, targetId: Int64, dgc_pkTeam: DGCLive_PkTeamName? = nil, success: @escaping DGCNetWorkSuccess<DGCLive_OptChairQueueRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_OptChairQueueReq()
        dgc_body.playerID = targetId
        dgc_body.op = type
        if let dgc_pkTeam = dgc_pkTeam {
            dgc_body.ext.dgc_pkTeam = dgc_pkTeam
        }
        
        let dgc_req = DGCNetWorkRequest<DGCLive_OptChairQueueRes>(
            cmd: .LiveVideoConnectOpt,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 视频模式获取连麦列表
    public static func nw_liveVideoConnectList(success: @escaping DGCNetWorkSuccess<DGCLive_ChairQueueListRes>,fail: DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCLive_ChairQueueListReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_ChairQueueListRes>(
            cmd: .LiveVideoConnectList,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 接受连麦 status: 1. 同意, 2. 拒绝       isCameraOn: 是否开摄像头
    public static func nw_liveVideoConnectAccept(status: UInt32, isCameraOn: Bool, success: @escaping DGCNetWorkSuccess<DGCLive_AcceptChairQueueRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_AcceptChairQueueReq()
        dgc_body.status = status
        dgc_body.isCameraOn = isCameraOn
//        dgc_body.ext.pkTeam = pkTeam
        
        let dgc_req = DGCNetWorkRequest<DGCLive_AcceptChairQueueRes>(
            cmd: .LiveVideoConnectAccept,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_liveSetRoomMediaTypeReq( mediaType: DGCLive_RoomType,pattern:DGCLive_RoomPattern = .rpStandard, success: @escaping DGCNetWorkSuccess<DGCLive_SetRoomMediaTypeRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_SetRoomMediaTypeReq()
        dgc_body.media = mediaType
        
        if dgc_body.media == .rmtAudio{
            dgc_body.pattern = pattern
        }
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SetRoomMediaTypeRes>(
            cmd: .LiveSetRoomMediaType,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_liveGetAdminList(success: DGCNetWorkSuccess<DGCLive_PlayerListRes>? = nil,fail: DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCLive_RoomPlayerListReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_PlayerListRes>(
            cmd: .LiveGetAdminList,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 查询用户的房间权限
    public static func nw_liveSendMicFace(fId: Int32, success: @escaping DGCNetWorkSuccess<DGCLive_SendMicFaceReq>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_SendMicFaceReq()
        dgc_body.micFaceID = fId
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SendMicFaceReq>(
            cmd: .LiveSendMicFace,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    public static func nw_liveRefreshVoiceToken(success: @escaping DGCNetWorkSuccess<DGCLive_RefreshVoiceTokenRes>,fail: DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCLive_RefreshVoiceTokenReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RefreshVoiceTokenRes>(
            cmd: .LiveRefreshVoiceToken,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 房间玩法列表
    public static func nw_liveGamePlayList(success: @escaping DGCNetWorkSuccess<DGCLive_RoomPlayListRes>,fail: DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCLive_RoomPlayListReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomPlayListRes>(
            cmd: .LiveGamePlayList,
            channel: .long,
            cacheType: .cacheFromReq,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 房间banner
    public static func nw_liveBannerList(success: @escaping DGCNetWorkSuccess<DGCLive_RoomBannerListRes>,fail: DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCLive_RoomBannerListReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomBannerListRes>(
            cmd: .LiveBannerList,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_livePKOperate(cacheType: DGCNetWorkCacheType,opCode: DGCLive_PkOperateCode, durationMinute: Int32 = 0, roomId: Int64, success: @escaping DGCNetWorkSuccess<DGCLive_PkOperateRes>,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_PkOperateReq()
        dgc_body.opCode = opCode
        dgc_body.durationMinute = durationMinute
        dgc_body.roomID = roomId
        
        let dgc_req = DGCNetWorkRequest<DGCLive_PkOperateRes>(
            cmd: .LivePkOperate,
            channel: .long,
            cacheType: cacheType,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_liveRocketOperate(opCode: DGCLive_RocketOperateCode, level: Int32 = 0, success: @escaping DGCNetWorkSuccess<DGCLive_RocketOperateRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_RocketOperateReq()
        dgc_body.opCode = opCode
        dgc_body.level = level
        
        let dgc_req = DGCNetWorkRequest<DGCLive_RocketOperateRes>(
            cmd: .LiveRocketOperate,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 视频快捷开播 (1.将房间切换切换为视频房 2.上麦 3.开启摄像头)
    public static func nw_liveQuickStartVideo(roomId: Int64, roomName: String, success: @escaping DGCNetWorkSuccess<DGCLive_QuickStartVideoRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_QuickStartVideoReq()
        dgc_body.roomID = roomId
        dgc_body.roomName = roomName
        let dgc_req = DGCNetWorkRequest<DGCLive_QuickStartVideoRes>(
            cmd: .Live_QuickStartVideo,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    /// 获取房间历史公屏消息
    public static func fetchRoomHistoryMsgList(success: @escaping DGCNetWorkSuccess<DGCPb_QueryRoomHistoryPubMsg>,fail: DGCNetWorkFail? = nil) {
        let dgc_body = DGCPb_QueryRoomHistoryPubMsgReq()
        let dgc_req = DGCNetWorkRequest<DGCPb_QueryRoomHistoryPubMsg>(
            cmd: .LiveHistoryPubMsgList,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    //上传自定义主题
    public static func nw_uploadPersonalizeDecorate(name:String, url:String, success: @escaping DGCNetWorkSuccess<DGCPb_UploadPersonalizeDecorateRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCPb_UploadPersonalizeDecorateReq()
        dgc_body.name = name
        dgc_body.url = url
        let dgc_req = DGCNetWorkRequest<DGCPb_UploadPersonalizeDecorateRes>(
            cmd: .UploadPersonalizeDecorate,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
            
            
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 1截屏 2: 录屏
    public static func startScreenRecording(type : Int32, success: @escaping DGCNetWorkSuccess<DGCPb_StartScreenRecordingRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCPb_StartScreenRecordingReq()
        dgc_body.type = type
        let dgc_req = DGCNetWorkRequest<DGCPb_StartScreenRecordingRes>(
            cmd: .LiveStartScreenRecording,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    //删除自定义主题
    public static func nw_delPersonalizeDecorate(decorateID:Int64, success: @escaping DGCNetWorkSuccess<DGCPb_DelPersonalizeDecorateRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCPb_DelPersonalizeDecorateReq()
        dgc_body.decorateID = decorateID
        
        let dgc_req = DGCNetWorkRequest<DGCPb_DelPersonalizeDecorateRes>(
            cmd: .DelPersonalizeDecorate,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    //房间玩法游戏配置
    public static func nw_roomPlayConfReq(success: @escaping DGCNetWorkSuccess<DGCPb_RoomPlayConfRes>,fail: DGCNetWorkFail? = nil) {
        let dgc_body = DGCPb_RoomPlayConfReq()
        
        let dgc_req = DGCNetWorkRequest<DGCPb_RoomPlayConfRes>(
            cmd: .Common_RoomPlayConf,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    //房间分享上报
    public static func nw_roomShareReq(pattern:DGCLive_RoomPattern ,count:Int32, success: @escaping DGCNetWorkSuccess<DGCLive_RoomShareRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_RoomShareReq()
        dgc_body.pattern = pattern
        dgc_body.count = count
        let dgc_req = DGCNetWorkRequest<DGCLive_RoomShareRes>(
            cmd: .Common_RoomShareReq,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
}
