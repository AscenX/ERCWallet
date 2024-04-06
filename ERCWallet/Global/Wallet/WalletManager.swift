//
//  WalletManager.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/3.
//

import Foundation
import Web3Core
import CryptoSwift
import RxCocoa

/// cache key for all my wallets
private let kMyWallet = "MyWalletKey"
/// cache key for current wallet index
private let kWalletIndex = "WalletIndexKey"

class WalletManager {
    
    
    private(set) var allMyWallet = BehaviorRelay(value:[MyWallet]())
    private(set) var currentIndex = BehaviorRelay(value: -1)
    
    static let shared = WalletManager()
    
    private init() {
        allMyWallet.accept(KVCache.getCodableArray(from: kMyWallet, [MyWallet].self))
        
        if allMyWallet.value.count > 0 {
            let walletIdx = KVCache.getInt(kWalletIndex)
            currentIndex.accept(walletIdx)
        }
    }
    
    static var hasWallet: Bool = {
        return shared.allMyWallet.value.count > 0
    }()
    
    // MARK: - Actor
    
    private actor WalletActor {
        
        func restore(_ mnemonic: String, _ pwd: String) -> Bool {
        
            guard let seed = BIP39.seedFromMmemonics(mnemonic) else { return false }
            
            guard let keystore = try? BIP32Keystore(seed: seed, password: "") else { return false }
            
            if let ethAddress = keystore.addresses?.first {
                cacheWallet("Wallet \(shared.allMyWallet.value.count + 1)", mnemonic, pwd, ethAddress.address)
            }
            
            return true
        }
        
        func create(_ pwd: String? = nil) -> String {
            
            guard let mnemonic = try? BIP39.generateMnemonics(bitsOfEntropy: 128) else  {
                return ""
            }
            
            guard let pwd = pwd else { return mnemonic }
            let isSuccess = restore(mnemonic, pwd)
            
            return isSuccess ? mnemonic : ""
        }
        
        func cacheWallet(_ walletName: String, _ mnemonic: String, _ password: String, _ address: String) {
            
            let wallet = MyWallet()
            wallet.name = walletName
            let encryptMnemonic = shared.aesEncrypt(mnemonic, password) ?? ""
            wallet.encryptMnemonic = encryptMnemonic
            wallet.address = address
            
            var wallets = shared.allMyWallet.value
            wallets.append(wallet)
            shared.allMyWallet.accept(wallets)
            
            KVCache.setCodableArray(wallets, for: kMyWallet)
            
            shared.currentIndex.accept(wallets.count - 1)
            KVCache.setInt(wallets.count - 1, for: kWalletIndex)
        }
    }
    
    private let actor = WalletActor()
    
    // MARK: - Function
    
    func createWallet(_ pwd: String? = nil) async -> String {
        return await actor.create(pwd)
    }
        
    func importWallet(_ mnemonic: String, _ pwd: String) async -> Bool {
        return await actor.restore(mnemonic, pwd)
    }
    
    func updateWalletName(_ name: String, _ index: Int) {
        var wallets = allMyWallet.value
        let wallet = wallets[index]
        wallet.name = name
        
        wallets[index] = wallet
        allMyWallet.accept(wallets)
        KVCache.setCodableArray(allMyWallet.value, for: kMyWallet)
    }
    
    func switchIndex(_ index: Int) {
        currentIndex.accept(index)
        KVCache.setInt(index, for: kWalletIndex)
    }
    
    func getCurrentWallet() -> MyWallet {
        return allMyWallet.value[currentIndex.value]
    }
    
//    func getCurrentPrivateKey(_ password: String) -> String? {
//        guard allMyWallet.value.count > 0 && currentIndex.value < allMyWallet.value.count else { return nil }
//        
//        let currentWallet = allMyWallet.value[currentIndex.value]
//        
//        if currentWallet.encryptPrivateKey.count > 0 {
//            return aesDecrypt(currentWallet.encryptPrivateKey, password)
//        }
//        guard let currentMnemonic = aesDecrypt(currentWallet.encryptMnemonic, password) else { return nil }
//        
//        guard let seed = BIP39.seedFromMmemonics(currentMnemonic) else { return nil }
//        
//        guard let keystore = try? BIP32Keystore(seed: seed, password: "") else { return nil }
//        
//        guard let addr = keystore.addresses?.first else { return nil }
//        
//        guard let privateKey = try? keystore.UNSAFE_getPrivateKeyData(password: "", account: addr) else { return nil }
//        
//        
//        return privateKey.toHexString()
//        
//    }
    
    func getCurrentPrivateKey(_ password: String) -> Data? {
        guard allMyWallet.value.count > 0 && currentIndex.value < allMyWallet.value.count else { return nil }
        
        let currentWallet = allMyWallet.value[currentIndex.value]
        
        if currentWallet.encryptPrivateKey.count > 0 {
            guard let privateKeyStr = aesDecrypt(currentWallet.encryptPrivateKey, password) else { return nil }
            return privateKeyStr.data(using: .utf8)
        }
        guard let currentMnemonic = aesDecrypt(currentWallet.encryptMnemonic, password) else { return nil }
        
        guard let seed = BIP39.seedFromMmemonics(currentMnemonic) else { return nil }
        
        guard let keystore = try? BIP32Keystore(seed: seed, password: "") else { return nil }
        
        guard let addr = keystore.addresses?.first else { return nil }
        
        guard let privateKey = try? keystore.UNSAFE_getPrivateKeyData(password: "", account: addr) else { return nil }
        
        
        return privateKey
        
    }
    
    /// sign transaction
    func signTransaction() {
        
    }
    
    func aesEncrypt(_ data: String, _ password: String) -> String? {
        do {
            let aes = try AES(key: password.sha1()[0..<16], iv: password.md5()[0..<16])
            let encryptStr = try aes.encrypt(data.bytes).toBase64()
            return encryptStr
        } catch {
            return nil
        }
    }
    
    func aesDecrypt(_ encryptData: String, _ password: String) -> String? {
        do {
            let aes = try AES(key: password.sha1()[0..<16], iv: password.md5()[0..<16])
            let bytes = [UInt8](base64: encryptData)
            guard bytes.count > 0 else { return nil }
            let decryptData = try aes.decrypt(bytes)
            return String(bytes: decryptData, encoding: .utf8)
            
        } catch {
            return nil
        }
    }
}
