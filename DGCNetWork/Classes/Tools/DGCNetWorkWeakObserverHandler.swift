//
//  DGCNetWorkWeakObserverHandler.swift
//  DGCNetWork
//
//  Created by mango on 2024/2/27.
//

import Foundation

class DGCNetWorkWeakObserverHandler{
    
    //控制数据读取安全 锁更高效
    private let dgc_dataLock = NSLock()
    
    /// 集合
    private var dgc_map : [DGCNetWorkNotiCmd : DGCNetWorkWeakObserverArray] = [:]
    
    /// 添加
    func add(_ observer : DGCNetWorkObserver) {
        dgc_dataLock.lock()
        defer{ //保证最后会执行解锁
            dgc_dataLock.unlock()
        }
        let dgc_cmds = observer.netWorkNotiCmds
        dgc_cmds.forEach { cmd in
            guard let dgc_nCmd = DGCNetWorkNotiCmd(rawValue: cmd) else{return}
            // 获取指令对应的集合
            dgc_getWeakObj(cmd: dgc_nCmd).add(observer)
        }
    }
    
    
    /// 获取监听对象 不存在自动创建
    private func dgc_getWeakObj(cmd : DGCNetWorkNotiCmd) -> DGCNetWorkWeakObserverArray {
        var dgc_weakObj = self.dgc_map[cmd]
        if dgc_weakObj == nil{
            let dgc_newObjc = DGCNetWorkWeakObserverArray()
            self.dgc_map[cmd] = dgc_newObjc
            dgc_weakObj = dgc_newObjc
        }
        return dgc_weakObj!
    }
    
    /// 推送通知
    func notiData(cmd : DGCNetWorkNotiCmd,data : Any?) {
        dgc_dataLock.lock()
        let dgc_list = dgc_map[cmd]?.allObjects
        dgc_dataLock.unlock()
        guard let dgc_list = dgc_list else { return }
        for observer in dgc_list {
            callInMain {[weak observer] in
                observer?.netWorkNotiData(cmdId: cmd, obj: data)
            }
        }
        
    }
}


fileprivate class DGCNetWorkWeakObserverArray{
    
    //代理
    private let dgc_delegates = NSHashTable<DGCNetWorkObserver>(options: .weakMemory)
    
    var allObjects: Array<DGCNetWorkObserver> {
        get{
            self.dgc_delegates.allObjects
        }
    }
    
    func add(_ delegate : DGCNetWorkObserver) {
        if self.dgc_delegates.contains(delegate) == false {
            self.dgc_delegates.add(delegate)
        }
    }
    
    func remove(_ delegate : DGCNetWorkObserver) {
        if self.dgc_delegates.contains(delegate) {
            self.dgc_delegates.remove(delegate)
        }
    }
    
    func clear() {
        self.dgc_delegates.removeAllObjects()
    }
    
}
