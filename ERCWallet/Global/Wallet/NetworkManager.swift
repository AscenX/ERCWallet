//
//  NetworkManager.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/6.
//

import UIKit
import RxSwift
import RxCocoa

private let kNetowrkList = "NetworkListKey"
private let kNetowrkIndex = "NetworkIndexKey"

/// manage networks of block chain
class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let defaultNetworks = [
        ChainNetwork.ethMainnet,
        ChainNetwork.sepoliaTestnet,
        ChainNetwork.cronosMainnet,
        ChainNetwork.cronosTestnet,
    ]
    
    private(set) var networkList = BehaviorRelay<[ChainNetwork]>(value: [])
    
    private(set) var currentIndex = BehaviorRelay(value: 0)
    
    private init() {
        var networks = KVCache.getCodableArray(from: kNetowrkList, [ChainNetwork].self)
        if networks.isEmpty {
            networks = defaultNetworks
            KVCache.setCodableArray(networks, for: kNetowrkList)
        }
        networkList.accept(networks)
        
        let index = KVCache.getInt(kNetowrkIndex)
        if index > 0 {
            currentIndex.accept(index)
        }
    }
    
    func getCurrentNetwork() -> ChainNetwork {
        return networkList.value[currentIndex.value]
    }
    
    func addNetwork(_ network: ChainNetwork) {
        var networks = networkList.value
        networks.append(network)
        
        networkList.accept(networks)
        KVCache.setCodableArray(networks, for: kNetowrkList)
    }
    
    func switchNetwork(_ index: Int) {
        currentIndex.accept(index)
        KVCache.setInt(index, for: kNetowrkIndex)
    }
}
