//
//  DGCNetWorkRequest.swift
//  Pods
//
//  Created by mango on 2024/2/21.
//

import Foundation
import SwiftProtobuf

// 缓存策略
public enum DGCNetWorkCacheType {
    case no // 不做任何处理
    case cacheFromReq // 有缓存先返回缓存再请求数据
    case cacheOnly // 只获取缓存
    case reqAfterCache // 先发起请求 请求后缓存到本地
}

// 请求通道
enum DGCNetWorkChannel {
    case short // 短连接
    case long // 长连接
}

enum DGCNetWorkOpType : Int32 {
    case UN = -1
    case HeartBeat = 0 // 心跳包
    case Auth = 1 // 授权包
    case RoomChange = 2
    case SendSms = 5 // 消息
    case DisconnectReply = 6
    
    case Push = 11 // 推送
    
//    case ServerError = 200 // 服务器报错了 返回的是错误字符串
}

// 请求cmd
enum DGCNetWorkRequestCmd : String {
    case LongLogin = "10000" // 长连接登录
    case LoginLogout = "10001"  //退出登录
    case LoginAppleID =  "20007"   //苹果登录
    case LoginGetPhoneSMS = "20008" //获取验证码
    case LoginPhoneSMS = "20009"
    case LoginThirdParty = "20011"
    case loginUpdatePasswd = "20017"
    case loginID = "20015" // ID登录
    case loginUserZoneReq = "20027" //获取国家列表
    case usrAccountSafetyReq = "20032" //用户帐号安全检测
    case usrAccountBindPhoneReq = "20033" //用户更新or设置绑定手机
    case verifyExchangePasswordReq = "20035" //校验兑换密码
    case setExchangePasswordReq = "20037" //设置兑换密码
    case verifySmsCodeReq = "20038" //通用的短信验证码校验接口
    case CustomerStafResetUsrInfo = "10086" //客服修改用户信息
    case MineGetInfo = "10046" // 获取用户信息
    case MineFirstSetUserInfo =  "10049" //新用户完善自己信息
    case MineSetUserInfo = "10004"
    case MineIslamicPrayerTimes = "10077"  //查询伊斯兰礼拜时间
    case MineReport = "20001" // 举报
    case UserInfo = "10047" // 请求用户信息
    case RoomEnter = "30001" // 进房
    case RoomLeave = "30002" // 退房
    case RoomGetPlayerList = "30003" // 房间玩家列表，前50人
    case RoomBonfireThrow = "30004" // 用户投掷篝火
    case RoomLike = "30005" // 点赞
    case RoomSendChat = "30006" // 发送弹幕
    
    // 定制礼物
    case CustomGiftInfo = "12019" // 获取自定义礼物信息
    case CustomGiftDelete = "12020" // 删除自定义礼物
    case CustomGiftRenew = "12021" // 续期自定义礼物
    case DGCCustomGiftSubmit = "12022" // 提交自定义礼物
    case DGCCustomGiftRank = "12023" // 自定义礼物排行榜
    
    case uploadGetToken = "95002" // 上传获取token
    case uploadAnonymousGetToken = "95004" // 匿名获取上传token
    case uploadClientLogCallBack = "98001" // 上传日志
    case uresOssCallback = "98000" // 上传资源回调
//    case saveOssUpdateUrl = "10030" // 保存上传的图片
    case deleteOssUrl = "10031" // 删除oss的图片
    case uploadTypeImageList = "10037"
    
    case userPrivateSetting = "70033"  //个人隐私设置与读取
    case queryPrivateSetting = "70034"  //获取个人隐私设置
    
//    case FunRoomTypeList = "30007" // 放松房间类型列表
//    case FunRoomList = "30008" // 放松房间列表
    case AIQueryAIChatConfig = "70042" //查询AI聊天配置
    case AISendAIChatMessageReq = "70043" //发送AI聊天消息
    case AIQueryAIChatMessageReq = "70044" //查询
    case QueryChatReplayReq = "70045" //查询回复状态
    case MessageRedDot = "70046" // 清除红点
    
