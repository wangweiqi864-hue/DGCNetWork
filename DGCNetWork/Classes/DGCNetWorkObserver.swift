//
//  DGCNetWorkObserver.swift
//  DGCNetWork
//
//  Created by mango on 2024/2/27.
//

import Foundation
import SwiftProtobuf

/// 监听者
@objc public protocol DGCNetWorkObserver {
    // 实现的指令 DGCNetWorkNotiCmd
    var netWorkNotiCmds : [Int32]{get}
    
    //服务器推送数据
    func netWorkNotiData(cmdId : DGCNetWorkNotiCmd ,obj : Any?)
}

/// 通知服务ID 没添加一个新Cmd 需要注册对应关系 DGCNetWorkNotiCmds
@objc public enum DGCNetWorkNotiCmd : Int32 {
    case UN = 0
    case BroadcastPlayerEnter = 100001 // 有人进房
    case BroadcastPlayerLeave = 100002 // 有人离开
    case BroadcastMangoRoomBonfireChange = 110001 // 房间篝火等级发生变动
    case BroadcastMangoRoomUserBonfireChange = 110002 // 用户篝火发生变动
    case BroadcastMangoRoomUserThrowBonfire = 110003 // 用户投掷篝火
    case BroadcastChat = 100125 // 弹幕推送
    case BroadcastMangoRoomLike = 110004  // 点赞
    
    case BroadcastAIChatAnswerNotice = 200301 //AI消息单播
    case BroadcastRelogin = 501001 //登录
    case BroadcastTLogout = 501002 //t下线--被封号
    
    case BroadcastCharmLevelUP = 500006;  // 广播魅力升级
    case BroadcastWealthLevelUP = 500007;  // 广播财富升级
    
    case BroadcastToBan = 500008 //被禁封
    case BroadcastSubEventNotice = 500022 //  用户状态通知
    case BroadcastCSResetUsrInfo = 500029 //客服清空用户信息广播
    case BroadcastCSVipUserLogin = 500030 // VIP上线
    case BroadcastCSRelationshipLevelUp = 500031 // cp朋友关系升级
    case BroadcastLiveSeatUpdate = 100110 //  麦位变动
    case BroadcastRoomUpSeat = 100111 //  上麦
    case BroadcastLiveSeatStatue = 100102 //  麦位状态变动
    case BroadcastLiveSeatLeave = 100113 //  下麦
    case BroadcastSeatSpeak = 100104 // 广播禁麦/开麦
    case BroadcastSeatMove = 100112 // 移麦
    case BroadcastSeatInvite = 110006 // 邀请上麦
    case BroadcastSeatKick = 110007 // 踢人下麦
    case BroadcastForbidRoomActionNotify = 110005 //收到禁止进房的通知后
    case BroadcastMuteChairNotify = 110008 //禁言麦位广播
    case BroadcastChairLockStatusNotify = 110009 //锁定麦位
    case BroadcastLiveSet = 100028 // 房间设置更新
    case BroadcastChairSpeakOnOff = 100105 //广播设置坑位发言开关
    
    case BroadcastMineAssetsMoneyChange = 300101 //金币变更
    
    case BroadcastGiftBroadCmdId = 400101 //推送公屏
    case BroadcastGiftComboEndCmdId = 400103
    case BroadcastCameraStatus = 110010 // 广播摄像头状态
    case BroadcastRoomPatternChange = 110011 // 广播房间模式切换
    case BroadBroadCastRoomMediaChange = 110012 //切换媒体模式房间内广播
    case BroadcastSysConfUpdate = 101013 //
    
    case BroadcastLiveVideoConnect = 100115 // 视频房, 连麦广播
    case BroadcastSeatQueueRefresh = 100103 // 100103 麦位发生变动广播麦位列表
    case BroadcastUpdateUserPrivilege = 500021 //广播特权变更
    case BroadRoomChairModeChange = 100202 //排麦模式变更
    case BroadLiveAdminSet = 100046 //房间管理状态广播
    case BroadCastRightChange = 110013 ////房间权限变更
    case BroadCastRoomHourRank = 110014  ///房间小时榜广播
    case BroadCastMicFaceMessage = 100199 /// 表情
    case BroadCastRoomTopChange = 110015 ///房间榜1变化通知
    case BroadCastMangoRoomInspireNotify = 110016 ///房间视频鉴定通知
    case BroadCastMangoRoomInspireNotifyNew = 110031 ///房间视频鉴定通知(新)
    case BroadcastKickout = 100042 // 踢出房间
    case BroadcastRoomSwitchVoiceSdk = 100165 // 切换sdk
    
