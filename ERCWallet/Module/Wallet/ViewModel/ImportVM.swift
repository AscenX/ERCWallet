//
//  ImportVM.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/4.
//

import UIKit
import RxSwift
import RxCocoa
import web3swift
import Web3Core
import Action

class ImportVM: BaseViewModel {
    
    let mnemonicRelay = BehaviorRelay(value: "")
    
    /// check mnemonic is valid
    private(set) var isValidOb: Observable<Bool>!
    
    private(set) var restoreAction: Action<Void, Bool>!
    
    override func setup() {
        
        isValidOb = mnemonicRelay
//            .filter{ $0.contains(" ") && $0.components(separatedBy: " ").count > 1 }
            .map { [weak self] mnemonic in
                guard let self = self else { return false }
                if !mnemonic.contains(" ") { return true }
                return isMnemonicValid(mnemonic)
            }
            .asObservable()
        
        restoreAction = Action(enabledIf: isValidOb, workFactory: { [weak self] _ in
            guard let self = self else { return Observable.just(false) }
            return Observable.create { observer in
                Task {
                    let isSuccess = await self.restoreWallet()
                    observer.onNext(isSuccess)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        })
    }
    
    /// check mnemonic is valid
    private func isMnemonicValid(_ mnemonic: String) -> Bool {
        if (mnemonic.isEmpty) { return true }
        
        let arr = mnemonic.components(separatedBy: " ")
        
        let words = BIP39Language.english.words
        for word in arr {
            if !word.isEmpty && (arr.last == word && words.filter({ $0.starts(with: word)}).count == 0 ||
                                 arr.last != word && words.filter({ $0 == word }).count == 0)
            {
                return false
            }
        }
        
        return true
    }
    
    /// restore wallet from input mnemonic
    private func restoreWallet() async -> Bool {
        let mnemonic = mnemonicRelay.value
        
        let isSuccess = await WalletManager.shared.importWallet(mnemonic, PasswordManager.shared.password)
        return isSuccess
    }
    
}