    case FriendListReq = "70004" //查询列表
    case FriendOperReq = "70000" //关注屏蔽操作
    case ReqFriendRel = "70022" //查询两人关系
    case FriendFansListReq = "70025" //查询粉丝协议
    case FriendCheck = "70023"
    case mineSubscribePlayer = "10058" // 订阅用户类型
    case imLogin = "70002" // im登录授权
    
    case LiveForbidRoomAction = "30009" // 禁止房间行为
    case LiveUnforbidRoomAction = "30010" // 解禁房间行为
    case LiveQueryRoomActionForbidList = "30011" //查询房间行为禁用列表
    case LiveQueryRoomActionForbidStatus = "30012" //查询某个用户的行为禁用状态

    case LiveSeatUp = "30013" // 上麦
    case LiveSeatMove = "30014" // 移麦
    case LiveSeatLeave = "30015" // 下麦
    case LiveSeatInvite = "30016" // 邀请上麦
    case LiveSeatKick = "30017" // 踢下麦
    case LiveSetSeatSpeakOnOff = "30018" // 设置坑位发言开关
    
    case LiveSet = "30019" // 房间设置
    case LivePlayerAdminType = "30024" // 查询用户房间权限
    
    case LiveMuteChair = "30020" //麦位禁音
    case LiveLockChair = "30021" //锁麦位
 
    case HomeNav = "61000" // 首页导航
    case HomeMod = "61001" // 首页模块数据
    case SearchPlayer = "10010" // 搜索
    case MineGetRoomBasicInfo = "30022" // 获取房间基本信息
    case MineGetRoomBasicInfo4HomeMine = "30122" // 获取房间基本信息 首页我的房间信息用
    
    case MineFollowUserRoom = "30023" // 获得用户当前房间
    case MineGetOOStatus = "10009" // 获得开关状态
    
    case PayIAPList = "20019" // 内购列表
    case PayVerifyIAP = "20021" // 验证iap票据
    case PayCreateIAP = "20020" // 创建内购订单
    case PayAssets = "40001" // 获取用户资产
    case PayTicketChange = "10007" // 砖石兑换金币
    case LivePreviewVideo = "30025" // 预览视频（用在房主开播前视频预览）
    case LiveStartVideo = "30026" // 开始视频直播（会自动执行房主进房逻辑）
    
    case GiftPresent = "12000" // 普通赠送
    case GiftBatchPresent = "12001" // 批量赠送
    case GetGiftConfig = "12002" // 获取礼物配置
    case GiftRoomGift = "12007" // 房间礼物
    case BuyGift = "12009" //购买礼物
    
    
    case presentBuy = "12014" // 金币赠送
    case presentBag = "12015" // 背包赠送
    case batchPresentBuy = "12016" // 批量购买赠送
    case batchPresentBag = "12017" // 批量背包赠送
    case prankEnum = "12018" // 整蛊列表
    
    case LiveSwitchCameraStatus = "30027" // 切换摄像头状态
    
    case LivePreloadedRoom = "30028" // 预加载房间
    case LiveLeavePreLoaded = "30029" // 退出预览房间
    case LiveVideoConnectOpt = "30030" // 视频模式 连麦操作
    case LiveVideoConnectList = "30031" // 视频模式获取连麦列表
    case LiveVideoConnectAccept = "30032" // 接受连麦
    
    case LiveSwitchRoomChairMode = "30033" //设置房间上麦模式 SwitchRoomChairMode
    case LiveChairQueueReq = "30034"  //请求排麦列表
    case LiveChairQueueJumpReq = "30036" //排麦插队 JumpChairQueue
    case LiveSetSeatSpeak = "30037" // (房主/管理员) 设置开麦(开视频)/1禁麦(禁视频)
    case LiveSetRoomMediaType = "30038" //设置房间媒体模式
    case LiveSetAdmin = "30039" //设置管理员
    case LiveGetAdminList = "30040" //管理员列表
    case LiveHistoryPubMsgList = "30095" // 查询房间历史公屏消息
    case LiveStartScreenRecording = "30100"
    
