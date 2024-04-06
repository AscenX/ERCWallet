//
//  ViewProtocol.swift
//  ERCWallet
//
//  Created by Ascen on 2019/11/12.
//  Copyright © 2019 Ascen. All rights reserved.
//

import UIKit

protocol ViewProtocol {
    /// bind view model data
    func bindViewModel<T: BaseViewModel>(_ viewModel: T, _ tag: Int?)
}

extension ViewProtocol {
    /// bind view model data
    func bindViewModel<T: BaseViewModel>(_ viewModel: T, _ tag: Int?) {}
}

protocol CellProtocol {
    /// bind cell view model data
    func bindViewModel<T>(_ viewModel: T, _ ip: IndexPath, _ tag: Int?) where T:ViewModelCellType
}

extension CellProtocol {
    /// bind cell view mode data
    func bindViewModel<T>(_ viewModel: T, _ ip: IndexPath, _ tag: Int?) where T:ViewModelCellType {}
}

protocol ViewModelCellType {
    
    func cellViewModel(_ ip: IndexPath, _ tag: Int?) -> BaseCellViewModel
}

extension ViewModelCellType {
    func cellViewModel(_ ip: IndexPath, _ tag: Int?) -> BaseCellViewModel {
        return BaseCellViewModel()
    }
}
