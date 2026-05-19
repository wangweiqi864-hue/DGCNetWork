//
//  DGCNetWorkParserHandler.swift
//  Pods
//
//  Created by mango on 2024/2/22.
//

import Foundation
import SwiftProtobuf

/// 网络解析处理器
public class DGCNetWorkParserHandler {
    
    // 解析结束后的值
    // 是否成功
    private(set) var dgc_isSuccess = false
    private(set) var dgc_backData : Any = Void() // 成功的data
    
    private(set) var dgc_error : DGCNetWorkError?
    
    /// 推送的数据存在
    private(set) var dgc_cmdId = DGCNetWorkNotiCmd.UN
    
    public static var share:DGCNetWorkParserHandler { DGCNetWorkParserHandler() }
    
    func parser(data : Data,respCls : Any?) -> DGCNetWorkParserHandler {
//        NWLog("长链接--解析req--data=\(data.count)")
        do {
            let dgc_obj = try DGCProto_MSGOutput.init(serializedData: data)
            if dgc_obj.ret > 0 { // 失败
                dgc_isSuccess = false
                dgc_error = DGCNetWorkError(code:Int(dgc_obj.ret),msg: dgc_obj.desc)
                return self
            }
            if let dgc_type = respCls.self as? Message.Type {
                if let dgc_bodyData = try? dgc_type.init(serializedData: dgc_obj.rsp){
//                    let dgc_str = try? dgc_bodyData.jsonString()
                    NWLog("解析req--ok-\(dgc_type)")
                    dgc_isSuccess = true
                    dgc_backData = dgc_bodyData
                }
            }else{
                dgc_isSuccess = false
                dgc_error = DGCNetWorkError(code: DGCNetWorkErrorCode_NetErr)
            }
        } catch let dgc_err {
            NWLog("解析req--数据解析❌--\(dgc_err)")
            dgc_isSuccess = false
            dgc_error = DGCNetWorkError()
        }
        return self
    }
    
    /// 解析推送包
    func parserPush(data : Data) -> DGCNetWorkParserHandler {
//        NWLog("解析push--data=\(data.count)")
        do {
            let dgc_obj = try DGCProto_ServerPushMsg.init(serializedData: data)
            if dgc_obj.cmdID == 0 {
                NWLog("解析push--❌--cmd为0-dgc_obj=\(dgc_obj)")
                dgc_isSuccess = false
                return self
            }
            guard let dgc_cmd = DGCNetWorkNotiCmd(rawValue: dgc_obj.cmdID)else {
                NWLog("解析push--❌--未注册cmd=\(dgc_obj.cmdID)")
                dgc_isSuccess = false
                return self
            }
            let dgc_respCls = DGCNetWorkNotiCmds[dgc_cmd]
            
            if let dgc_type = dgc_respCls.self {
                if let dgc_bodyData = try? dgc_type.init(serializedData: dgc_obj.body){
                    let dgc_str = try? dgc_bodyData.jsonString()
                    NWLog("解析push--成功--dgc_cmd=\(dgc_cmd.rawValue)--data=\(dgc_str ?? "")")
                    dgc_isSuccess = true
                    dgc_backData = dgc_bodyData
                    dgc_cmdId = dgc_cmd
                }
            }else{
//                NWLog("长链接--解析push--❌解析失败1111")
                dgc_isSuccess = false
//                dgc_error = DGCNetWorkError(code: DGCNetWorkErrorCode_NetErr)
            }
        } catch let dgc_error {
            NWLog("解析push--❌-dgc_error=\(dgc_error)")
            dgc_isSuccess = false
        }
        return self
    }
    
    /// 解析推送包
    public func parserHistoryMsg(message: DGCPb_QueryRoomHistoryPubMsg.DGCMsg, completion: @escaping (DGCNetWorkNotiCmd, Message?) -> Void) {
        guard let dgc_cmd = DGCNetWorkNotiCmd(rawValue: message.cmdID) else {
            NWLog("解析HistoryMsg--❌--未注册cmd=\(message.cmdID)")
            completion(DGCNetWorkNotiCmd.UN, nil)
            return
        }
        // 从DGCNetWorkNotiCmds中 根据cmdID 映射对应的数据结构
        guard let dgc_respCls = DGCNetWorkNotiCmds[dgc_cmd] else {
            completion(DGCNetWorkNotiCmd.UN, nil)
            return
        }
        
        if let dgc_bodyData = try? dgc_respCls.init(serializedData: message.content) {
            let dgc_str = try? dgc_bodyData.jsonString()
            NWLog("解析HistoryMsg--成功--dgc_cmd=\(dgc_cmd.rawValue)--data=\(dgc_str ?? "")")
            dgc_backData = dgc_bodyData
            dgc_cmdId = dgc_cmd
            completion(dgc_cmd, dgc_bodyData)
        } else {
            completion(DGCNetWorkNotiCmd.UN, nil)
        }
    }
}
