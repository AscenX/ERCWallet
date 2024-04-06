//
//  PasswordTF.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/4.
//

import UIKit

class PasswordTF: UITextField {


    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.hideMenu()
        
        return false
        
    }

}
