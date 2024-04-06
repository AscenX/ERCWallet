//
//  Response.swift
//  Ascen
//
//  Created by ascen on 2019/4/23.
//  Copyright © 2019 Ascen. All rights reserved.
//

import Foundation

struct Resp<T: Codable>: Codable {
    
    var code: Int = -1
    var data: T?
    var message: String?
}
