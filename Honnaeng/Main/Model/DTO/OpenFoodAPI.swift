//
//  Sample.swift
//  Honnaeng
//
//  Created by Rarla on 3/30/24.
//

import Foundation

struct OpenFoodAPI: Decodable {
    let serviceId: ServiceId

    enum CodingKeys: String, CodingKey {
        case serviceId = "C005"
    }
}

struct ServiceId: Decodable {
    let row: [Row]
    let result: Result

    enum CodingKeys: String, CodingKey {
        case result = "RESULT"
        case row
    }
}

struct Result: Decodable {
    let msg, code: String

    enum CodingKeys: String, CodingKey {
        case msg = "MSG"
        case code = "CODE"
    }
}

struct Row: Decodable {
    let name, group: String

    enum CodingKeys: String, CodingKey {
        case name = "PRDLST_NM"
        case group = "PRDLST_DCNM"
    }
}
