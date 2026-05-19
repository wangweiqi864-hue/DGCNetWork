//
//  DGCNetWorkManager+Mine.swift
//  Pods
//
//  Created by mango on 2024/2/27.
//

import Foundation

/// 用户
extension DGCNetWorkManager{
    
    /// 客服修改用户信息
    public static func nw_resetUsrInfo(pId : Int64 = 0, type:DGCSystem_CSAgentOperateReq.DGCTypeEnum,infos: [DGCSystem_CSAgentOperateReq.DGCInfo] = [], success : DGCNetWorkSuccess<DGCSystem_CSAgentOperateResp>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCSystem_CSAgentOperateReq()
        dgc_body.targetID = pId
        dgc_body.type = type
        dgc_body.infos = infos
        
        let dgc_req = DGCNetWorkRequest<DGCSystem_CSAgentOperateResp>(
            cmd: .CustomerStafResetUsrInfo,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 获取用户信息
    /// pId 需要获取的用户ID   0 获取自己的信息
    public static func nw_mineGetInfo(pId : Int64 = 0, isShort: Bool = true, success : DGCNetWorkSuccess<DGCMine_PlayerRes>? = nil,fail : DGCNetWorkFail? = nil) {
        var dgc_body = DGCMine_PlayerReq()
        dgc_body.id = pId
        
        let dgc_req = DGCNetWorkRequest<DGCMine_PlayerRes>(
            cmd: .MineGetInfo,
            channel: isShort ? .short : .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 请求用户信息
    public static func nw_getUserInfo(pId: Int64, cache:DGCNetWorkCacheType = .cacheFromReq, success: DGCNetWorkSuccess<DGCMine_PlayerInfoListRes>? = nil, fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCMine_PlayerInfoListReq()
        dgc_body.ids = [pId]
        
        let dgc_cacheFrom : DGCNetWorkCacheType = cache
        let dgc_req = DGCNetWorkRequest<DGCMine_PlayerInfoListRes>(
            cmd: .UserInfo,
            channel: .long,
            cacheType: dgc_cacheFrom,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_mineUserInfoV2Req(userProperty:[DGCMine_PUserProperty], success : DGCNetWorkSuccess<DGCMine_UserInfoV2Res>? = nil,fail : DGCNetWorkFail? = nil) {
        var dgc_body = DGCMine_UserInfoV2Req()
        dgc_body.data = userProperty
        
        let dgc_req = DGCNetWorkRequest<DGCMine_UserInfoV2Res>(
            cmd: .MineSetUserInfo,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    //MARK: - 礼拜工具
    //date: 格式 yyyyMMdd
    public static func nw_queryIslamicPrayerTimesReq(latitude: Double, longitude: Double, timeZone: String, date: String,
                                                     success : DGCNetWorkSuccess<DGCMine_QueryIslamicPrayerTimesRes>? = nil,
                                                     fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCMine_QueryIslamicPrayerTimesReq()
        dgc_body.latitude = latitude
        dgc_body.longitude = longitude
        dgc_body.timezone = timeZone
        dgc_body.pagingDay = date
        dgc_body.pagingDirection = 0 //翻页方向 0:前后都要 1: 前翻 2:后翻
        
        let dgc_req = DGCNetWorkRequest<DGCMine_QueryIslamicPrayerTimesRes>(
            cmd: .MineIslamicPrayerTimes,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_FirstSetUserInfoReq(birthday: String, CountryCode: String, sex: DGCCommon_SexType, 
                                              success : DGCNetWorkSuccess<DGCMine_FirstSetUserInfoRes>? = nil,
                                              fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCMine_FirstSetUserInfoReq()
        dgc_body.birthday = birthday
        dgc_body.countryCode = CountryCode
        dgc_body.sex = sex
        
        let dgc_req = DGCNetWorkRequest<DGCMine_FirstSetUserInfoRes>(
            cmd: .MineFirstSetUserInfo,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 举报
    public static func nw_requestReport(targetId: Int64, picUrls: String, reason: String, pId: Int64, type: Int64, desc: String, success: DGCNetWorkSuccess<DGCMine_ReportRes>? = nil, fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCMine_ReportReq()
        dgc_body.targetID = targetId
        dgc_body.picPath = picUrls
        dgc_body.remark = desc
        dgc_body.playerID = pId
        dgc_body.types = reason
        dgc_body.reportType = type
        
        let dgc_req = DGCNetWorkRequest<DGCMine_ReportRes>(
            cmd: .MineReport,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 请求用户的封面信息
    public static func nw_requestPlayerCovers(targetId: Int64, cacheType: DGCNetWorkCacheType = .cacheFromReq, success: DGCNetWorkSuccess<DGCMine_TypeImageListRes>? = nil, fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCMine_TypeImageListReq()
        dgc_body.playerID = targetId
        dgc_body.type = .zoneCover
        
        let dgc_req = DGCNetWorkRequest<DGCMine_TypeImageListRes>(
            cmd: .uploadTypeImageList,
            channel: .long,
            cacheType: cacheType,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 订阅/取消用户状态
    public static func nw_mineSubscribePlayer(op :DGCMine_SubscribeOption,playerIds : [Int64],
                                              success :@escaping DGCNetWorkSuccess<DGCMine_SubscribePlayerRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCMine_SubscribePlayerReq()
        dgc_body.op = op
        dgc_body.playerIds = playerIds
        
        let dgc_req = DGCNetWorkRequest<DGCMine_SubscribePlayerRes>(
            cmd: .mineSubscribePlayer,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 跟随进房获取房间ID
    public static func nw_mineFollowUserRoom(pId : Int64,
                                              success :@escaping DGCNetWorkSuccess<DGCMine_FollowUserRoomRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCMine_FollowUserRoomReq()
        dgc_body.playerID = pId
        
        let dgc_req = DGCNetWorkRequest<DGCMine_FollowUserRoomRes>(
            cmd: .MineFollowUserRoom,
            channel: .long,
            dgc_body: dgc_body,
            autoShowErrTip: true,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    // 获取房间基本信息
    public static func nw_mineGetRoomBasicInfo(roomId : Int64,
                                              success :@escaping DGCNetWorkSuccess<DGCMine_RoomBasicInfoRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCMine_RoomBasicInfoReq()
        dgc_body.roomID = roomId
        
        let dgc_req = DGCNetWorkRequest<DGCMine_RoomBasicInfoRes>(
            cmd: .MineGetRoomBasicInfo4HomeMine,
            channel: .long,
            cacheType: .cacheFromReq,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 获取房间基本信息
    public static func nw_mineGetRoomBasicInfo4HomeMine(roomId : Int64,
                                               success :@escaping DGCNetWorkSuccess<DGCMine_RoomBasicInfoSortRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCMine_RoomBasicInfoSortReq()
        dgc_body.roomID = roomId
        
        let dgc_req = DGCNetWorkRequest<DGCMine_RoomBasicInfoSortRes>(
            cmd: .MineGetRoomBasicInfo4HomeMine,
            channel: .long,
            cacheType: .cacheFromReq,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 获取路由列表
    public static func nw_mineUserCenterExtraList(success :@escaping DGCNetWorkSuccess<DGCMine_UserCenterExtraListRes>,fail:@escaping DGCNetWorkFail) {
        let dgc_body = DGCMine_UserCenterExtraListReq()
        
        let dgc_req = DGCNetWorkRequest<DGCMine_UserCenterExtraListRes>(
            cmd: .MineUserCenterExtraList,
            channel: .short,
            cacheType: .cacheFromReq,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_mineReportData(afDeviceID: String, appsFlyerUID: String, success :@escaping DGCNetWorkSuccess<DGCMine_ReportDataRes>,fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCMine_ReportDataReq()
        dgc_body.afDeviceID = afDeviceID
        dgc_body.appsFlyerUid = appsFlyerUID
        dgc_body.deviceType = .dtIosPhone
        
        let dgc_req = DGCNetWorkRequest<DGCMine_ReportDataRes>(
            cmd: .Mine_ReportData,
            channel: .short,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 获取用户背包
    public static func nw_mineAssetsBag(success :@escaping DGCNetWorkSuccess<DGCMine_AssetsBagRes>,fail:@escaping DGCNetWorkFail) {
        let dgc_body = DGCMine_AssetsBagReq()
        
        let dgc_req = DGCNetWorkRequest<DGCMine_AssetsBagRes>(
            cmd: .Mine_GetBag,
            channel: .short,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
}

