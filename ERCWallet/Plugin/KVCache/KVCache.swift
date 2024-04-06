//
//  KVCache.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/4.
//

import Foundation
import MMKV


class KVCache {
    
    private static let mmkv: MMKV = MMKV.default()!
    
    class func setObject<T: Codable>(_ obj: T, for key: String) {
        if let data = try? JSONEncoder().encode(obj) {
            mmkv.set(data, forKey: key)
        }
    }
    
    class func getObject<T: Codable>(from key: String, _ type: T.Type) -> T? {
        if let data = mmkv.data(forKey: key) {
            if let obj = try? JSONDecoder().decode(type, from: data) {
                return obj
            }
        }
        return nil
    }
    
    class func setCodableArray<T: Codable>(_ arr: [T], for key: String) {
        if let arrData = try? JSONEncoder().encode(arr) {
            mmkv.set(arrData, forKey: key)
        }
    }
    
    class func getCodableArray<T: Codable>(from key: String, _ type: [T].Type) -> [T] {
        if let arrData = mmkv.data(forKey: key) {
            if let arr = try? JSONDecoder().decode(type, from: arrData) {
                return arr
            }
        }
        return []
    }
    
    class func setIntArray(_ array: [Int], for key: String) {
        let arrStr = array.map{ String($0) }.joined(separator: ",")
        self.mmkv.set(arrStr, forKey: key)
    }
    
    class func getIntArray(from key: String) -> [Int] {
        let arrStr = self.mmkv.string(forKey: key) ?? ""
        return arrStr.count > 0 ? arrStr.components(separatedBy: ",").map{ Int($0) ?? 0 } : []
    }
    
    class func setStringArray(_ array: [String], for key: String) {
        let arrStr = array.joined(separator: "|,|")
        mmkv.set(arrStr, forKey: key)
    }
    
    class func getStringArray(from key: String) -> [String] {
        let arrStr = self.mmkv.string(forKey: key) ?? ""
        return arrStr.count > 0 ? arrStr.components(separatedBy: "|,|") : []
    }
    
    class func setInt(_ value: Int, for key: String) {
        mmkv.set(Int32(value), forKey: key)
    }
    
    class func getInt(_ key: String) -> Int {
        return Int(mmkv.int32(forKey: key))
    }
    
    class func clearAll() {
        mmkv.clearAll()
    }
}
