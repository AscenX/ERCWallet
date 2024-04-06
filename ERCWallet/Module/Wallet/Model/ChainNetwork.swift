//
//  ChainNetwork.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/6.
//

import UIKit

class ChainNetwork: Codable {
    
    var chainId: Int
    var rpcUrl: String
    var name: String
    var symbol: String
    var browserUrl: String?
    
    init(chainId: Int, rpcUrl: String,  name: String, symbol: String, browserUrl: String? = nil) {
        self.name = name
        self.chainId = chainId
        self.rpcUrl = rpcUrl
        self.browserUrl = browserUrl
        self.symbol = symbol
    }
}

extension ChainNetwork {
    
    static let ethMainnet = ChainNetwork(
        chainId: 1,
        rpcUrl: "https://mainnet.infura.io/v3/",
        name: "ETH Mainnet",
        symbol: "ETH",
        browserUrl: "https://etherscan.io"
    )
    
    static let sepoliaTestnet = ChainNetwork(
        chainId: 11155111,
        rpcUrl: "https://sepolia.infura.io/v3/",
        name: "Sepolia Testnet",
        symbol: "sepoliaETH",
        browserUrl: "https://sepolia.etherscan.io"
    )
    
    static let cronosMainnet = ChainNetwork(
        chainId: 25,
        rpcUrl: "https://evm.cronos.org",
        name: "Cronos",
        symbol: "CRO",
        browserUrl: "https://explorer.cronos.org/"
    )
    
    static let cronosTestnet = ChainNetwork(
        chainId: 338,
        rpcUrl: "https://evm-t3.cronos.org",
        name: "Cronos Testnet",
        symbol: "TCRO",
        browserUrl: "https://explorer.cronos.org/"
    )
    

}