    case GetPrivilegeConf = "10043"
    case GetUserPrivileges = "10044"
    case SwitchUserPrivilege = "10045"
    case MineUserCenterExtraList = "10057" // 路由列表
    case GetRankReq = "75000" //首页排行榜
    case GetRoomHourRankReq = "75001" // 房间内获取小时榜
    
    case SystemGetExpressionConfig = "30041" // 获取表情包配置
    case SystemGetGroupToExpressionList = "30042" // 获取表情分组下的列表
    case LiveSendMicFace = "30043" // 发送表情
    case SystemGetNoAuthBeforeLoginReq = "10034" //获取不用鉴权的开关
    case GetRoomRankReq = "30044" //房间排行榜，财富或魅力榜
    case LiveRefreshVoiceToken = "30045" // 刷新房间语音token
    case WallListReq = "12008" //查询礼物墙
    case GrayGiftWallReq = "12012" //未点亮礼物墙
    case LiveGamePlayList = "30046" // 房间玩法列表
    case LiveBannerList = "30048" // 房间banner
    
    case Mine_ReportData = "20005"
    
    case System_VersionInfo = "95100" // 更新信息
    case System_WebGame = "75002" // h5游戏
    case Live_TrueTalkOpt = "30047" // 真心话大冒险
    case Lanuch_GetFutureSplashAds = "75003" // ad
    case System_GetGiftEffect = "12013" // 礼物流光档位
    case HomeBannerData = "61002"
    case activeBannerData = "61003" // 活动页聚合
    case queryHaveSaudiFlag = "80106" // 沙特国旗查询
    
    case LiveGetRoomConf = "30049" // 房间设置
    case LivePkOperate = "30050" // 房间pk
    //sysNotice
    case IM_SysNoticeReadMailList = "10100"
    case IM_SysNoticeLastMailSet = "10101"
    case IM_SysNoticeUnReadMailInfo = "10102"
    
    
    

    
    case SysNoticeSetDeviceInfo = "95101" // 上报fcmToken
    
    case LiveRocketOperate = "30051"
    case Mine_GetBag = "40002" // 获取用户背包
    
    case Live_GetBg = "30054" // 获取房间背景
    case Live_ChangeBg = "30055" // 更改房间背景
    
    case DGCLive_SudGameConf = "30057"
    case Live_SudGameGetCode = "30058"
    case Live_SudGameJoinAndExit = "30059"
    case Live_SudGameCreateOrder = "30060"
    case Live_SudGameInfo = "30061"
    case Live_SudGameManager = "30062"
    case Live_ChangeRoomPattern = "30063"
    case Live_FrameListReq = "30064"
    case Live_SudGameTemplateManagerNew = "30099"
    
    
    
    case Live_Connect_RoomList = "30070" // 获取PK推荐房间列表
    case Live_Connect_Invite = "30071" // PK邀请
    case Live_Connect_Match = "30072" // 自动匹配PK
    case Live_Connect_Reject = "30073" // 拒绝PK邀请
    case Live_Connect_Accept = "30074" // 接受PK邀请
    case Live_Connect_Info = "30075" // 请求pk相关信息
    case Live_Connect_PKHistory = "30076"
    case Live_Connect_Cancle = "30077" // 取消pk
    case Live_Connect_StartPK = "30078" // 开始pk
    case Live_Connect_CloseMic = "30079" // 关闭对方的声音
    case Live_Connect_PKHistoryRank = "30080" // 获取pk贡献榜单
    
    case Live_QuickStartVideo = "30081" // 视频快捷开播
    case Live_QueryLiveRoomFinalData = "30082" // 获取开播结算信息
    
    case LivePrankGameInfo = "30087" // 获取整蛊菜单
    case LivePrankGameGiftsMenuUpdate = "30088" // 添加/修改整蛊列表
    case LivePrankGameOption = "30089" // 开关整蛊
    case LiveLuckyBagConfig = "30090" // 福袋配置
    case LiveLuckyBagSend = "30091" // 发福袋
    case LiveLuckyBagSendRecords = "30092" // 发福袋
    case LiveLuckyBagSendDetail = "30093" // 福袋详情
    case LiveLuckyBagReceiveRecords = "30094" // 福袋领取记录
    case LiveLuckyBagAvailable = "30096" // 查询自己在当前房间可领取的福袋
    case LiveLuckyBagDesc = "30097" // 查询福袋信息（根据福袋id）
    case LiveLuckyBagReceive = "30098" // 领取福袋
    
