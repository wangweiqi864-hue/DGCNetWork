//
//  DGCNetWorkManager+SysNotice.swift
//  DGCNetWork
//
//  Created by apple on 2024/11/11.
//

import Foundation

extension DGCNetWorkManager{
    
    /// 未读系统站内消息 UnReadMailReq
    public static func nw_imUnReadMail(success : DGCNetWorkSuccess<DGCIM_UnReadMailRes>?,fail : DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCIM_UnReadMailReq()
        
        let dgc_req = DGCNetWorkRequest<DGCIM_UnReadMailRes>(
            cmd: .IM_SysNoticeUnReadMailInfo,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip : false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 未读活动站内消息 UnReadMailReq
    public static func nw_imUnReadMail4Activity(success : DGCNetWorkSuccess<DGCIM_UnReadMailRes>?,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCIM_UnReadMailReq()
        dgc_body.msgBelong = 1
        let dgc_req = DGCNetWorkRequest<DGCIM_UnReadMailRes>(
            cmd: .IM_SysNoticeUnReadMailInfo,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip : false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 系统站内消息 list
    public static func nw_readMailList(last_read_time : Int32 = 0,success : DGCNetWorkSuccess<DGCIM_ReadMailRes>?,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCIM_ReadMailReq()
        dgc_body.lastReadTime = last_read_time
        let dgc_req = DGCNetWorkRequest<DGCIM_ReadMailRes>(
            cmd: .IM_SysNoticeReadMailList,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip : false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 活动站内消息 list
    public static func nw_readMailList4Activity(last_read_time : Int32 = 0,success : DGCNetWorkSuccess<DGCIM_ReadMailRes>?,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCIM_ReadMailReq()
        dgc_body.msgBelong = 1
        dgc_body.lastReadTime = last_read_time
        let dgc_req = DGCNetWorkRequest<DGCIM_ReadMailRes>(
            cmd: .IM_SysNoticeReadMailList,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip : false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 设置最后查看站内信
    public static func nw_setLastMail(last_read_time : Int32, success : DGCNetWorkSuccess<DGCIM_LastMailRes>?,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCIM_LastMailReq()
        dgc_body.lastReadTime = last_read_time
        let dgc_req = DGCNetWorkRequest<DGCIM_LastMailRes>(
            cmd: .IM_SysNoticeLastMailSet,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip : false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 设置最后查看活动站内信
    public static func nw_setLastMail4Activity(last_read_time : Int32, success : DGCNetWorkSuccess<DGCIM_LastMailRes>?,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCIM_LastMailReq()
        dgc_body.msgBelong = 1
        dgc_body.lastReadTime = last_read_time
        let dgc_req = DGCNetWorkRequest<DGCIM_LastMailRes>(
            cmd: .IM_SysNoticeLastMailSet,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip : false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    public static func nw_SetDeviceInfo(pushToken:String, success: DGCNetWorkSuccess<DGCSystem_SetDeviceInfoRes>?,fail : DGCNetWorkFail? = nil) {
        var dgc_body = DGCSystem_SetDeviceInfoReq()
        dgc_body.deviceType = .dtIosPhone
        dgc_body.deviceID = UIDevice.getUUID()
        dgc_body.pushToken = pushToken
        
        let dgc_req = DGCNetWorkRequest<DGCSystem_SetDeviceInfoRes>(
            cmd: .SysNoticeSetDeviceInfo,
            channel: .short,
            cacheType: .no,
            dgc_body: dgc_body,
            autoShowErrTip : false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
}
