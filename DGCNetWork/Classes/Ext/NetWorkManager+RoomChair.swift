//
//  DGCNetWorkManager+RoomChair.swift
//  Pods
//
//  Created by mango-linwieyan on 2024/8/13.
//

import Foundation

extension DGCNetWorkManager {
    
    //
    public static func nw_ChairQueueReq(success: @escaping DGCNetWorkSuccess<DGCLive_ChairQueueRes>,fail: DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCLive_ChairQueueReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_ChairQueueRes>(
            cmd: .LiveChairQueueReq,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
//    public static func nw_ChairQueueOptReq(type : UInt32,targetId : Int64,sitType : DGCLive_SitChairType = .sctNormalSit, success :@escaping DGCNetWorkSuccess<DGCLive_ChairQueueOptRes>,fail :DGCNetWorkFail? = nil) {
//        
//        var body = DGCLive_ChairQueueOptReq()
//        body.type = type
//        body.targetID = targetId
////        body.sitType = sitType
//        
//        let req = DGCNetWorkRequest<DGCLive_ChairQueueOptRes>(
//            cmd: .LiveVideoConnectOpt,
//            channel: .long,
//            body: body,
//            autoShowErrTip: false,
//            success: success,
//            fail: fail
//        )
//        
//        DGCNetWorkManager.share.send(req)
//    }
    
    public static func nw_ChairQueueJumpReq(targetId : Int64, 
                                            success :@escaping DGCNetWorkSuccess<DGCLive_ChairQueueJumpRes>,
                                            fail :DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_ChairQueueJumpReq()
        dgc_body.targetID = targetId
        
        let dgc_req = DGCNetWorkRequest<DGCLive_ChairQueueJumpRes>(
            cmd: .LiveChairQueueJumpReq,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_SwitchRoomChairModeReq( modeType : DGCLive_SeatModeType,
                                                  success :@escaping DGCNetWorkSuccess<DGCLive_SwitchRoomChairModeRes>,
                                                  fail :DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLive_SwitchRoomChairModeReq()
        dgc_body.modeType = modeType
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SwitchRoomChairModeRes>(
            cmd: .LiveSwitchRoomChairMode,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
}
