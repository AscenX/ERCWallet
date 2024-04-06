//
//  AppConfig.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/3.
//

import UIKit
import IQKeyboardManagerSwift
import MMKV


class AppConfig: NSObject {
    
    static let shared = AppConfig()
    
    override init() {
        super.init()
        
        
    }
    
    
    
    
    func fetchAppConfigInfo() {
        
        
    }
    
    
    /// App 初始化的时候调用
    class func setupInitConfig() {
        configCache()
        configLanguage()
        
    }
    
    /// 可以延迟到App已经加载再调用
    class func setupConfigAfterAppLoad() {
        configHUD()
        configKeyboardManager()
    }

    private class func configLanguage() {
        
    }
    
    private class func configCache() {
        MMKV.initialize(rootDir: nil)
    }
    
    private class func configPhotoBrowser() {
        
    }
    
    private class func configKeyboardManager() {
        DispatchQueue.main.async {
            IQKeyboardManager.shared.enable = true
            IQKeyboardManager.shared.enableAutoToolbar = false
            IQKeyboardManager.shared.resignOnTouchOutside = true
            IQKeyboardManager.shared.keyboardDistanceFromTextField = 64.0
        }
    }
    
    private class func configHUD() {
        HUD.setup()
    }
    
}

