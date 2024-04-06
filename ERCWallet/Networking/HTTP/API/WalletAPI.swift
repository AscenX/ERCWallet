//
//  WalletAPI.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/5.
//

import UIKit
import Moya

enum WalletAPI {

    case getBalance(_ rpcUrl: String, _ chainId: Int, _ address: String)
    case getNonce(_ rpcUrl: String, _ chainId: Int, _ address: String)
    case getGasPrice(_ rpcUrl: String, _ chainId: Int)
}

extension WalletAPI: TargetType {
    
    var method: Moya.Method {
        return .post
    }
    
    var headers: [String : String]? {
        return NetworkUtil.commonHttpHeaders
    }
    
    
    var baseURL: URL {
        switch self {
        case .getBalance(let rpcUrl, _, _), 
                .getNonce(let rpcUrl, _, _),
                .getGasPrice(let rpcUrl, _):
            return URL(string: rpcUrl) ?? URL(string: infuraBaseUrl)!
        }
    }

    var path: String {
        let p = baseURL.absoluteString.contains("infura") ? infuraApiKey : ""
//        switch self {
//        case .getBalance:
//            p += ""
//        }
        return p
    }

    var sampleData: Data {
        return "null".data(using: .utf8)!
    }

    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case .getBalance(_, let chainId, let address):
            params = [
                "jsonrpc" : "2.0",
                "method" : "eth_getBalance",
                "params" : [address, "latest"],
                "id" : chainId
            ]
        case .getNonce(_, let chainId, let address):
            params = [
                "jsonrpc" : "2.0",
                "method" : "eth_getTransactionCount",
                "params" : [address, "latest"],
                "id" : chainId
            ]
        case .getGasPrice(_, let chainId):
            params = [
                "jsonrpc" : "2.0",
                "method" : "eth_gasPrice",
                "params" : [],
                "id" : chainId
            ]
            
//        default:
//            return .requestPlain
        }
        let data = (try? JSONSerialization.data(withJSONObject: params)) ?? Data()
        return .requestCompositeData(bodyData: data, urlParameters: [:])
    }

}

