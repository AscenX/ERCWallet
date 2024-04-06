//
//  SwitchAccountVM.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/5.
//

import UIKit

class SwitchAccountVM: BaseViewModel, ViewModelCellType {
    
    func cellViewModel(_ ip: IndexPath, _ tag: Int?) -> BaseCellViewModel {
        let myWallets = WalletManager.shared.allMyWallet.value
        return WalletCellVM(myWallets[ip.row], WalletManager.shared.currentIndex.value == ip.row)
    }
}
