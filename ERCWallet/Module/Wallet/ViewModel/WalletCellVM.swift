//
//  WalletCellVM.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/5.
//

import UIKit

/// Switch account cell view model
class WalletCellVM: BaseCellViewModel {

    
    private(set) var name = ""
    private(set) var isSelected = false
    
    override init() {
        super.init()
    }
    
    convenience init(_ wallet: MyWallet, _ isSelected: Bool) {
        self.init()
        
        self.name = wallet.name
        self.isSelected = isSelected
    }
}
