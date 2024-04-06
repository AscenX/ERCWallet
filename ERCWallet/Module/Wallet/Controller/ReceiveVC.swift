//
//  ReceiveVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/5.
//

import UIKit

class ReceiveVC: BaseViewController {

    @IBOutlet weak var qrcodeImgView: UIImageView!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var copyBtn: UIButton!
    
    // MARK: - Set up
    
    override func setupView() {
        
        title = "Receive"
        
        let wallet = WalletManager.shared.getCurrentWallet()
        if let qrcodeImg = generateQrcode(wallet.address) {
            qrcodeImgView.image = qrcodeImg
            qrcodeImgView.layer.magnificationFilter = .nearest
        }
        addressLbl.text = wallet.address
    }

    override func setupAction() {
        
        copyBtn.click { [weak self] in
            guard let self = self else { return }
            if let addr = addressLbl.text, addr.count > 0 {
                UIPasteboard.general.string = addr
                HUD.showSuccess("Copy success")
            }
        }.disposed(by: rx.disposeBag)
    }

    // MARK: - Logic
    
    private func generateQrcode(_ address: String) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(address.data(using: .utf8), forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        if let img = filter.outputImage {
            return UIImage(ciImage: img, scale: 1.0, orientation: .down)
        }
        
        return nil
    }

}
