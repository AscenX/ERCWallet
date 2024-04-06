//
//  TermsVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/3.
//

import UIKit

enum CreateWalletType {
    case create
    case restore
}

class TermsVC: BaseViewController {

    @IBOutlet weak var continueBtn: UIButton!
    
    private var type = CreateWalletType.create
    
    convenience init(_ type: CreateWalletType) {
        self.init()
        
        self.type = type
    }
    
    override func setupAction() {
        
        continueBtn.click { [weak self] in
            guard let self = self else { return }
            // no password
            if PasswordManager.shared.password.isEmpty {
                let pwdVc = PasswordVC(.create, false) {
                    
                    if let nav = self.navigationController {
                        if self.type == .restore {
                            let vc = ImportWalletVC()
                            nav.pushViewController(vc, animated: true)
                        } else {
                            let vc = CreateWalletVC()
                            nav.pushViewController(vc, animated: true)
                        }
                        var vcs = nav.viewControllers
                        vcs.remove(at: vcs.count - 2)
                        nav.setViewControllers(vcs, animated: false)
                    }
                }
                self.navigationController?.pushViewController(pwdVc, animated: true)
            } else {
                if let nav = self.navigationController {
                    if self.type == .restore {
                        let vc = ImportWalletVC()
                        nav.pushViewController(vc, animated: true)
                    } else {
                        let vc = CreateWalletVC()
                        nav.pushViewController(vc, animated: true)
                    }
                }
            }
            
        }.disposed(by: rx.disposeBag)
    }

}