    case BroadcastTureTalkNotify = 110017 // 真心话大冒险推送
    case BroadcastTrueTalkChallengeNotify = 110018 // 大冒险选择推送
    
    case BroadcastLiveBulletMsgNotify = 101028 // 公屏系统消息
    case BroadcastTopMiniDialog = 80000 // 顶部小窗口
    case BroadcastLoginPopDialog = 80001 // 登录推送弹窗
    
    case BroadcastCommonPushMarquee = 20001 // 通用跑马灯
    case BroadcastBigRedPackMarquee = 20002 // 发送总金额大于100000金币的红包，触发跑马灯

    case BroadcastLivePkNotify = 110019 // PK

    case BroadcastSysMail = 101005 // 广播新邮件
    case BroadcastSysMailOverdue = 101026 // 立即过期撤回广播邮件
    case BroadcastRoomSubPatternChange = 110020 // 广播房间子模式变更
    case BroadcastMessageRedDot = 200206 // 红点数量
    case BroadcastFriendFollow = 200103 // 好友关注
    
    
    case BroadcastLiveRocketNotify = 110021
    
    case BroadcastGiftPrizeNotify = 410003
    
    case BroadcastAssetsBag = 300102 //背包变化
    case BroadcastUseDecorate = 100174
    case BroadcastActivityPush = 80002 // 活动推送接口
    case BroadcastActPushEntrancePush = 80003 // 客户端入口 对应cmdId 80003
    case BroadcastActCountryInfoPush = 80004 // 国家国庆活动信息推送
    case BroadcastActCountryInfoEndPush = 80005 // 国家国庆活动结束推送
   
    case BroadcastLiveRoomPanelNotify = 110022 // 视频房面板通知
    case BroadcastLiveRoomGiftValueChangeNotify = 110023 //单人或多人计分器变化通知
    case BroadcastLiveRoomAssistantNotify = 110024 //直播助手通知
    
    case BroadcastSudGameEvent = 100209 //sud游戏事件
    case BroadcastSudGameCleanAllSeatEvent = 100222 //清理所有加入游戏的人的座位
    case BroadcastSudGameSettleEvent = 100210 //sud游戏结算
    case BroadcastSudGameEventNew = 101111 //广播配置化sud游戏切换事件
    
    case BroadcastLiveConnectInvite = 110025 //视频连线房间pk邀请弹窗
    case BroadcastLiveConnectInvitePush = 110026 //视频连线房间pk邀请状态推送
    case BroadcastLiveConnectInfoPush = 110027 //视频连线房间pk信息推送
    case BroadcastLivePrankInfoNotify = 110028 //整蛊菜单推送
    
    // （跨房PK）其他房间麦位变化（在原来的麦位事件cmd基础上加1000，结构体加上对应的房间id）
    case BroadcastLiveConnect_CameraStatus = 111010 // 摄像头状态
    case BroadcastLiveConnect_ChairList = 101103 // 同步麦位列表
    case BroadcastLiveConnect_Chair = 101110 // 广播坑位变动
    case BroadcastLiveRoomLuckBagEventChangeNotify = 110029 // 福袋事件推送
    case BroadcastLiveRoomLuckBagReceivedNotify = 110030 // 福袋领取推送
    
    
    case BroadcastVipLevelUpgradedNotify = 810001 // vip升级
    case BroadcastVipLevelDowngradedNotify = 810002 // vip降级
    
    case BroadcastCpFlowerLightDaysChangeEvent = 500032 // cp送礼更新鲜花广播
    
    case BroadcastServerMidnightEvent = 20003 //  服务端到达0点时间

    case BroadcastScreenRecordingEvent = 101112 // 截屏、录屏
    
    case BroadcastRoomBirthdayEndEvent = 101113 // 房间生日结束

    case BroadcastRoomBirthdayFloatEvent = 101114 // 房间生日弹幕
    
}


