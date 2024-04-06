//
//  SendTokenVM.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/5.
//

import UIKit
import Action
import RxSwift
import RxCocoa
import web3swift
import Web3Core
import BigInt

class SendTokenVM: BaseViewModel {
    
    private(set) var sendAction: Action<Void, Bool>!
    
    /// send amount
    private(set) var amountRelay = BehaviorRelay(value: "")
    
    /// to address
    private(set) var toAddressRelay = BehaviorRelay(value: "")
    
    /// enable to send
    private(set) var enableOb: Observable<Bool>!
    
    private(set) var balanceOb: Observable<String>!
    
    
    override func setup() {
        
        let wallet = WalletManager.shared.getCurrentWallet()
        let network = NetworkManager.shared.getCurrentNetwork()
        
        // get balance
        balanceOb = Networking.getBalance(network.rpcUrl, network.chainId, wallet.address).map { $0.getResultNumber().formatToEther() }
        
        // enable to send
        enableOb = Observable.combineLatest(amountRelay.asObservable(), toAddressRelay.asObservable(), balanceOb).map({ (amount, address, balance) in
            return (Float(amount) ?? 0.0) > 0.0 && address.count > 0 && (Float(amount) ?? 0.0) <= (Float(balance) ?? 0.0)
        })
        
        
        // send transaction
        sendAction = Action(enabledIf: enableOb, workFactory: { [weak self] _ in
            
            guard let self = self else { return Observable.just(false) }
            
            let wallet = WalletManager.shared.getCurrentWallet()
            let network = NetworkManager.shared.getCurrentNetwork()
            
            let gasPriceOb = Networking.getGasPrice(network.rpcUrl, network.chainId).map { $0.getResultNumber() }
            
            let nonceOb = Networking.getNonce(network.rpcUrl, network.chainId, wallet.address).map { $0.getResultNumber() }
            
            return Observable.zip([
                gasPriceOb,
                nonceOb
            ]).flatMap { data in
                guard data.count == 2 else { return Observable.just(false) }
                
                let gasPrice = data.first!
                let nonce = data.last!
                
                return Observable<Bool>.create { observer in
                    
                    Task {
                        
                        let isSuccess = await self.sendETH(gasPrice, nonce)
                        if isSuccess { // seem not work, tx maybe not completed
                            NotificationCenter.default.post(name: NSNotification.Name.BalanceUpdate, object: nil)
                        }
                        observer.onNext(isSuccess)
                        observer.onCompleted()
                    }
                    
                    return Disposables.create()
                }
            }
            
        })
        
    }

    
    // MARK: - Logic
    
    private func sendETH(_ gasPrice: BigUInt, _ nonce: BigUInt) async -> Bool {
        let wallet = WalletManager.shared.getCurrentWallet()
        let currentNetwork = NetworkManager.shared.getCurrentNetwork()
        
        let account = wallet.address
        
    
        
        var transaction: CodableTransaction = .emptyTransaction
        transaction.from = EthereumAddress(account)
        transaction.to = EthereumAddress(toAddressRelay.value)!
        transaction.chainID = BigUInt(currentNetwork.chainId)
        if let amount = amountRelay.value.parseEther() {
            transaction.value = amount
        }
        
        transaction.gasPrice = gasPrice
        transaction.nonce = nonce
        
        transaction.gasLimit = BigUInt(21000)
        
        
        var url = currentNetwork.rpcUrl
        
        if url.contains("infura") {
            url += infuraApiKey
        }
        
        guard let provider = try? await Web3HttpProvider(url: URL(string: url)!, network: .Custom(networkID: BigUInt(currentNetwork.chainId))) else { return false }
        let web3 = Web3(provider: provider)
        
        
        guard let privateKey = WalletManager.shared.getCurrentPrivateKey(PasswordManager.shared.password) else { return false }
        
        do {
            try transaction.sign(privateKey: privateKey)
            
            guard let encodeData = transaction.encode() else { return false }
            let res = try await web3.eth.send(raw: encodeData)
            debugPrint("res:\(res)")
            return res.hash.count > 0
        } catch {
            debugPrint("send error:\(error)")
            return false
        }
        
        
    }
    
}
