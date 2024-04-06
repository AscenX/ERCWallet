//
//  BaseCollectionViewCell.swift
//  ERCWallet
//
//  Created by Ascen Zhong on 2020/8/19.
//  Copyright © 2020 Ascen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseCollectionViewCell: UICollectionViewCell {
    
    var reuseDisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reuseDisposeBag = DisposeBag()
    }
    
    func data(_ ip: IndexPath, viewModel: Any? = nil, tag: Int? = nil) {}
    
}
