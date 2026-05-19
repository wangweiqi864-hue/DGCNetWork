//
//  DGCNetWorkManager+Login.swift
//  Pods
//
//  Created by mango on 2024/2/21.
//

import Foundation
import Alamofire

/// 登录
extension DGCNetWorkManager{
    
    /// id账号登录
    public static func nw_IDLogin(id : String,pwd : String,success : DGCNetWorkSuccess<DGCLogin_CommonSignInRes>? = nil,fail : DGCNetWorkFail? = nil) {
        var dgc_body = DGCLogin_IdOrPhoneLoginReq()
        dgc_body.password = pwd
        dgc_body.value = id
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_CommonSignInRes>(
            cmd: .loginID,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_AppleIDLogin(fullname: String, identityToken: String, authorizationCode: String, success : DGCNetWorkSuccess<DGCLogin_CommonSignInRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLogin_SignInWithAppleReq()
        dgc_body.fullName = fullname
        dgc_body.identityToken = identityToken
        dgc_body.authorizationCode = authorizationCode
        dgc_body.deviceID = UIDevice.getUUID()
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_CommonSignInRes>(
            cmd: .LoginAppleID,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_getSMS(country: Int32, phoneNo: String, success: DGCNetWorkSuccess<DGCLogin_GetSmsCodeRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLogin_GetSmsCodeReq()
        dgc_body.country = country
        dgc_body.phone = phoneNo
        dgc_body.isBind = false
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_GetSmsCodeRes>(
            cmd: .LoginGetPhoneSMS,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_getSMS4Bind(country: Int32, phoneNo: String, isChange: Bool = false, success: DGCNetWorkSuccess<DGCLogin_GetSmsCodeRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLogin_GetSmsCodeReq()
        dgc_body.country = country
        dgc_body.phone = phoneNo
        dgc_body.action = isChange ? .changePhone : .bindPhone
        dgc_body.isBind = false
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_GetSmsCodeRes>(
            cmd: .LoginGetPhoneSMS,
            dgc_body: dgc_body,
            autoShowErrTip:false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_getSMS4CoinPwd(success: DGCNetWorkSuccess<DGCLogin_GetSmsCodeRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLogin_GetSmsCodeReq()
        dgc_body.action = .etExchangePw
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_GetSmsCodeRes>(
            cmd: .LoginGetPhoneSMS,
            dgc_body: dgc_body,
            autoShowErrTip:false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_thirdLogin(dgc_req: DGCLogin_ThirdLoginReq, success: DGCNetWorkSuccess<DGCLogin_ThirdLoginRes>? = nil,fail: DGCNetWorkFail? = nil) {
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_ThirdLoginRes>(
            cmd: .LoginThirdParty,
            body: dgc_req,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_checkAccountSafety(success: DGCNetWorkSuccess<DGCLogin_CheckAccountSecurityResp>? = nil,fail: DGCNetWorkFail? = nil) {
        
        let dgc_body = DGCLogin_CheckAccountSecurityReq()
        let dgc_req = DGCNetWorkRequest<DGCLogin_CheckAccountSecurityResp>(
            cmd: .usrAccountSafetyReq,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_verifyExchangePassword(password:String,success: DGCNetWorkSuccess<DGCLogin_VerifyExchangePasswordResp>? = nil,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLogin_VerifyExchangePasswordReq()
        dgc_body.password = password
        let dgc_req = DGCNetWorkRequest<DGCLogin_VerifyExchangePasswordResp>(
            cmd: .verifyExchangePasswordReq,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_verifySmsCodeReq(code:String,action:DGCLogin_SmsAction, success: DGCNetWorkSuccess<DGCLogin_VerifySmsCodeResp>? = nil,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLogin_VerifySmsCodeReq()
        dgc_body.code = code
        dgc_body.action = action
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_VerifySmsCodeResp>(
            cmd: .verifySmsCodeReq,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_setExchangePasswordReq(firstInput:String,secondInput:String,isForget:Bool = false, success: DGCNetWorkSuccess<DGCLogin_SetExchangePasswordResp>? = nil,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLogin_SetExchangePasswordReq()
        dgc_body.firstInput = firstInput
        dgc_body.secondInput = secondInput
        dgc_body.forget = isForget
        let dgc_req = DGCNetWorkRequest<DGCLogin_SetExchangePasswordResp>(
            cmd: .setExchangePasswordReq,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    
    
    public static func nw_bindPhone(country:Int32, phone:String,code:String,success: DGCNetWorkSuccess<DGCLogin_UpdateBindPhoneResp>? = nil,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLogin_UpdateBindPhoneReq()
        dgc_body.phone = phone
        dgc_body.code = code
        dgc_body.country = country
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_UpdateBindPhoneResp>(
            cmd: .usrAccountBindPhoneReq,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )

        DGCNetWorkManager.share.send(dgc_req)
    }
    
    //country: 国家区号
    public static func nw_loginWithPhoneSms(country: Int32, phoneNo: String, smsToken: String, channel:Int32, success: DGCNetWorkSuccess<DGCLogin_CommonSignInRes>? = nil,fail: DGCNetWorkFail? = nil) {
        var dgc_body = DGCLogin_LoginWithPhoneSMSReq()
        dgc_body.deviceID = UIDevice.getUUID()
        dgc_body.country = country
        dgc_body.phone = phoneNo
        dgc_body.smsCode = smsToken
        dgc_body.deviceType = .dtIosPhone
        dgc_body.channel = channel
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_CommonSignInRes>(
            cmd: .LoginPhoneSMS,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
        
    //修改密码
    public static func nw_updatePasswdReq(identityToken: String, oldPasswd: String, newPasswd: String, isNew: Bool, success: DGCNetWorkSuccess<DGCMine_UpdatePasswdRes>? = nil,fail: DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCMine_UpdatePasswdReq()
        dgc_body.sign = identityToken
        dgc_body.oldPasswd = Data(oldPasswd.utf8).base64EncodedString()
        dgc_body.newPasswd = Data(newPasswd.utf8).base64EncodedString()
        dgc_body.isNew = isNew
        
        let dgc_req = DGCNetWorkRequest<DGCMine_UpdatePasswdRes>(
            cmd: .loginUpdatePasswd,
            channel: .long,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    public static func nw_logout(authToken : String,success : DGCNetWorkSuccess<DGCLogin_LogoutRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        var dgc_body = DGCLogin_LogoutReq()
        dgc_body.key = authToken
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_LogoutRes>(
            cmd: .LoginLogout,
            channel: .long,
            op: .SendSms,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    // 注销账号
    public static func nw_deleteAccount(success : DGCNetWorkSuccess<DGCLogin_DeleteAccountConfirmRes>? = nil,fail : DGCNetWorkFail? = nil) {
        let dgc_body = DGCLogin_DeleteAccountConfirmReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_DeleteAccountConfirmRes>(
            cmd: .LoginLogout,
            channel: .long,
            op: .SendSms,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    //
    public static func nw_GetUserZoneReq(success : DGCNetWorkSuccess<DGCLogin_GetUserZoneRes>? = nil,fail : DGCNetWorkFail? = nil) {
        let dgc_body = DGCLogin_GetUserZoneReq()
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_GetUserZoneRes>(
            cmd: .loginUserZoneReq,
            channel: .short,
            cacheType: .cacheFromReq,
            op: .Auth,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
    /// 长连接授权
    /// isNeedResetLongSocket 是否要重置长链接 一般在重新登录时需要
    public static func nw_loginLongAuth(authToken : String,isNeedResetLongSocket : Bool = false,success : DGCNetWorkSuccess<DGCLogin_LoginRes>? = nil,fail : DGCNetWorkFail? = nil) {
        
        if isNeedResetLongSocket { //
            DGCNetWorkManager.share.disConnect()
        }
        
        var dgc_body = DGCLogin_LoginReq ()
        dgc_body.deviceType = .dtIosPhone
        dgc_body.deviceID = UIDevice.getUUID()
        dgc_body.key = authToken
        
        let dgc_req = DGCNetWorkRequest<DGCLogin_LoginRes>(
            cmd: .LongLogin,
            channel: .long,
            op: .Auth,
            dgc_body: dgc_body,
            autoShowErrTip: false,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
    }
    
}
