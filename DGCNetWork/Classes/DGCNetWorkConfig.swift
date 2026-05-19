//
//  DGCNetWorkConfig.swift
//  Pods
//
//  Created by mango on 2024/2/22.
//

import Foundation

// 网络配置
public struct DGCNetWorkConfig {
    // 短链接
    public var shortHost : String // host
    public var shortPort : String // 端口 默认80
    
    // 长连接
    public var longHost : String // host
    public var longPorts : [String] // 长连接端口
    public var longBackupIps : [String] // 配用ip
    
    public var imgHost: String // 图片域名
    
    public init(shortHost: String,
                shortPort: String = "80",
                longHost: String,
                longPorts: [String],
                longBackupIps: [String],
                imgHost: String) {
        self.shortHost = shortHost
        self.shortPort = shortPort
        self.longHost = longHost
        self.longPorts = longPorts
        self.longBackupIps = longBackupIps
        self.imgHost = imgHost
    }
    
}
