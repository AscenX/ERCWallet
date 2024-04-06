//
//  BaseViewController.swift
//  ERCWallet
//
//  Created by Ascen Zhong on 2020/7/27.
//  Copyright © 2020 Ascen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
//import SwifterSwift
import SnapKit
//import FDFullscreenPopGesture
//import FLEX

class BaseViewController : UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
//        fd_interactivePopDisabled = false
        
        setupData()
        setupView()
        setupAction()
        
//        #if DEBUG
//        FLEXManager.shared.isNetworkDebuggingEnabled = true
//        FLEXManager.shared.networkRequestHostBlacklist = ["jpush.cn", "umeng.com"]
//        UIApplication.shared.applicationSupportsShakeToEdit = true
//        self.becomeFirstResponder()
//        #endif
    }
    
//    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//
//
//        #if DEBUG
//        if event?.subtype == UIEvent.EventSubtype.motionShake {
//            FLEXManager.shared.toggleExplorer()
//        }
//
//        #endif
//    }

    /// set up data relative logic
    func setupData() {}
    /// set up view / layout
    func setupView() {}
    /// set up interact & data bind
    func setupAction() {}

    
    deinit {
        debugPrint(self, #function)
    }
}

