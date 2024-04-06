//
//  BaseView.swift
//  ERCWallet
//
//  Created by Ascen Zhong on 2020/7/27.
//  Copyright © 2020 Ascen. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        self.endEditing(true)
        return super.hitTest(point, with: event)
    }
    
    deinit {
        debugPrint(self, #function)
    }

}
