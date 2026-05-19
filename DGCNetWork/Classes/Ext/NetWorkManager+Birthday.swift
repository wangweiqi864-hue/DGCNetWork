//
//  DGCNetWorkManager+Birthday.swift
//  DGCNetWork
//
//  Created by apple on 2026/3/31.
//


import Foundation

extension DGCNetWorkManager {
    
    // 生日派对开始界面信息 剩余次数
    public static func nw_birthdayStartMainReq(success:@escaping DGCNetWorkSuccess<DGCPb_RoomBirthdayStartMainRes>,
                                              fail:@escaping DGCNetWorkFail) {
        let dgc_body = DGCPb_RoomBirthdayStartMainReq()
        
        let dgc_req = DGCNetWorkRequest<DGCPb_RoomBirthdayStartMainRes>(
            cmd: .Birthday_StartMainReq,
            channel:.long,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 生日派对开始
    public static func nw_birthdayStartReq(protagonistID:Int64,durationHour:Int64, success:@escaping DGCNetWorkSuccess<DGCPb_RoomBirthdayStartRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCPb_RoomBirthdayStartReq()
        dgc_body.protagonistID = protagonistID
        dgc_body.durationHour = durationHour
        
        let dgc_req = DGCNetWorkRequest<DGCPb_RoomBirthdayStartRes>(
            cmd: .Birthday_StartReq,
            channel:.long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 主页面
    public static func nw_birthday_MainReq(success:@escaping DGCNetWorkSuccess<DGCPb_RoomBirthdayMainRes>,
                                              fail:@escaping DGCNetWorkFail) {
        let dgc_body = DGCPb_RoomBirthdayMainReq()
        
        let dgc_req = DGCNetWorkRequest<DGCPb_RoomBirthdayMainRes>(
            cmd: .Birthday_MainReq,
            channel:.long,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 生日派对结束
    public static func nw_birthdayEndReq(success:@escaping DGCNetWorkSuccess<DGCPb_RoomBirthdayEndRes>,
                                              fail:@escaping DGCNetWorkFail) {
        let dgc_body = DGCPb_RoomBirthdayEndReq()
        
        let dgc_req = DGCNetWorkRequest<DGCPb_RoomBirthdayEndRes>(
            cmd: .Birthday_EndReq,
            channel:.long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 生日派对弹幕发
    public static func nw_birthdayFloatReq(roomID:Int64,content:String, success:@escaping DGCNetWorkSuccess<DGCPb_RoomBirthdayFloatRes>,
                                              fail:@escaping DGCNetWorkFail) {
        var dgc_body = DGCPb_RoomBirthdayFloatReq()
        dgc_body.roomID = roomID
        dgc_body.content = content
        
        let dgc_req = DGCNetWorkRequest<DGCPb_RoomBirthdayFloatRes>(
            cmd: .Birthday_FloatReq,
            channel:.long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 生日派对配置
    public static func nw_birthdayConfReq(success:@escaping DGCNetWorkSuccess<DGCPb_RoomBirthdayConfRes>,
                                              fail:@escaping DGCNetWorkFail) {
        let dgc_body = DGCPb_RoomBirthdayConfReq()
        
        let dgc_req = DGCNetWorkRequest<DGCPb_RoomBirthdayConfRes>(
            cmd: .Birthday_ConfReq,
            channel:.long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
}
