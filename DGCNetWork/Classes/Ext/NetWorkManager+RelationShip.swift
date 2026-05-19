//
//  DGCNetWorkManager+RelationShip.swift
//  DGCNetWork
//
//  Created by apple on 2026/1/16.
//

import Foundation

//cp or friend
extension DGCNetWorkManager {
    //搜索用户
   public static func nw_searchPlayer(searchId: Int64,
                                       success: @escaping DGCNetWorkSuccess<DGCMine_UserShortIdInfoRes>,
                                       fail: @escaping DGCNetWorkFail
   ) {
       var dgc_body = DGCMine_UserShortIdInfoReq()
       dgc_body.id = searchId
       
       let dgc_req = DGCNetWorkRequest<DGCMine_UserShortIdInfoRes>(
           cmd: .RelationSearchPlayerInvite,
           channel: .long,
           cacheType: .no,
           dgc_body: dgc_body,
           success: success,
           fail: fail
       )
       DGCNetWorkManager.share.send(dgc_req)
   }
   
   //邀请
   public static func nw_inviteRelationReq(playerID:Int64,type:DGCMine_RelationshipType,
                                      success: @escaping DGCNetWorkSuccess<DGCMine_InviteRes>,
                                      fail: @escaping DGCNetWorkFail
  ) {
      var dgc_body = DGCMine_InviteReq()
      dgc_body.playerID = playerID
      dgc_body.type = type
      let dgc_req = DGCNetWorkRequest<DGCMine_InviteRes>(
          cmd: .RelationInvite,
          channel: .long,
          cacheType: .no,
          dgc_body: dgc_body,
          success: success,
          fail: fail
      )
      DGCNetWorkManager.share.send(dgc_req)
  }
   
   //处理邀请
   // 1-接受，2-拒绝
   public static func nw_handleInviteRelationReq(invite_id:Int64,operateType:Int32,
                                      success: @escaping DGCNetWorkSuccess<DGCMine_HandleInviteRes>,
                                      fail: @escaping DGCNetWorkFail
  ) {
      var dgc_body = DGCMine_HandleInviteReq()
       dgc_body.inviteID = invite_id
       dgc_body.operate = operateType
      let dgc_req = DGCNetWorkRequest<DGCMine_HandleInviteRes>(
          cmd: .RelationHandleInvite,
          channel: .long,
          cacheType: .no,
          dgc_body: dgc_body,
          success: success,
          fail: fail
      )
      DGCNetWorkManager.share.send(dgc_req)
  }

   //查询关系list
   public static func nw_queryRelationshipReq(player_id:Int64,
                                      success: @escaping DGCNetWorkSuccess<DGCMine_QueryRelationshipListRes>,
                                      fail: @escaping DGCNetWorkFail
   ) {
      var dgc_body = DGCMine_QueryRelationshipListReq()
       dgc_body.playerID = player_id
      let dgc_req = DGCNetWorkRequest<DGCMine_QueryRelationshipListRes>(
          cmd: .RelationQueryRelationshipList,
          channel: .long,
          cacheType: .no,
          dgc_body: dgc_body,
          success: success,
          fail: fail
      )
      DGCNetWorkManager.share.send(dgc_req)
  }
   
   //operate // 1-解绑，2-取消解绑
   public static func nw_operateRelationshipReq(relationship_id:Int64,operateType:Int32,
                                      success: @escaping DGCNetWorkSuccess<DGCMine_OperateRelationshipRes>,
                                      fail: @escaping DGCNetWorkFail
   ) {
      var dgc_body = DGCMine_OperateRelationshipReq()
       dgc_body.relationshipID = relationship_id
       dgc_body.operate = operateType
      let dgc_req = DGCNetWorkRequest<DGCMine_OperateRelationshipRes>(
          cmd: .RelationOperateRelationship,
          channel: .long,
          cacheType: .no,
          dgc_body: dgc_body,
          success: success,
          fail: fail
      )
      DGCNetWorkManager.share.send(dgc_req)
  }
   
   //签名
   public static func nw_modifySignatureReq(relationship_id:Int64,signature:String,
                                      success: @escaping DGCNetWorkSuccess<DGCMine_ModifySignatureRes>,
                                      fail: @escaping DGCNetWorkFail
   ) {
       var dgc_body = DGCMine_ModifySignatureReq()
       dgc_body.relationshipID = relationship_id
       dgc_body.signature = signature
       let dgc_req = DGCNetWorkRequest<DGCMine_ModifySignatureRes>(
           cmd: .RelationModifySignature,
           channel: .long,
           cacheType: .no,
           dgc_body: dgc_body,
           success: success,
           fail: fail
       )
       DGCNetWorkManager.share.send(dgc_req)
  }
   
   //隐藏 RelationshipType  // 1-隐藏 2-解除隐藏
   public static func nw_hideRelationshipReq(type:DGCMine_RelationshipType,operate:Int32,
                                      success: @escaping DGCNetWorkSuccess<DGCMine_HideRelationshipRes>,
                                      fail: @escaping DGCNetWorkFail
   ) {
       var dgc_body = DGCMine_HideRelationshipReq()
       dgc_body.type = type
       dgc_body.operate = operate
       let dgc_req = DGCNetWorkRequest<DGCMine_HideRelationshipRes>(
           cmd: .RelationHideRelationship,
           channel: .long,
           cacheType: .no,
           dgc_body: dgc_body,
           success: success,
           fail: fail
       )
       DGCNetWorkManager.share.send(dgc_req)
  }

   //查看邀请信
   public static func nw_queryInvitationLetterReq(invite_id:Int64,
                                      success: @escaping DGCNetWorkSuccess<DGCMine_QueryInvitationLetterRes>,
                                      fail: @escaping DGCNetWorkFail
   ) {
       var dgc_body = DGCMine_QueryInvitationLetterReq()
       dgc_body.inviteID = invite_id
       
       let dgc_req = DGCNetWorkRequest<DGCMine_QueryInvitationLetterRes>(
           cmd: .RelationQueryInvitationLetter,
           channel: .long,
           cacheType: .no,
           dgc_body: dgc_body,
           success: success,
           fail: fail
       )
       DGCNetWorkManager.share.send(dgc_req)
  }
    
    //相关配置信息
    public static func nw_getRelationshipConfigReq(
                                       success: @escaping DGCNetWorkSuccess<DGCMine_GetRelationshipConfigRes>,
                                       fail: @escaping DGCNetWorkFail
    ) {
        let dgc_body = DGCMine_GetRelationshipConfigReq()
        
        let dgc_req = DGCNetWorkRequest<DGCMine_GetRelationshipConfigRes>(
            cmd: .RelationQueryRelationshipConfig,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
   }
    
    //查询cp情侣连续点亮鲜花天数
    public static func nw_queryCpFlowerLightDaysReq(uid1:Int64,uid2:Int64,
                                       success: @escaping DGCNetWorkSuccess<DGCMine_QueryCpFlowerLightDaysRes>,
                                       fail: @escaping DGCNetWorkFail
    ) {
        var dgc_body = DGCMine_QueryCpFlowerLightDaysReq()
        dgc_body.uid1 = uid1
        dgc_body.uid2 = uid2
        let dgc_req = DGCNetWorkRequest<DGCMine_QueryCpFlowerLightDaysRes>(
            cmd: .QueryCpFlowerLightDays,
            channel: .long,
            cacheType: .no,
            dgc_body: dgc_body,
            success: success,
            fail: fail
        )
        DGCNetWorkManager.share.send(dgc_req)
   }
}
