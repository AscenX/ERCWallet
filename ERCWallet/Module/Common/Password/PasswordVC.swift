//
//  PasswordVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/4.
//

import UIKit
import IQKeyboardManagerSwift
import RxSwift
import RxCocoa

enum PasswordType {
    case create
    case verify
}

class PasswordVC: BaseViewController {
    
    @IBOutlet weak var incorrectLbl: UILabel!
    
    /// password input text field
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.isHidden = true
        return tf
    }()
    
    /// input password
    private var pwd = ""
    /// create or verify
    private var type = PasswordType.create
    /// hide back button
    private var hideBack = true
    
    private var incorrectRelay = PublishRelay<Bool>()
    
    private var verifySuccess: (() -> Void)? = nil
    
    // MARK: - Life cycle
    
    convenience init(_ type: PasswordType, _ hideBack: Bool, _ verifySuccess: @escaping () -> Void) {
        self.init()
        
        self.hideBack = hideBack
        self.type = type
        self.verifySuccess = verifySuccess
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if hideBack {
            navigationController?.setNavigationBarHidden(hideBack, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
        if hideBack {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        DispatchQueue.main.async {
            IQKeyboardManager.shared.resignOnTouchOutside = true
        }
    }
    
    // MARK: - Set up

    override func setupView() {
        
        view.addSubview(textField)
        textField.becomeFirstResponder()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            for i in 0 ..< 6 {
                if let ovalView = view.viewWithTag(i+1) {
                    ovalView.layer.masksToBounds = true
                    ovalView.layer.cornerRadius = 10.0
                    ovalView.layer.borderWidth = 1.0
                    ovalView.layer.borderColor = UIColor.primary.cgColor
                }
            }
            
            IQKeyboardManager.shared.resignOnTouchOutside = false
        }
    }
    
    override func setupAction() {
        
        
        textField.rx.text.distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                if let pwd = text {
                    setupInputView(pwd.count)
                    incorrectRelay.accept(false)
                    if pwd.count == 6 && verifySuccess != nil {
                        if type == PasswordType.create {
                            PasswordManager.shared.createPassword(pwd)
                            verifySuccess!()
                        } else {
                            let isSuccess = PasswordManager.shared.verifyPassword(pwd)
                            if isSuccess {
                                verifySuccess!()
                            } else {
                                textField.text = ""
                                setupInputView(0)
                                incorrectRelay.accept(true)
                            }
                        }
                    }
                }
            }).disposed(by: rx.disposeBag)
        
        // show incorrect tips
        incorrectRelay
            .map{ !$0 }
            .bind(to: incorrectLbl.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }
    
    
    private func setupInputView(_ count: Int) {
        for i in 0 ..< 6 {
            if let ovalView = view.viewWithTag(i+1) {
                ovalView.backgroundColor = i < count ? .primary : .white
            }
        }
    }
}
