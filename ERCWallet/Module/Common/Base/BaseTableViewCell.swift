//
//  BaseTableViewCell.swift
//  ERCWallet
//
//  Created by ascen on 2019/4/16.
//  Copyright © 2019 Ascen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var reuseDisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reuseDisposeBag = DisposeBag()
    }
    
    func data<T: BaseViewModel>(_ ip: IndexPath, viewModel: T? = nil, tag: Int? = nil) {}

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        let color = self.backgroundColor
////        let selectedColor = UIColor.background
//
//        self.selectedBackgroundView?.backgroundColor = selected ? selectedColor : color
//        self.backgroundColor = selected ? selectedColor : color
//        self.backgroundView?.backgroundColor = selected ? selectedColor : color
//        self.contentView.backgroundColor = selected ? selectedColor : color
//        self.selectedBackgroundView?.setValue(selected ? selectedColor : color, forKey: "selectionTintColor")
//    }
//
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
//
//        let color = self.backgroundColor
//
//        let highlightedColor = color
//        self.selectedBackgroundView?.backgroundColor = highlighted ? highlightedColor : color
//        self.backgroundColor = highlighted ? highlightedColor : color
//        self.backgroundView?.backgroundColor = highlighted ? highlightedColor : color
//        self.contentView.backgroundColor = highlighted ? highlightedColor : color
//        self.selectedBackgroundView?.setValue(highlighted ? highlightedColor : color, forKey: "selectionTintColor")
//    }

}
