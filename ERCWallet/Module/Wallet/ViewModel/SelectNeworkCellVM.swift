//
//  SelectNeworkCellVM.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/6.
//

import UIKit

class SelectNetworkCellVM: BaseCellViewModel {

    private(set) var name = ""
    private(set) var isSelected = false
    
    override init() {
        super.init()
    }
    
    convenience init(_ network: ChainNetwork, _ isSelected: Bool) {
        self.init()
        
        self.name = network.name 
        self.isSelected = isSelected
    }
}

