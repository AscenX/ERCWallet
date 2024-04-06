//
//  CreateWalletVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/3.
//

import UIKit

class CreateWalletVC: BaseViewController {
    
    @IBOutlet weak var backUpBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var walletNameTF: UITextField!
    
    private var mnemonic = ""
    
    // MARK: - Life Cycle

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Set up
    
    override func setupData() {
        Task {
            await createWallet()
        }
    }
    
    override func setupView() {
        continueBtn.isEnabled = false
        backUpBtn.isEnabled = false
        
        walletNameTF.text = "Wallet \(WalletManager.shared.allMyWallet.value.count + 1)"
    }
    
    
    override func setupAction() {
        
        backUpBtn.click { [unowned self] in
            let backupVc = BackUpVC(mnemonic)
            self.navigationController?.pushViewController(backupVc, animated: true)
        }.disposed(by: rx.disposeBag)
        
        continueBtn.click { [weak self] in
            guard let self = self else { return }
            if walletNameTF.text?.count ?? 0 > 0 {
                WalletManager.shared.updateWalletName(walletNameTF.text!, WalletManager.shared.currentIndex.value)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }.disposed(by: rx.disposeBag)
    }
    
    // MARK: - Logic
    
    private func createWallet() async {
        mnemonic = await WalletManager.shared.createWallet(PasswordManager.shared.password)
        if mnemonic.count == 0 {
            HUD.showError("Create failed!")
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        continueBtn.isEnabled = true
        backUpBtn.isEnabled = true
    }

}
