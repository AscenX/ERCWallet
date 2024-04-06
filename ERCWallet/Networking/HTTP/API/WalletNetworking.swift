//
//  WalletNetworking.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/5.
//

import Foundation
import Moya
import RxSwift


extension Networking {
    
    static private var walletProvider = MoyaProvider<WalletAPI>(requestClosure: { (endpoint:Endpoint, done: @escaping MoyaProvider<WalletAPI>.RequestResultClosure) in
        do{
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 30 // timeout seconds
            done(.success(request))
        } catch {
            return
        }
    }, plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: NetworkLoggerPlugin.Configuration.LogOptions.verbose))])
    
    static func getBalance(_ rpcUrl: String, _ chainId: Int, _ address: String) -> Observable<RpcResponse> {
        return requestForReponse(WalletAPI.getBalance(rpcUrl, chainId, address), RpcResponse.self, walletProvider)
    }
    
    static func getNonce(_ rpcUrl: String, _ chainId: Int, _ address: String) -> Observable<RpcResponse> {
        return requestForReponse(WalletAPI.getNonce(rpcUrl, chainId, address), RpcResponse.self, walletProvider)
    }
    
    static func getGasPrice(_ rpcUrl: String, _ chainId: Int) -> Observable<RpcResponse> {
        return requestForReponse(WalletAPI.getGasPrice(rpcUrl, chainId), RpcResponse.self, walletProvider)
    }
}