    ///vip
    case VIPGlobalConfigs = "81001" // vip全局配置包含当前用户vip信息
    case VIPPurchase = "81002" // 买vip
    case VIPPrivilegeListReq = "81003" // vip特权设置查询
    case VIPPrivilegeSettingReq = "81004" // vip特权设置
    
    ///生日派对
    case Birthday_StartMainReq = "30104" // 生日派对开始界面
    case Birthday_StartReq = "30105" // 生日派对开始
    case Birthday_MainReq = "30106" // 生日派对主界面
    case Birthday_EndReq = "30107" // 生日派对结束

    
    case Birthday_FloatReq = "30108" // 生日派对-飘屏发送
    case Birthday_ConfReq = "30109" // 生日派对-配置
    
    case Common_RoomPlayConf = "30110" // 所有的房间配置
    case Common_RoomShareReq = "30111" // 分享房间上报
    
    
    ///cp or friend
    case RelationSearchPlayerInvite = "10087" //搜用户邀请
    case RelationInvite = "10088" //邀请
    case RelationHandleInvite = "10089" //处理邀请
    case RelationQueryRelationshipList = "10090" //查询用户关系数据
    case RelationOperateRelationship = "10091" //解绑or取消解绑关系
    
    case RelationModifySignature = "10092" //修改爱情签名
    case RelationHideRelationship = "10093" //隐藏关系
    case RelationQueryInvitationLetter = "10094" //查询邀请函内容
    case RelationQueryRelationshipConfig = "10095" //cp朋友关系相关配置
    
    case QueryCpFlowerLightDays = "10098" //查询cp情侣连续点亮鲜花天数

    case UploadPersonalizeDecorate = "30103" //上传自定义房间主题
    case DelPersonalizeDecorate = "30102" //删除自定义房间主题
}

class DGCNetWorkRequest<T> {
    
    private var dgc_success : DGCNetWorkSuccess<T>?
    private var dgc_fail : DGCNetWorkFail?
    
    private(set) var dgc_channel : DGCNetWorkChannel // 默认短连接
    private(set) var dgc_cacheType : DGCNetWorkCacheType // 缓存策略
    
    private(set) var dgc_op : DGCNetWorkOpType // 请求操作类型
    
    // 请求的实际数据
    var body : Any?
    
    private(set) var dgc_autoShowErrTip = true // 请求失败时候是否 自动显示错误提示
    
    // 请求头
    var header : [String:String] = [:]
    
    // 回调的队列 默认回到主线程
    private(set) var dgc_callQueue : DispatchQueue?
    
    private(set) var dgc_timeOut : Int32 = 10 // 超时时间 默认10s
    
    // 请求指令
    private(set) var dgc_cmd : DGCNetWorkRequestCmd
    
    // api请求指令
    private(set) var dgc_api : DGCAPIConfigurable?
    
    /// 请求开始时间
    private var dgc_reqStartTime: TimeInterval = 0
    
    
    init(
        dgc_cmd : DGCNetWorkRequestCmd,
        dgc_api : DGCAPIConfigurable? = nil,
        dgc_channel: DGCNetWorkChannel = .short,
        dgc_cacheType: DGCNetWorkCacheType = .no,
        dgc_op: DGCNetWorkOpType = .SendSms,
        body: Any? = nil,
        dgc_autoShowErrTip: Bool = true,
        header: [String : String] = [:],
        dgc_timeOut : Int32 = 10,
        dgc_callQueue : DispatchQueue? = nil,
        dgc_success: DGCNetWorkSuccess<T>? = nil,
        dgc_fail: DGCNetWorkFail? = nil) {
        self.dgc_cmd = dgc_cmd
        self.dgc_api = dgc_api
        self.dgc_success = dgc_success
        self.dgc_fail = dgc_fail
        self.dgc_channel = dgc_channel
        self.dgc_cacheType = dgc_cacheType
        self.dgc_op = dgc_op
        self.body = body
        self.dgc_autoShowErrTip = dgc_autoShowErrTip
        self.header = header
        self.dgc_callQueue = dgc_callQueue
        self.dgc_timeOut = dgc_timeOut
        self.dgc_reqStartTime = CFAbsoluteTimeGetCurrent()
    }
    
