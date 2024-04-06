//
//  BigIntExtensions.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/6.
//

import Foundation
import BigInt
import Web3Core

extension BigInt {
    func formatToEther() -> String {
        return Web3Core.Utilities.formatToPrecision(self)
    }
}

extension BigUInt {
    func formatToEther() -> String {
        return Web3Core.Utilities.formatToPrecision(self)
    }
}
