//
//  ImportWalletVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/3.
//

import UIKit

class NewWalletVC: BaseViewController {

    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var importBtn: UIButton!
    
    private var hideBack = true
    
    convenience init(_ hideBack: Bool) {
        
        self.init()
        
        self.hideBack = hideBack
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(!WalletManager.hasWallet || hideBack, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func setupAction() {
        
        createBtn.click { [weak self] in
            guard let self = self else { return }
            let vc = TermsVC(.create)
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: rx.disposeBag)
        
        importBtn.click { [weak self] in
            guard let self = self else { return }
            let vc = TermsVC(.restore)
            navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: rx.disposeBag)
    }

}