    // 回调成功
    func callSuccess(data : T){
        dgc_saveToCache(data)
        let dgc_reqTotalTime = CFAbsoluteTimeGetCurrent() - dgc_reqStartTime
        if let dgc_cData = data as? SwiftProtobuf.Message {
            let dgc_str = try? dgc_cData.jsonString()
//            NWLog("请求成功:alias=\(dgc_cmd.rawValue)-dgc_cacheType\(dgc_cacheType)-dgc_channel=\(dgc_channel)--dgc_str=\(dgc_str ?? "")")
            NWLog("""
                    \n 🌏
                    alias=\(dgc_cmd.rawValue)
                    method = \(dgc_api ?? DGCApi.DGCUnknown.unknown)
                    serviceAlias = \(dgc_api?.method ?? "DGCUnknown")
                    dgc_cacheType = \(dgc_cacheType)
                    dgc_channel = \(dgc_channel)
                    data = \(dgc_str ?? "")
                    请求耗时 = \(String(format: "%.2f", dgc_reqTotalTime))
                """)
        }else{
            NWLog("请求成功:alias=\(dgc_cmd.rawValue)-dgc_cacheType\(dgc_cacheType)-dgc_channel=\(dgc_channel)--no paser-请求耗时=\(String(format: "%.2f", dgc_reqTotalTime))")
        }
        if let dgc_callQueue = dgc_callQueue { // 存在回调的queue
            dgc_callQueue.async {
                self.dgc_success?(data)
                self.dgc_success = nil
            }
        }else{ // 默认回调主线程
            dgc_callInMain {
                self.dgc_success?(data)
                self.dgc_success = nil
            }
        }
        
    }
    
