//
//  DGCNetWorkManager+Sud.swift
//  DGCNetWork
//
//  Created by Macxx on 2025/2/12.
//

import Foundation

extension DGCNetWorkManager{
    
    public static func nw_sudGameTemplateManagerNew(reqData: DGCLive_SudGameManagerNewReq, success: @escaping DGCNetWorkSuccess<DGCLive_SudGameManagerNewRes>,fail: DGCNetWorkFail? = nil) {
        let dgc_req = DGCNetWorkRequest<DGCLive_SudGameManagerNewRes>(
            cmd: .Live_SudGameTemplateManagerNew,
            channel: .long,
            body: reqData,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_getSudGameConf(roomID: Int64, success: @escaping DGCNetWorkSuccess<DGCLive_GetSudGameConfRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_GetSudGameConfReq()
        dgc_body.roomID = roomID
        
        let dgc_req = DGCNetWorkRequest<DGCLive_GetSudGameConfRes>(
            cmd: .DGCLive_SudGameConf,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_SudGameGetCode(success: @escaping DGCNetWorkSuccess<DGCLive_SudGameGetCodeRes>,fail: DGCNetWorkFail? = nil) {
        let dgc_body = DGCLive_SudGameGetCodeReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SudGameGetCodeRes>(
            cmd: .Live_SudGameGetCode,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_SudGameJoinAndExit(optType: DGCLive_SudGameJoinAndExitReq.DGCJoinAndExitType, seatIndex: Int32, success: @escaping DGCNetWorkSuccess<DGCLive_SudGameJoinAndExitRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_SudGameJoinAndExitReq()
        dgc_body.optType = optType
        dgc_body.seatIndex = seatIndex
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SudGameJoinAndExitRes>(
            cmd: .Live_SudGameJoinAndExit,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_SudGameCreateOrder(cmd: String, payload: String, success: @escaping DGCNetWorkSuccess<DGCLive_SudGameCreateOrderRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_SudGameCreateOrderReq()
        dgc_body.cmd = cmd
        dgc_body.payload = payload
        
        let dgc_req = DGCNetWorkRequest<DGCLive_SudGameCreateOrderRes>(
            cmd: .Live_SudGameCreateOrder,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_GetSudGameInfo(roomID: Int64, success: @escaping DGCNetWorkSuccess<DGCLive_SudGameInfoRes>,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLive_SudGameInfoReq()
        dgc_body.roomID = roomID
        let dgc_req = DGCNetWorkRequest<DGCLive_SudGameInfoRes>(
            cmd: .Live_SudGameInfo,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_SudGameManager(body: DGCLive_SudGameManagerReq, success: @escaping DGCNetWorkSuccess<DGCLive_SudGameManagerRes>,fail: DGCNetWorkFail? = nil) {
        let dgc_req = DGCNetWorkRequest<DGCLive_SudGameManagerRes>(
            cmd: .Live_SudGameManager,
            channel: .long,
            body: body,
            success: success,
            fail: fail
        )
        
        DGCNetWorkManager.share.send(dgc_req)
    }
}
