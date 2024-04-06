//
//  BaseViewModel.swift
//  ERCWallet
//
//  Created by Ascen Zhong on 2020/7/27.
//  Copyright © 2020 Ascen. All rights reserved.
//

import UIKit

class BaseViewModel: NSObject {
    
    var page: Int = 1
    var dataSourceCount: Int = 0
    
    override init() {
        super.init()
        
        setup()
    }
    
    func setup() {
    }

    deinit {
        debugPrint(self, #function)
    }
}
