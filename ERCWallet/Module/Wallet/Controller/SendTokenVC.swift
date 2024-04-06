//
//  SendTokenVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/5.
//

import UIKit
import RxSwift
import RxCocoa

class SendTokenVC: BaseViewController {
    
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var inputContainerView: UIView!
    
    @IBOutlet weak var pasteBtn: UIButton!
    
    @IBOutlet weak var amountTF: UITextField!
    
    @IBOutlet weak var amountContainerView: UIView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var btnBottom: NSLayoutConstraint!
    
    @IBOutlet weak var balanceLbl: UILabel!
    
    private var vm: SendTokenVM!
    
    override init() {
        super.init()
        
        vm = SendTokenVM()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    override func setupView() {
        title = "Send"
        
        pasteBtn.setTitle("", for: .normal)
        
        setupContainerView(inputContainerView)
        setupContainerView(amountContainerView)
        
        sendBtn.setTitleColor(.white, for: .disabled)
    }
    
    override func setupAction() {
        
        // amount input
        Observable.merge([
            amountTF.rx.text.asObservable(),
            amountTF.rx.observe(String.self, "text")
        ])
        .map{ $0 ?? "" }
        .bind(to: vm.amountRelay)
        .disposed(by: rx.disposeBag)
        
        // address input
        Observable.merge([
            addressTF.rx.text.asObservable(),
            addressTF.rx.observe(String.self, "text")
        ])
        .map{ $0 ?? "" }
        .bind(to: vm.toAddressRelay)
        .disposed(by: rx.disposeBag)
        
        
        // paste action
        pasteBtn.click { [weak self] in
            guard let self = self else { return }
            if let pasteStr = UIPasteboard.general.string {
                addressTF.text = pasteStr
            }
        }.disposed(by: rx.disposeBag)
        
        // send action
        sendBtn.click { [weak self] in
            guard let self = self else { return }
            HUD.show()
            vm.sendAction.execute()
        }.disposed(by: rx.disposeBag)
        
        // is sending
        //        vm.sendAction.executing.asDriver(onErrorJustReturn: false).drive(onNext: { [weak self] isSending in
        //            guard let self = self else { return }
        //            if isSending {
        //                HUD.show()
        //            } else {
        //                HUD.dismiss()
        //            }
        //        }).disposed(by: rx.disposeBag)
        
        vm.sendAction.elements.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                HUD.showSuccess("Send Success")
                vm.amountRelay.accept("")
                vm.toAddressRelay.accept("")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                HUD.showError("Send failed, Please try again")
            }
        }, onError: { _ in
            HUD.showError("Send failed, Please try again")
        }).disposed(by: rx.disposeBag)
        
        // btn enable
        vm.enableOb
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                sendBtn.backgroundColor = isEnabled ? .primary : .primary.withAlphaComponent(0.5)
                sendBtn.isEnabled = isEnabled
            })
            .disposed(by: rx.disposeBag)
        
        // balance
        vm.balanceOb
            .asDriver(onErrorJustReturn: "0")
            .drive(onNext: { [weak self] balance in
                guard let self = self else { return }
                let network = NetworkManager.shared.getCurrentNetwork()
                balanceLbl.text = "Balance: \(balance) \(network.symbol)"
            })
            .disposed(by: rx.disposeBag)
        
        // keyboard manage
        KeyboardManager.shared.keyboardOb.asDriver(onErrorJustReturn: (0.0, 0.0))
            .drive { [weak self] (height, duration) in
                guard let self = self else { return }
                UIView.animate(withDuration: duration) {
                    self.btnBottom.constant = height
                    self.view.layoutIfNeeded()
                }
            }.disposed(by: rx.disposeBag)
    }
    
    // MARK: - Logic
    
    private func setupContainerView(_ containerView: UIView) {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.primary.cgColor
    }
}
