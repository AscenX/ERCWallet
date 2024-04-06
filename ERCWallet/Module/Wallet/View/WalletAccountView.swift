//
//  WalletAccountView.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/6.
//

import UIKit
import RxCocoa
import RxSwift

class WalletAccountView: BaseView, ViewProtocol {

    @IBOutlet private weak var accountLbl: UILabel!
    @IBOutlet private weak var addressLbl: UILabel!
    @IBOutlet private weak var balanceLbl: UILabel!
    @IBOutlet private weak var switchAccountBtn: UIButton!
    @IBOutlet private weak var sendBtn: UIButton!
    @IBOutlet private weak var receiveBtn: UIButton!
    
    private(set) var sendEvent: ControlEvent<()>!
    private(set) var receiveEvent: ControlEvent<()>!
    private(set) var switchAccountEvent: ControlEvent<()>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sendBtn.setTitle("", for: .normal)
        receiveBtn.setTitle("", for: .normal)
    }
    
    func bindViewModel<T>(_ viewModel: T, _ tag: Int?) where T : BaseViewModel {
        
        if let vm = viewModel as? WalletVM {
            vm.accountOb
                .observe(on: MainScheduler.instance)
                .bind(to: accountLbl.rx.text)
                .disposed(by: rx.disposeBag)
            
            vm.addressOb
                .observe(on: MainScheduler.instance)
                .bind(to: addressLbl.rx.text)
                .disposed(by: rx.disposeBag)
            
            vm.balanceOb
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] balance in
                    guard let self = self else { return }
                    balanceLbl.text = balance
                })
                .disposed(by: rx.disposeBag)
            
            sendEvent = sendBtn.rx.controlEvent(.touchUpInside)
            receiveEvent = receiveBtn.rx.controlEvent(.touchUpInside)
            switchAccountEvent = switchAccountBtn.rx.controlEvent(.touchUpInside)
        }
        
    }
}
