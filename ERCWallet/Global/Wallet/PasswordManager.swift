//
//  passwordManager.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/4.
//

import Foundation


class PasswordManager {
    
    static let shared = PasswordManager()
    
    private(set) var password: String = ""
    
    private init() {
        
    }
    
    func createPassword(_ pwd: String) {
        password = pwd
    }
    
    func verifyPassword(_ pwd: String) -> Bool {
        let wallet = WalletManager.shared.getCurrentWallet()
        
        // pass the verification if can decrypt to mnemonic
        if wallet.encryptMnemonic.count > 0 {
            let decryptMnemonic = WalletManager.shared.aesDecrypt(wallet.encryptMnemonic, pwd)
            if decryptMnemonic != nil && decryptMnemonic!.count > 0 {
                
                let wordCount = decryptMnemonic!.components(separatedBy: " ").count
                if wordCount == 12 || wordCount == 18 || wordCount == 24 {
                    password = pwd
                    return true
                }
            }
        }
        
        // pass the verification if can decrypt to privateKey
        if wallet.encryptPrivateKey.count > 0 {
            if let decryptMnemonic = WalletManager.shared.aesDecrypt(wallet.encryptPrivateKey, pwd), decryptMnemonic.count > 0 {
                password = pwd
                return true
            }
        }
        
        return false
    }
}
