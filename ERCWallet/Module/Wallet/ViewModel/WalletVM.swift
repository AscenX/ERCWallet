//
//  WalletVM.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/4.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import BigInt
import web3swift

class WalletVM: BaseViewModel {
    
    /// current account name
    private(set) var accountOb: Observable<String>!
    /// current address
    private(set) var addressOb: Observable<String>!
    
    /// get balance
    private(set) var balanceOb: Observable<String>!
    
    /// current network
    private(set) var networkNameOb: Observable<String>!
    
    
    override func setup() {
        
        let currentWalletOb: Observable<MyWallet?> = Observable.combineLatest(WalletManager.shared.allMyWallet, WalletManager.shared.currentIndex, resultSelector: { wallets, index in
            return index < 0 || wallets.count == 0 || index >= wallets.count ? nil : wallets[index]
        })
        
        accountOb = currentWalletOb.map{ $0?.name ?? "" }
        
        addressOb = currentWalletOb.map{ $0?.address ?? "" }
        
        
        let currentNetworkOb =        Observable.combineLatest(NetworkManager.shared.networkList, NetworkManager.shared.currentIndex)
            .filter { (networkList, index) in
                return networkList.count >= 0 || index < networkList.count
            }
            .map { (networkList, index) in
                return networkList[index]
            }
        
        networkNameOb = currentNetworkOb.map({ network in
            return network.name + "  "
        })
        
        // balance update notification
        let balanceUpdateOb = NotificationCenter.default.rx.notification(Notification.Name.BalanceUpdate)
            .startWith(Notification(name: Notification.Name.BalanceUpdate))
        
        // udpate balance when address or netowrk change or receive udpate notification
        balanceOb = Observable.combineLatest(addressOb, currentNetworkOb, balanceUpdateOb) { (address, network, _) in
            return (address, network)
        }
            .filter({ (address, network) in
                return address.count > 0
            })
            .flatMap({ (address, network) in
                return Networking.getBalance(network.rpcUrl, network.chainId, address).map { $0.getResultNumber() }.map { balance in
                    return "\(balance.formatToEther()) \(network.symbol)"
                }
            })
        
    }
    
}
