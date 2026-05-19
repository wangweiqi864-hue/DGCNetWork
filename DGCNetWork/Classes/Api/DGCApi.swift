//
//  DGCApi.swift
//  DGCNetWork
//
//  Created by Runyalsj on 2025/5/22.
//

/**
 定义对外获取Api   指定的接口和对应的方法  只读
 */
protocol DGCAPIConfigurable {
    var apiInfo: (service: String, method: String) { get }
    var method: String { get }
}



extension DGCAPIConfigurable where Self: RawRepresentable, Self.RawValue == Int {
    var apiInfo: (service: String, method: String) { ("", "") }
    // 根据外界提供的cmd 映射对应的method编号给到外界使用
    var method: String { String(self.rawValue) }
}

/**
 设计全局使用Api以及调用模式  在内部设计枚举模块细分业务层
 目的是为了更清晰直观的根据类型 映射服务器接口以及method
 
 使用
 let giftAPI = API.DGCGift.presentBag
 let method = giftAPI.method    // presentBag
 
 */
public struct DGCApi {
    
    enum DGCUnknown: Int, DGCAPIConfigurable {
        case unknown // 未知
    }
    
    //首页
    enum DGCHome: Int, DGCAPIConfigurable {
        // TODO
        case unknown // 未知
    }
    
    // 房间
    enum DGCRoom: Int, DGCAPIConfigurable {
        // TODO
        case unknown // 未知
    }
    
    enum DGCGift: Int, DGCAPIConfigurable {
        case presentBag = 12014 // 金币赠送
        case presentBuy = 12015 // 背包赠送
        case batchPresentBag = 12016 // 批量金币赠送
        case batchPresentBuy = 12017 // 批量背包赠送
        case prankEnum = 12018 // 整蛊列表
    }
    
    // 用户信息
    enum DGCUser: Int, DGCAPIConfigurable {
        // TODO
        case unknown // 未知
    }
    
    
    // ....
}




