//
//  DGCViewController.swift
//  DGCNetWork
//
//  Created by admin on 02/21/2024.
//  Copyright (c) 2024 admin. All rights reserved.
//

import UIKit
import DGCLog
import DGCNetWork

class DGCViewController: UIViewController {

    @IBOutlet weak var tip: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DGCLog.log("1111")
        let dgc_config = DGCNetWorkConfig(
            shortHost: "http://whalesing.imai.site",
            longHost: "whalesing.imai.site",
            longPorts: ["8888"],
            longBackupIps: []
        )
        DGCNetWorkManager.initConfig(dgc_config: dgc_config,delegate: self)
//        DGCNetWorkManager.share.longReConnect()
        
    }
    
    @IBAction func btnClick(_ sender: Any) {
//        DGCNetWorkManager.nw_loginLongAuth(authToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MDgyMzc5ODksImlzcyI6IndoYWxlc2luZyIsInVpZCI6MTAwMDM1MzcsIm9iZiI6IjVkNmJmZjU5YzM0ZDQ0NTUifQ.zTPUXJMsKJVZXVHJ4KunfcYEY91AH2vEatYGuJqj7B4")
        DGCNetWorkManager.nw_IDLogin(id: "1234", pwd: "111111") { res in
            DGCNetWorkManager.nw_loginLongAuth(authToken: res.loginToken)
        } fail: { error in
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension DGCViewController : DGCNetWorkManagerDelegate{
    
    func netWorkManagerWithGetToken() -> String {
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MDgyMzc5ODksImlzcyI6IndoYWxlc2luZyIsInVpZCI6MTAwMDM1MzcsIm9iZiI6IjVkNmJmZjU5YzM0ZDQ0NTUifQ.zTPUXJMsKJVZXVHJ4KunfcYEY91AH2vEatYGuJqj7B4"
    }
    
}
