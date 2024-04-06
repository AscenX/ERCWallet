//
//  UIScreenExtensions.swift
//  Ascen
//
//  Created by Ascen Zhong on 2020/8/22.
//  Copyright © 2020 Ascen. All rights reserved.
//

import UIKit

let isPhoneX: Bool = UIScreen.main.bounds.height / UIScreen.main.bounds.width >= 2.16
let isPhone6: Bool = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 667.0
let isPhone5: Bool = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 568.0
let isPhonePlus: Bool = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 736.0

extension UIScreen {
    
    
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var topSafeAreaHeight: CGFloat {
        return isPhoneX ? 24.0 : 0.0
    }
    
    static var statusBarHeight: CGFloat {
        return UIScreen.topSafeAreaHeight + 20.0
    }
    
    static var navgationBarHeight: CGFloat {
        return UIScreen.statusBarHeight + 44.0
    }
    
    static var bottomSafeAreaHeight: CGFloat {
        return isPhoneX ? 34.0 : 0.0
    }
    
    static var tabBarHeight: CGFloat {
        return 49 + UIScreen.bottomSafeAreaHeight
    }
    
}
