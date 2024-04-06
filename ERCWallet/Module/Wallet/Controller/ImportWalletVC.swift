//
//  ImportWalletVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/4.
//

import UIKit
import RxSwift
import RxCocoa

class ImportWalletVC: BaseViewController {

    @IBOutlet weak var inputContainerView: UIView!
    
    @IBOutlet weak var pasteBtn: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var restoreBtn: UIButton!
    
    @IBOutlet weak var invalidTipsLbl: UILabel!
    
    @IBOutlet weak var btnBottom: NSLayoutConstraint!
    
    private var vm: ImportVM!
    
    override init() {
        super.init()
        
        vm = ImportVM()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupView() {
        
        inputContainerView.layer.masksToBounds = true
        inputContainerView.layer.cornerRadius = 8.0
        inputContainerView.layer.borderWidth = 1.0
        inputContainerView.layer.borderColor = UIColor.primary.cgColor
        
        restoreBtn.setTitleColor(.white, for: .disabled)
        restoreBtn.backgroundColor = .primary.withAlphaComponent(0.5)
        
        textView.becomeFirstResponder()
    }
    
    override func setupAction() {
        
        // bind input content
        Observable.merge([
            textView.rx.text.asObservable(),
            textView.rx.observe(String.self, "text")
        ])
        .map{ $0 ?? "" }
        .distinctUntilChanged()
        .bind(to: vm.mnemonicRelay)
        .disposed(by: rx.disposeBag)
        
        // paste action
        pasteBtn.click { [weak self] in
            guard let self = self else { return }
            if let pasteStr = UIPasteboard.general.string {
                textView.text = pasteStr
            }
        }.disposed(by: rx.disposeBag)
        
        // valid
        vm.isValidOb
            .distinctUntilChanged()
            .bind(to: invalidTipsLbl.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        // can restore
        Observable.merge([
            vm.isValidOb,
            vm.mnemonicRelay.map({ mnemonic in
                let count = mnemonic.split(separator: " ").count
                return count == 12 || count == 18 || count == 24
            })
        ])
        .distinctUntilChanged()
        .do(onNext: { [weak self] isValid in
            guard let self = self else { return }
            restoreBtn.backgroundColor = isValid ? .primary : .primary.withAlphaComponent(0.5)
        })
        .bind(to: restoreBtn.rx.isEnabled)
        .disposed(by: rx.disposeBag)
            
        
        // restore
        restoreBtn.click { [weak self] in
            guard let self = self else { return }
            HUD.show()
            vm.restoreAction.execute()
        }.disposed(by: rx.disposeBag)
        
        // restore finished
        vm.restoreAction.elements.subscribe(onNext: { [weak self] isSuccess in
            guard let self = self else { return }
            HUD.dismiss()
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                HUD.showError("Invalid mnemonic, Please check!")
            }
        }).disposed(by: rx.disposeBag)
        
        // keyboard height
        KeyboardManager.shared.keyboardOb.asDriver(onErrorJustReturn: (0.0, 0.0))
            .drive { [weak self] (height, duration) in
                guard let self = self else { return }
                UIView.animate(withDuration: duration) {
                    self.btnBottom.constant = height
                    self.view.layoutIfNeeded()
                }
            }.disposed(by: rx.disposeBag)
    }

}
