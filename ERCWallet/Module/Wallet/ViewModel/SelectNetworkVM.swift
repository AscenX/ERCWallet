//
//  SelectNetworkVM.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/6.
//

import UIKit

class SelectNetworkVM: BaseViewModel, ViewModelCellType {

    func cellViewModel(_ ip: IndexPath, _ tag: Int?) -> BaseCellViewModel {
        let networkList = NetworkManager.shared.networkList.value
        return SelectNetworkCellVM(networkList[ip.row], NetworkManager.shared.currentIndex.value == ip.row)
    }
}
