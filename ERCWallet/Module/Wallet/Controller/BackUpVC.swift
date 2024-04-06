//
//  BackUpVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/3.
//

import UIKit

class BackUpVC: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    private var mnemonicList: [String] = []
    
    convenience init(_ mnemonic: String) {
        
        self.init()
        
        mnemonicList = mnemonic.components(separatedBy: " ")
    }
    
    override func setupView() {
        
        // set back up mnemonic
        if mnemonicList.count == 12 {
            for (idx, word) in mnemonicList.enumerated() {
                if let wordLbl = containerView.viewWithTag(idx+1) as? UILabel {
                    wordLbl.text = word
                }
                if let indexLbl = containerView.viewWithTag(idx + 101) as? UILabel {
                    indexLbl.text = "\(idx+1)"
                }
            }
        }
    }
    
    override func setupAction() {
        
        continueBtn.click {
            let verifyVc = VerifyMnemonicVC(self.mnemonicList)
            self.navigationController?.pushViewController(verifyVc, animated: true)
        }.disposed(by: rx.disposeBag)
    }

}
