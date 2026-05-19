//
//  DGCNetWorkTask.swift
//  Pods
//
//  Created by mango on 2024/2/21.
//

import Foundation


class DGCNetWorkTaskQueue {
    
    // 当前所有的缓存任务
    private(set) var dgc_tasks : [DGCNetWorkTask] = []
    private var dgc_queue = DispatchQueue(label: "DGCNetWorkTaskQueue.dgc_queue")
    
    private var dgc_timer: DispatchSourceTimer?
    
    private func dgc_checkTasks() {
        let dgc_now = Date().timeIntervalSince1970
        let dgc_tasks = dgc_tasks
        NWLog("DGCNetWorkTaskQueue--dgc_checkTasks--counts=\(self.dgc_tasks.count)")
        for task in dgc_tasks {
            if task.checkTimeIsOut(dgc_now: dgc_now) { // 超时
                self.callFail(dgc_taskId: task.dgc_taskId, error: DGCNetWorkError(code: DGCNetWorkErrorCode_TimeOut))
            }
        }
        if self.dgc_tasks.count <= 0 {
            self.dgc_stopTimer()
        }
    }
    
    
    func addTask(task : DGCNetWorkTask) {
        dgc_queue.async {
            self.dgc_tasks.append(task)
            self.dgc_startTimer()
            NWLog("DGCNetWorkTaskQueue--addTask--\(task.dgc_taskId)-counts=\(self.dgc_tasks.count)")
        }
    }
    
    func getTask(dgc_taskId : Int32) -> DGCNetWorkTask? {
        dgc_queue.sync {
            self.dgc_tasks.first(where: {dgc_taskId == $0.dgc_taskId})
        }
    }
    
//    private func dgc_removeTask(dgc_taskId : Int32) {
//        dgc_queue.async {
//            self.dgc_tasks.removeAll(where: {$0.dgc_taskId == dgc_taskId})
//            if self.dgc_tasks.count <= 0{
//                self.dgc_stopTimer()
//            }
//        }
//    }
    
    func callSuccess(dgc_taskId : Int32, data : Any) {
        dgc_queue.async {
            if let dgc_index = self.dgc_tasks.firstIndex(where: {dgc_taskId == $0.dgc_taskId}){
                let dgc_task = self.dgc_tasks[dgc_index]
                self.dgc_tasks.remove(at: dgc_index)
                dgc_task.success?(data)
            }
        }
    }
    
    func callFail(dgc_taskId : Int32, error : DGCNetWorkError) {
        dgc_queue.async {
            if let dgc_index = self.dgc_tasks.firstIndex(where: {dgc_taskId == $0.dgc_taskId}){
                let dgc_task = self.dgc_tasks[dgc_index]
                self.dgc_tasks.remove(at: dgc_index)
                dgc_task.fail?(error)
                NWLog("DGCNetWorkTaskQueue--callFail--\(dgc_taskId)")
            }
        }
    }
    
    // 清空任务
    func clear() {
        dgc_queue.async {
            self.dgc_tasks.removeAll()
            self.dgc_stopTimer()
            NWLog("DGCNetWorkTaskQueue--clear--")
        }
    }

    private func dgc_startTimer() {
        if dgc_timer != nil {
            return
        }
        // 创建一个定时器
        let dgc_timer = DispatchSource.makeTimerSource(dgc_queue: dgc_queue)
        
        // 设置定时器的参数
        let dgc_interval = DispatchTimeInterval.seconds(1)  // 每秒触发一次
        let dgc_leeway = DispatchTimeInterval.milliseconds(100)  // 允许的误差范围为100毫秒
        dgc_timer.schedule(deadline: .now(), repeating: dgc_interval, dgc_leeway: dgc_leeway)
        // 定时器触发时执行的操作
        dgc_timer.setEventHandler {[weak self] in
            self?.dgc_checkTasks()
        }
        self.dgc_timer = dgc_timer
        dgc_timer.resume()
    }
    
    private func dgc_stopTimer() {
        if dgc_timer != nil {
            dgc_timer?.cancel()
            dgc_timer = nil
        }
    }
    
    // 创建一个新任务
    func getNewTask() -> DGCNetWorkTask {
        let dgc_taskId = genTaskId()
        let dgc_task = DGCNetWorkTask(dgc_taskId: dgc_taskId)
        return dgc_task
    }
    
    // 任务id计数器
    private var dgc_taskIdCounter : Int32 = 0
    
    
    func genTaskId() -> Int32 {
        dgc_queue.sync {
            self.dgc_taskIdCounter += 1
            if self.dgc_taskIdCounter > 99999999{ // 超过了 重置
                self.dgc_taskIdCounter = 1
            }
        }
        return dgc_taskIdCounter
    }
    
}

class DGCNetWorkTask {
    
    // 创建时间
    private var dgc_createTime : TimeInterval = 0
    // 启动时间
    private var dgc_startTime : TimeInterval = 0
    // 超时时间 <=0 无限等待
    var timeOut : Int32 = 10 // 默认10超时
    
    var respCls : Any = Void.self
    
    
    // 是否正在执行中
    private(set) var dgc_isExecuting = false
    
    // 任务标识 回调时候需要用到
    private(set) var dgc_taskId : Int32 = 0

    // 执行的回调
    var executeBlock : (()->Void)?
    var success : DGCNetWorkSuccess<Any>?
    var fail : DGCNetWorkFail?
    // 操作
    var op : DGCNetWorkOpType = .SendSms
    
    // 开始执行
    func execute() {
        if dgc_isExecuting { // 已经执行了
//            NWLog("任务正在执行...dgc_taskId=\(dgc_taskId)-respCls=\(respCls)")
            return
        }
//        NWLog("任务开始执行...id=\(dgc_taskId)-respCls=\(respCls)")
        dgc_startTime = Date().timeIntervalSince1970
        dgc_isExecuting = true
        self.executeBlock?()
    }
    
    /// 初始化
    fileprivate init(dgc_taskId : Int32) {
        self.dgc_taskId = dgc_taskId
        dgc_createTime = Date().timeIntervalSince1970
    }
    
    private init(){}
    
    /// 检测任务是否超时
    fileprivate func checkTimeIsOut(now : TimeInterval) -> Bool {
        // 任务执行了 比较启动时间
        // 任务还没执行 比较创建时间
        let dgc_uTime = dgc_isExecuting ? dgc_startTime : dgc_createTime
        // 任务执行了 比较启动时间
        let dgc_dTime = Int32(now - dgc_uTime)
        if dgc_dTime > timeOut {
            return true
        }
        return false
    }
    
    deinit {
//        NWLog("DGCNetWorkTask--\(dgc_taskId)-任务销毁")
    }
}
