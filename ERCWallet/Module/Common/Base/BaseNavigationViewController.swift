//
//  BaseNavigationViewController.swift
//  ERCWallet
//
//  Created by Ascen Zhong on 2020/8/7.
//  Copyright © 2020 Ascen. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = UIColor.clear
          
//        let lineImageView = self.findHairlineImageViewUnder(view: self.navigationBar)
//        lineImageView?.isHidden = true
        
        
        view.backgroundColor = UIColor.white    
        
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            // hide tabBar
            viewController.hidesBottomBarWhenPushed = true
            
            let backBtn = UIButton(type: .custom)
            backBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            backBtn.setImage(R.image.ic_back(), for: .normal)
            backBtn.addTarget(self, action: #selector(popOrDismiss), for: .touchUpInside)
            backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:-19, bottom: 0, right: 0)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            
            interactivePopGestureRecognizer?.isEnabled = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func popOrDismiss() {
        if self.viewControllers.count > 0 {
            self.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func findHairlineImageViewUnder(view: UIView) -> UIImageView? {
        
        if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0{
            return view as? UIImageView
        }
        
        for subView in view.subviews{
            if let imageView = self.findHairlineImageViewUnder(view: subView) {
                return imageView
            }
        }
        return nil
    }

}
