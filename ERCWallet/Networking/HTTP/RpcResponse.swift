//
//  RpcResult.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/6.
//

import Foundation
import BigInt

struct RpcResponse: Codable {
    
    var jsonrpc: String?
    var id: Int?
    var result: String?
    
    func getResultNumber() -> BigUInt {
        if let res = result, res.starts(with: "0x") {
            let value = BigUInt(res.dropFirst(2), radix: 16) ?? 0
            return value
        }
        return BigUInt(0)
    }
}
