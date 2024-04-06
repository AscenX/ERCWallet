//
//  MyWallet.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/4.
//

import UIKit

enum MyWalletType: Codable {
    case hdWallet
    case privateKey
}

class MyWallet: Codable, Equatable {
    
    var walletType: MyWalletType = .hdWallet
    var name: String = ""
    var encryptMnemonic: String = ""
    var encryptPrivateKey: String = ""
    var address: String = ""

    static func == (lhs: MyWallet, rhs: MyWallet) -> Bool {
        return lhs.encryptMnemonic.count > 0 && lhs.encryptMnemonic == rhs.encryptMnemonic ||
        lhs.encryptPrivateKey.count > 0 && lhs.encryptPrivateKey == rhs.encryptPrivateKey
    }
}