/// 指令对应关系
public let DGCNetWorkNotiCmds : [DGCNetWorkNotiCmd:Message.Type] = [
    .BroadcastScreenRecordingEvent : DGCPb_ScreenRecordingEvent.self,
    .BroadcastActivityPush : DGCSystem_ActivityPushRes.self,
    .BroadcastAssetsBag : DGCMine_AssetsBag.self,
    .BroadcastRoomSubPatternChange : DGCLive_BroadcastRoomSubPatternChange.self,
    .BroadcastCommonPushMarquee : DGCCommon_CommonPushMarquee.self,
    .BroadcastBigRedPackMarquee : DGCCommon_SendBigRedEnvelope.self,
    .BroadcastTrueTalkChallengeNotify : DGCLive_TrueTalkChallengeNotify.self,
    .BroadcastTureTalkNotify : DGCLive_TrueTalkNotify.self,
    .BroadcastRoomSwitchVoiceSdk: DGCLive_RoomSwitchVoiceSdk.self,
    .BroadcastKickout : DGCLive_BroadcastKickout.self,
    .BroadCastMicFaceMessage : DGCLive_MicFaceMessage.self,
    .BroadcastRoomPatternChange : DGCLive_BroadcastRoomPatternChange.self,
    .BroadBroadCastRoomMediaChange : DGCLive_BroadCastRoomMediaChange.self,
    .BroadcastPlayerLeave : DGCLive_BroadcastPlayerLeave.self,
    .BroadcastCameraStatus : DGCLive_BroadcastCameraStatus.self,
    .BroadcastSeatMove : DGCLive_BroadcastSeatMove.self,
    .BroadcastSeatSpeak : DGCLive_BroadcastSeatSpeak.self,
    .BroadcastLiveSeatLeave : DGCLive_BroadcastSeatLeave.self,
    .BroadcastRoomUpSeat : DGCLive_BroadcastSeatSit.self,
    .BroadcastLiveSeatStatue : DGCLive_BroadcastSeatStatus.self,
    .BroadcastLiveSeatUpdate : DGCLive_BroadcastSeat.self,
    .BroadcastMangoRoomLike : DGCLive_BroadcastMangoRoomLike.self,
    .BroadcastMangoRoomBonfireChange : DGCLive_BroadcastMangoRoomBonfireChange.self,
    .BroadcastMangoRoomUserBonfireChange : DGCLive_BroadcastMangoRoomUserBonfireChange.self,
    .BroadcastPlayerEnter : DGCLive_BroadcastPlayerEnter.self,
    .BroadcastMangoRoomUserThrowBonfire : DGCLive_BroadcastMangoRoomUserThrowBonfire.self,
    .BroadcastChat : DGCLive_BroadcastChat.self,
    .BroadcastAIChatAnswerNotice : DGCFriend_AIChatAnswerNotice.self,
    .BroadcastRelogin : DGCLogin_BroadcastRelogin.self,
    .BroadcastTLogout : DGCMine_BroadcastTakeLeave.self,
    .BroadcastToBan : DGCMine_BroadcastBan.self,
    .BroadcastCharmLevelUP : DGCMine_BroadcastCharmLevel.self,
    .BroadcastWealthLevelUP : DGCMine_BroadcastWealthLevel.self,
    .BroadcastSubEventNotice : DGCMine_SubEventNotice.self,
    .BroadcastCSResetUsrInfo : DGCMine_CsAgentUpdateInfoEvent.self,
    .BroadcastSeatInvite : DGCLive_InviteChairNotify.self,
    .BroadcastSeatKick : DGCLive_KickChairNotify.self,
    .BroadcastForbidRoomActionNotify : DGCLive_ForbidRoomActionNotify.self,
    .BroadcastMuteChairNotify : DGCLive_MuteChairNotify.self,
    .BroadcastChairLockStatusNotify : DGCLive_ChairLockStatusNotify.self,
    .BroadcastLiveSet : DGCLive_BroadcastRoomSet.self,
    .BroadcastChairSpeakOnOff : DGCLive_BroadcastChairSpeakOnOff.self,
    .BroadcastMineAssetsMoneyChange: DGCPay_AssetsMoney.self,
    .BroadcastGiftBroadCmdId: DGCGift_GiftBroadcastBatch.self,
    .BroadcastGiftComboEndCmdId: DGCGift_GiftComboEndNotify.self,
    .BroadcastSysConfUpdate: DGCSystem_SysConfUpdate.self,
    .BroadcastLiveVideoConnect: DGCLive_BroadcastChairQueueOpt.self,
    .BroadcastSeatQueueRefresh: DGCLive_BroadcastSeatQueue.self,
    .BroadcastUpdateUserPrivilege: DGCPrivilege_BroadcastUpdateUserPrivilege.self,
    .BroadRoomChairModeChange: DGCLive_RoomChairModeChange.self,
    .BroadLiveAdminSet: DGCLive_BroadcastSetRoomAdmin.self,
    .BroadCastRightChange: DGCLive_BroadCastRightChange.self,
    .BroadCastRoomHourRank: DGCRank_BroadCastRoomHourRank.self,
    .BroadCastRoomTopChange: DGCLive_BroadCastRoomTopChange.self,
    .BroadCastMangoRoomInspireNotify: DGCLive_BroadCastMangoRoomInspireNotify.self,
    .BroadCastMangoRoomInspireNotifyNew: DGCLive_BroadCastMangoRoomInspireNotify.self,
    .BroadcastLiveBulletMsgNotify: DGCSystem_SystemNotice.self,
    .BroadcastTopMiniDialog: DGCSystem_PushTopDialog.self,
    .BroadcastLoginPopDialog: DGCSystem_GetLoginDialogRes.self,
    .BroadcastLivePkNotify: DGCLive_PkNotify.self,
    .BroadcastSysMail: DGCIM_BroadcastMailMsg.self,
    .BroadcastLiveRocketNotify: DGCLive_RocketNotify.self,
    .BroadcastGiftPrizeNotify: DGCSystem_LuckyGiftPrizeNotice.self,
    .BroadcastUseDecorate: DGCLive_BroadcastUseDecorate.self,
    .BroadcastLiveRoomPanelNotify: DGCLive_LiveRoomPanelNotify.self,
    .BroadcastLiveRoomGiftValueChangeNotify: DGCLive_GiftValueChangeNotify.self,
    .BroadcastLiveRoomAssistantNotify:DGCLive_LiveRoomAssistantNotify.self,
    .BroadcastSudGameEvent:DGCLive_BroadcastSudGameEvent.self,
    .BroadcastSudGameCleanAllSeatEvent:DGCLive_SudGameCleanAllSeatEvent.self,
    .BroadcastSudGameSettleEvent:DGCLive_BroadcastSudGameSettleEvent.self,
    .BroadcastLiveConnectInvite:DGCLive_RoomBattleInviteInfo.self,
    .BroadcastLiveConnectInvitePush:DGCLive_RoomBattleInvitePush.self,
    .BroadcastLiveConnectInfoPush:DGCLive_RoomBattlePkInfoRes.self,
    .BroadcastActPushEntrancePush:DGCSystem_ActPushEntranceRes.self,
    .BroadcastLiveConnect_CameraStatus:DGCLive_BroadcastCameraStatus.self,
    .BroadcastLiveConnect_ChairList:DGCLive_BroadcastSeatQueue.self,
    .BroadcastLiveConnect_Chair:DGCLive_BroadcastSeat.self,
    .BroadcastLivePrankInfoNotify:DGCPb_PrankEnumInfoPush.self,
    .BroadcastActCountryInfoPush:DGCSystem_SaudiFlagEvent.self,
    .BroadcastActCountryInfoEndPush:DGCSystem_SaudiEndEvent.self,
    .BroadcastMessageRedDot:DGCFriend_FriendRedDotRes.self, // 红点数量
    .BroadcastFriendFollow:DGCFriend_Friender.self, // 好友关注
    .BroadcastLiveRoomLuckBagEventChangeNotify:DGCLive_RedEnvelopeEvent.self,
    .BroadcastLiveRoomLuckBagReceivedNotify:DGCPb_ReceiveRedEnvelopeEvent.self,
    .BroadcastVipLevelUpgradedNotify:DGCVip_VipLevelUpgradeEvent.self,
    .BroadcastVipLevelDowngradedNotify:DGCVip_VipLevelDowngradeEvent.self,
    .BroadcastCSVipUserLogin:DGCMine_VipUserLoginEvent.self,
    .BroadcastSudGameEventNew : DGCLive_BroadcastSudGameEventNew.self,
    .BroadcastCSRelationshipLevelUp : DGCMine_RelationshipLevelUpEvent.self,
    .BroadcastCpFlowerLightDaysChangeEvent : DGCMine_CpFlowerLightDaysChangeEvent.self,
    .BroadcastServerMidnightEvent : DGCCommon_ServerMidnightEvent.self,
    .BroadcastRoomBirthdayEndEvent : DGCPb_RoomBirthdayEndInfo.self,
    .BroadcastRoomBirthdayFloatEvent : DGCPb_RoomBirthdayFloatPush.self
]
