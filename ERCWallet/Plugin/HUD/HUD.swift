//
//  HUD.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/3.
//  Copyright © 2024 Ascen. All rights reserved.
//

import UIKit
import ProgressHUD

class HUD {
    
    class func setup() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .white
        ProgressHUD.colorProgress = .white
        ProgressHUD.colorBackground = .black
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorStatus = .white
    }
    
    class func show(_ info: String? = nil) {
        ProgressHUD.animate(info)
    }
    
    
    class func showError(_ errMsg: String) {
        ProgressHUD.failed(errMsg)
    }
    
    class func showSuccess(_ info: String) {
        ProgressHUD.succeed(info)
    }
    
    class func dismiss() {
        ProgressHUD.dismiss()
    }

}
