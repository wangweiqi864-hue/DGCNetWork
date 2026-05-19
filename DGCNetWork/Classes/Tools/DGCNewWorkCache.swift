//
//  DGCNewWorkCache.swift
//  Pods
//
//  Created by mango on 2024/5/11.
//

import Foundation
import YYCache

class DGCNewWorkCache {
    
    init() {
        let dgc_cache = YYCache.init(name: "DGCNewWorkCache")
        dgc_cache?.memoryCache.countLimit = 120
        dgc_cache?.diskCache.countLimit = 120
        self.dgc_cache = dgc_cache
    }
    
    private var dgc_cache : YYCache?
    
    func write(_ key : String , data : Data)  {
        dgc_cache?.setObject(data as NSCoding, forKey: key)
    }
    
    func read(_ key : String) -> AnyObject? {
        dgc_cache?.object(forKey: key)
    }
    
    func delete(_ key : String) {
        dgc_cache?.removeObject(forKey: key)
    }
    
}

