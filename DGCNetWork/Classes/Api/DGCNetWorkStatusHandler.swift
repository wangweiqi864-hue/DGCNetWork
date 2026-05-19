//
//  DGCNetWorkStatusHandler.swift
//  Pods
//
//  Created by mango on 2024/2/22.
//

import Foundation
import Alamofire


class DGCNetWorkStatusHandler {
    
    static let share = DGCNetWorkStatusHandler()
    
    private var dgc_isStart = false
    
    public internal(set) var nStatus = DGCNetWorkStatus.NO
    
    private init(){}
    
    func stop() {
        
    }
    
    func start() {
        if dgc_isStart {
            return
        }
        dgc_isStart = true
        //有网没网
        let dgc_status = NetworkReachabilityManager.default?.dgc_status ?? .unknown
        dgc_handleNetStatus(dgc_status: dgc_status,isFirst: true)
        
        //启动网络监听
        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: {[weak self] dgc_status in
            NWLog("网络--状态更新-dgc_status=\(dgc_status)")
            self?.dgc_handleNetStatus(dgc_status: dgc_status)
        })
    }
    
    
    
    private func dgc_handleNetStatus(status : NetworkReachabilityManager.NetworkReachabilityStatus, isFirst : Bool = false){
        let dgc_oldNetStatus = nStatus
        var dgc_type : DGCNetWorkStatus = .NO
        if status == .reachable(.cellular) {
            dgc_type = .GG
        }else if status == .reachable(.ethernetOrWiFi){
            dgc_type = .WIFI
        }
        nStatus = dgc_type
        if dgc_type == .NO{//无网络
            NWLog("网络--当前无网络")
        }else{//有网络
            NWLog("网络--当前有网络")
        }
        
        if isFirst == false && dgc_oldNetStatus != dgc_type {// 与上次不相同
            NotificationCenter.default.post(name: DGCNetWorkNotiNetStatusChanged, object: dgc_type)
        }
    }
}
