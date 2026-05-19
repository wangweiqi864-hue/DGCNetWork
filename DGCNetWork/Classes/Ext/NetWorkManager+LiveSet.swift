//
//  DGCNetWorkManager+RoomSet.swift
//  Pods
//
//  Created by mango2333 on 2024/6/6.
//

import Foundation

extension DGCNetWorkManager {
    
    ///关闭游戏时调用
    public static func nw_live_patternChange(data: DGCLive_ChangeRoomPatternReq, success: DGCNetWorkSuccess<DGCLive_ChangeRoomPatternRes>? = nil,fail: DGCNetWorkFail? = nil) {
        let dgc_req = DGCNetWorkRequest<DGCLive_ChangeRoomPatternRes>(
            cmd: .Live_ChangeRoomPattern,
            channel: .long,
            body: data,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    /// 房间设置
    public static func nw_live_set(data: DGCLive_SetRoomReq, success: DGCNetWorkSuccess<DGCLive_SetRoomRes>? = nil,fail: DGCNetWorkFail? = nil) {
        let dgc_req = DGCNetWorkRequest<DGCLive_SetRoomRes>(
            cmd: .LiveSet,
            channel: .long,
            body: data,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 获取房间模式列表配置
    public static func nw_live_getRoomConf(success: DGCNetWorkSuccess<DGCLive_GetRoomConfRes>?,fail: DGCNetWorkFail?) {
        let dgc_data = DGCLive_GetRoomConfReq()
        let dgc_req = DGCNetWorkRequest<DGCLive_GetRoomConfRes>(
            cmd: .LiveGetRoomConf,
            channel: .long,
            cacheType: .cacheFromReq,
            body: dgc_data,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 获取房间背景
    public static func nw_live_getBg(success: DGCNetWorkSuccess<DGCLive_GetRoomBgRes>?,fail: DGCNetWorkFail?) {
        let dgc_data = DGCLive_GetRoomBgReq()
        let dgc_req = DGCNetWorkRequest<DGCLive_GetRoomBgRes>(
            cmd: .Live_GetBg,
            channel: .long,
            body: dgc_data,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 更改房间背景
    public static func nw_live_changeBg(roomID: Int64, roomBgID: Int32, success: DGCNetWorkSuccess<DGCLive_ChangeRoomBgRes>?,fail: DGCNetWorkFail?) {
        var dgc_data = DGCLive_ChangeRoomBgReq()
        dgc_data.roomID = roomID
        dgc_data.roomBgID = roomBgID
        let dgc_req = DGCNetWorkRequest<DGCLive_ChangeRoomBgRes>(
            cmd: .Live_ChangeBg,
            channel: .long,
            body: dgc_data,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
}
