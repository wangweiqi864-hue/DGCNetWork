//
//  DGCNetWorkManager+DGCHome.swift
//  Pods
//
//  Created by mango on 2024/5/11.
//

import Foundation

extension DGCNetWorkManager{
    
    // 请求首页导航数据
    public static func nw_home_navList(cacheType: DGCNetWorkCacheType, success: @escaping DGCNetWorkSuccess<DGCHome_GetPHomeNavRes>,fail: @escaping DGCNetWorkFail) {
        var dgc_body = DGCHome_GetPHomeNavReq()
        dgc_body.type = .htIndex

        let dgc_req = DGCNetWorkRequest<DGCHome_GetPHomeNavRes>(
            cmd: .HomeNav,
            channel: .short,
            cacheType: cacheType,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 请求首页模块数据
    public static func nw_home_modList(dgc_req: DGCHome_GetPHomeModReq,cacheType:DGCNetWorkCacheType = .no, queue : DispatchQueue = DispatchQueue.main, success: @escaping DGCNetWorkSuccess<DGCHome_GetPHomeModRes>, fail: @escaping DGCNetWorkFail) {
        let dgc_req = DGCNetWorkRequest<DGCHome_GetPHomeModRes>(
            cmd: .HomeMod,
            channel: .short,
            cacheType:cacheType,
            body: dgc_req,
            callQueue: queue,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 请求搜索
    public static func nw_searchPlayer(keyword: String, page: Int32, pageSize: Int32, success: @escaping DGCNetWorkSuccess<DGCSearch_SearchPlayersRes>, fail: @escaping DGCNetWorkFail) {
        var dgc_body = DGCSearch_SearchPlayersReq()
        dgc_body.keyWord = keyword
        dgc_body.page = page
        dgc_body.pageSize = pageSize
        
        let dgc_req = DGCNetWorkRequest<DGCSearch_SearchPlayersRes>(
            cmd: .SearchPlayer,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 请求banner
    public static func nw_bannerData(type: DGCHome_BannerPosType, success: @escaping DGCNetWorkSuccess<DGCHome_GetBannerDataRes>, fail: @escaping DGCNetWorkFail) {
        var dgc_body = DGCHome_GetBannerDataReq()
        dgc_body.posType = type
        
        let dgc_req = DGCNetWorkRequest<DGCHome_GetBannerDataRes>(
            cmd: .HomeBannerData,
            channel: .long,
            cacheType: .cacheFromReq,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
}
