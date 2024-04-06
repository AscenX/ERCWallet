//
//  TabBarController.swift
//  ERCWallet
//
//  Created by Ascen Zhong on 2020/8/7.
//  Copyright © 2020 Ascen. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let walletVc = WalletVC()
        addChildVc(walletVc, "Wallet", "ic_tabbar_wallet")
        
        let browserVc = BrowserVC()
        addChildVc(browserVc, "Browser", "ic_tabbar_browser")
        
        
        
        tabBar.barTintColor = UIColor.white
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.tintColor = .primary
        
        AppConfig.setupConfigAfterAppLoad()
    }
    
    func addChildVc(_ vc: UIViewController, _ title: String, _ imgName: String) {

        vc.title = title
        
        vc.tabBarItem.image = UIImage(named: imgName)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: imgName)?.withTintColor(.primary, renderingMode: .alwaysOriginal)
        
        let nav = BaseNavigationViewController(rootViewController: vc)
        addChild(nav)
    }
}

