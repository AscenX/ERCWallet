//
//  WalletVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/3.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WalletVC: BaseViewController {
    
    @IBOutlet weak var networkBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var accountView: WalletAccountView = {
        let view = WalletAccountView.nibView(WalletAccountView.name) as! WalletAccountView
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 258)
        return view
    }()
    
    
    
    private var vm: WalletVM!
    
    override init() {
        super.init()
        
        vm = WalletVM()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupData() {
        accountView.bindViewModel(vm, 0)
    }
    
    override func setupView() {
        
        // no wallet
        if !WalletManager.hasWallet {
            let importWalletVc = NewWalletVC(true)
            navigationController?.pushViewController(importWalletVc, animated: false)
        }
        
        // verify password
        if WalletManager.hasWallet && PasswordManager.shared.password.isEmpty {
            let passwordVc = PasswordVC(.verify, true) { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            navigationController?.pushViewController(passwordVc, animated: false)
        }
        
        navigationItem.title = ""
        
        tableView.tableHeaderView = accountView
        
        
        networkBtn.semanticContentAttribute = .forceRightToLeft
        
    }
    
    override func setupAction() {
        
        // network bind
        vm.networkNameOb
            .bind(to: networkBtn.rx.title(for: .normal))
            .disposed(by: rx.disposeBag)
        
        accountView.sendEvent
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = SendTokenVC()
                navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: rx.disposeBag)
        
        accountView.receiveEvent
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = ReceiveVC()
                navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: rx.disposeBag)
        
        accountView.switchAccountEvent
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = SwitchAccountVC()
                navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: rx.disposeBag)
        
        networkBtn.click { [weak self] in
            guard let self = self else { return }
            let vc = SelectNetworkVC()
            present(vc, animated: true)
        }.disposed(by: rx.disposeBag)
    }
    
    
}
