//
//  NSStringExtensions.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/6.
//

import Foundation
import BigInt
import Web3Core

extension String {
    
    func parseEther() -> BigUInt? {
        return Web3Core.Utilities.parseToBigUInt(self, decimals: 18)
    }
}
