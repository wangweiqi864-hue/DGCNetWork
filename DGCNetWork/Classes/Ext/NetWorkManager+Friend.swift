//
//  DGCNetWorkManager+Friend.swift
//  Pods
//
//  Created by mango-linwieyan on 2024/5/11.
//

import Foundation


extension DGCNetWorkManager {
    
    public static func nw_queryPrivateSettingReq(targetPlayerID:Int64 = 0,success : DGCNetWorkSuccess<DGCFriend_QueryPrivateSettingRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCFriend_QueryPrivateSettingReq()
        dgc_body.targetPlayerID = targetPlayerID
        let dgc_req = DGCNetWorkRequest<DGCFriend_QueryPrivateSettingRes>(
            cmd: .queryPrivateSetting,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_userPrivateSettingReq(optionsSetting: DGCFriend_PrivacySettingOpt ,success : DGCNetWorkSuccess<DGCFriend_UserPrivateSettingRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCFriend_UserPrivateSettingReq()
        dgc_body.optionsSetting = optionsSetting
        let dgc_req = DGCNetWorkRequest<DGCFriend_UserPrivateSettingRes>(
            cmd: .userPrivateSetting,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_queryChatReplayReq(toID:Int64 = 0,success : DGCNetWorkSuccess<DGCFriend_QueryChatReplayRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCFriend_QueryChatReplayReq()
        dgc_body.toID = toID
        let dgc_req = DGCNetWorkRequest<DGCFriend_QueryChatReplayRes>(
            cmd: .QueryChatReplayReq,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_queryAIChatConfigReq(success : DGCNetWorkSuccess<DGCFriend_QueryAIChatConfigRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCFriend_QueryAIChatConfigReq()
        
        let dgc_req = DGCNetWorkRequest<DGCFriend_QueryAIChatConfigRes>(
            cmd: .AIQueryAIChatConfig,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_sendAIChatMessageReq(botId : String, txt: String, success : DGCNetWorkSuccess<DGCFriend_SendAIChatMessageRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCFriend_SendAIChatMessageReq()
        dgc_body.botID = botId
        dgc_body.text = txt
        
        let dgc_req = DGCNetWorkRequest<DGCFriend_SendAIChatMessageRes>(
            cmd: .AISendAIChatMessageReq,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_queryAIChatMessageReq(botId : String, firstId: String, limit:Int32, success : DGCNetWorkSuccess<DGCFriend_QueryAIChatMessageRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCFriend_QueryAIChatMessageReq()
        dgc_body.botID = botId
        dgc_body.firstID = firstId
        dgc_body.limit = limit
        
        let dgc_req = DGCNetWorkRequest<DGCFriend_QueryAIChatMessageRes>(
            cmd: .AIQueryAIChatMessageReq,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_friendListReq(friendType : DGCFriend_FriendType, success : DGCNetWorkSuccess<DGCFriend_FriendListRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCFriend_FriendListReq()
        dgc_body.type = friendType
        
        let dgc_req = DGCNetWorkRequest<DGCFriend_FriendListRes>(
            cmd: .FriendListReq,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    //关注，取消关注，拉黑接口
    public static func nw_friendOperReq( id: UInt64,  optType : DGCFriend_OperType, success : DGCNetWorkSuccess<DGCFriend_FriendOperRes>? = nil,fail : DGCNetWorkFail? = nil) {
//        100042
        var dgc_body = DGCFriend_FriendOperReq()
        dgc_body.id = id
        dgc_body.oper = optType
        
        let dgc_req = DGCNetWorkRequest<DGCFriend_FriendOperRes>(
            cmd: .FriendOperReq,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }

    //查询两个号之前的关系
    public static func nw_getFriendRelReq( playerID: Int64, targetID: Int64, success : DGCNetWorkSuccess<DGCFriend_GetFriendRelRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCFriend_GetFriendRelReq()
        dgc_body.playerID = playerID
        dgc_body.targetID = targetID
        
        let dgc_req = DGCNetWorkRequest<DGCFriend_GetFriendRelRes>(
            cmd: .ReqFriendRel,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    //查询粉丝
    public static func nw_fansListReq( index : Int32, success : DGCNetWorkSuccess<DGCFriend_FansListRes>? = nil,fail : DGCNetWorkFail? = nil) {
        var dgc_body = DGCFriend_FansListReq()
        dgc_body.index = index
        
        let dgc_req = DGCNetWorkRequest<DGCFriend_FansListRes>(
            cmd: .FriendFansListReq,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_checkFriendReq(friendId: [Int64], success : DGCNetWorkSuccess<DGCFriend_CheckFRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCFriend_CheckFReq()
        dgc_body.friendID = friendId
        
        let dgc_req = DGCNetWorkRequest<DGCFriend_CheckFRes>(
            cmd: .FriendCheck,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    // 获取红点数据
    public static func fetchFriendredDotReq(friendType: DGCFriend_FriendType,
                                            success : DGCNetWorkSuccess<DGCFriend_FriendClearRedDotRes>? = nil,
                                            fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCFriend_FriendClearRedDotReq()
        dgc_body.ftype = friendType
        let dgc_req = DGCNetWorkRequest<DGCFriend_FriendClearRedDotRes>(
            cmd: .MessageRedDot,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    
}