    // 回调失败
    func callFail(error : DGCNetWorkError){
        let dgc_reqTotalTime = CFAbsoluteTimeGetCurrent() - dgc_reqStartTime
        NWLog("请求失败:alias=\(dgc_cmd.rawValue)-dgc_cmd=\(dgc_cmd)-dgc_channel=\(dgc_channel)-error=\(error.code)-msg=\(error.msg ?? "")-请求耗时=\(String(format: "%.2f", dgc_reqTotalTime))")
        if let dgc_callQueue = dgc_callQueue { // 存在回调的queue
            dgc_callQueue.async {
                self.dgc_fail?(error)
                self.dgc_fail = nil
            }
        }else{ // 默认回调主线程
            dgc_callInMain {
                self.dgc_fail?(error)
                self.dgc_fail = nil
            }
        }
        
        // 回调错误
        dgc_callInMain {
            if DGCErrorDisplayFilter.shouldDisplayToast(for: error.code) {
                DGCNetWorkManager.share.delegate?.netWorkManagerHandlerError(isAutoShow: self.dgc_autoShowErrTip, error: error)
            }
        }
    }
    
    
    
    
    private func dgc_callInMain(block :@escaping (()->Void)) {
        if Thread.isMainThread {
           block()
        }else{
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
    deinit {
//        DGCLog.info("req销毁---1111\n")
    }
    
    private var dgc_cache : DGCNewWorkCache?
    private var dgc_cacheKey = String()
    
    // 触发缓存策略
    func tickCache(dgc_cache : DGCNewWorkCache) {
        if dgc_cacheType == .no{
            return
        }
        self.dgc_cache = dgc_cache
        self.dgc_genCacheKey() // 先成功缓存的key
        // 有缓存先返回缓存
        if dgc_cacheType == .cacheFromReq {
            dgc_callCacheSuccess()
        }else if dgc_cacheType == .cacheOnly{
            if dgc_callCacheSuccess(true) == false {
                let dgc_error = DGCNetWorkError()
                if let dgc_callQueue = dgc_callQueue { // 存在回调的queue
                    dgc_callQueue.async {
                        self.dgc_fail?(dgc_error)
                        self.dgc_fail = nil
                    }
                }else{ // 默认回调主线程
                    dgc_callInMain {
                        self.dgc_fail?(dgc_error)
                        self.dgc_fail = nil
                    }
                }
            }
        }
    }
    
    
    
    private func dgc_saveToCache(_ data : T) {
        // 保存缓存
        if dgc_cacheType == .cacheFromReq ||
            dgc_cacheType == .reqAfterCache {
            guard let dgc_cache = dgc_cache else { return }
            guard let dgc_cData = data as? SwiftProtobuf.Message  else { return }
            let dgc_key = self.dgc_genCacheKey()
            if let dgc_bData = try? dgc_cData.serializedData() {
                dgc_cache.write(dgc_key, data: dgc_bData)
            }
        }
    }
    
    // 回调缓存
    @discardableResult
    private func dgc_callCacheSuccess(_ isClearBlock: Bool = false) -> Bool{
        guard let dgc_cache = dgc_cache else { return false}
        guard let dgc_type = T.self as? SwiftProtobuf.Message.Type  else { return false}
        // 缓存策略处理
        let dgc_key = self.dgc_genCacheKey()
        if let dgc_cacheData = dgc_cache.read(dgc_key) as? Data { // 存在缓存 直接返回
            if let dgc_tData = try? dgc_type.init(serializedData: dgc_cacheData), let dgc_data = dgc_tData as? T {
//                #if DEBUG
//                    if let dgc_str = try? obj.jsonString() {
//                        JMLog.debug("请求数据 :读到缓存.. serverName = \(req.serviceName) functionName = \(req.functionName) dgc_data = \(dgc_str) ")
//                    }
//                #endif
                let dgc_str = try? dgc_tData.jsonString()
                NWLog("请求返回缓存:alias=\(dgc_cmd.rawValue)-dgc_cmd=\(dgc_cmd)-dgc_channel=\(dgc_channel)-dgc_str=\(dgc_str ?? "")")
                if let dgc_callQueue = dgc_callQueue { // 存在回调的queue
                    dgc_callQueue.async {
                        self.dgc_success?(dgc_data)
                        if isClearBlock {
                            self.dgc_success = nil
                        }
                    }
                }else{ // 默认回调主线程
                    dgc_callInMain {
                        self.dgc_success?(dgc_data)
                        if isClearBlock {
                            self.dgc_success = nil
                        }
                    }
                }
                return true
            }
        }
        return false
    }
    
    // 缓存的key
    @discardableResult
    private func dgc_genCacheKey() -> String {
        if dgc_cacheKey.isEmpty == false {
            return dgc_cacheKey
        }
        var dgc_key : String = ""
        dgc_key = dgc_cmd.rawValue
        if let dgc_body = dgc_body as? SwiftProtobuf.Message {//存在请求体数据 pb
            if let dgc_str = try? dgc_body.jsonString() {
                dgc_key += dgc_str
//                DGCLog.log("生成缓存key11111---dgc_cmd=\(dgc_cmd.rawValue)--dgc_key=\(dgc_key)--type=\(dgc_cacheType)")
            }
        }
        dgc_key = dgc_key.Md5
        dgc_cacheKey = dgc_key
//        DGCLog.log("生成缓存key---dgc_cmd=\(dgc_cmd.rawValue)--dgc_key=\(dgc_key)--type=\(dgc_cacheType)")
        return dgc_key
    }
}



import CommonCrypto


private extension String {
    /// 原生md5
    var Md5: String {
        guard let data = data(using: .utf8) else {
            return self
        }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

        #if swift(>=5.0)

        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }

        #else

        _ = data.withUnsafeBytes { bytes in
            return CC_MD5(bytes, CC_LONG(data.count), &digest)
        }

        #endif

        return digest.map { String(format: "%02x", $0) }.joined()

    }
}
