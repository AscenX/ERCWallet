//
//  AddWalletView.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/5.
//

import UIKit
import RxSwift
import RxCocoa

class AddWalletView: BaseView {

    @IBOutlet weak var addBtn: UIButton!
    
    private(set) var clickEvent: ControlEvent<()>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clickEvent = addBtn.rx.controlEvent(.touchUpInside)
        
        if #available(iOS 15.0, *) {
            addBtn.configuration?.imagePadding = 10
        } else {
            addBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
    }

}
