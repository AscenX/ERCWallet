//
//  Network.swift
//  ERCWallet
//
//  Created by ascen on 2019/4/22.
//  Copyright © 2019 Ascen. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct Networking {
    
    static var prevUrl: String = ""
    private static var cancelableRequest: Cancellable?
    
    static func requestRawData<T: TargetType>(_ target: T, _ provider: MoyaProvider<T>) -> Observable<[String : Any]> {
        return Observable.create({ (observer) -> Disposable in
            
            let request = provider.request(target, completion: { (result) in
                switch result {
                case let .success(response):
                    if response.statusCode == 200 {
                        if let respDict: [String : Any] = try? JSONSerialization.jsonObject(with: response.data) as? [String : Any] {
                            observer.onNext(respDict)
                            observer.onCompleted()
                        } else {
                            let err = NSError(domain: "ParseError", code: response.statusCode, userInfo: ["msg" : String(bytes: response.data, encoding: .utf8) ?? "" ])
                            observer.onError(err)
                        }
                    } else {
                        let err = NSError(domain: "NetworkError", code: response.statusCode, userInfo: ["msg" : response.description ])
                        observer.onError(err)
                    }
                case let .failure(err):
                    let range = err.localizedDescription.range(of: ":")
                    if range?.isEmpty == false {
                        if let last = err.localizedDescription.split(whereSeparator: { c -> Bool in
                            return c.lowercased().elementsEqual(":")
                        }).last {
                            HUD.show(last.capitalized)
                        }
                    }
                    observer.onError(err)
                }
            })
            cancelableRequest = request
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    static func requestForReponse<T: TargetType, M: Codable>(_ target: T, _ type: M.Type, _ provider: MoyaProvider<T>) -> Observable<M> {
        
        return Observable.create({ (observer) -> Disposable in
            
            let decoder = JSONDecoder()
            
            let request = provider.request(target, completion: { (result) in
                switch result {
                case let .success(response):
                    if response.statusCode == 200 {
                        do {
                            let resp = try decoder.decode(M.self, from: response.data)
                            observer.onNext(resp)
                            observer.onCompleted()
                        } catch {
                            // parse error
                            observer.onError(error)
                        }
                        
                    } else {
                        let err = NSError(domain: "NetworkError", code: response.statusCode, userInfo: ["msg" : String(bytes: response.data, encoding: .utf8) ?? "http error"])
                        observer.onError(err)
                    }
                case let .failure(err):
                    observer.onError(err)
                }
            })
            cancelableRequest = request
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
}
