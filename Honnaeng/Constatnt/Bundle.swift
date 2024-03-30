//
//  Bundle.swift
//  Honnaeng
//
//  Created by Rarla on 3/30/24.
//

import Foundation

extension Bundle {
    var foodSafetyKoreaApiKey: String? {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let rawData = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let realData = try? PropertyListSerialization.propertyList(from: rawData, format: nil) as? [String: Any],
              let key = realData["FoodSafetyKoreaApiKey"] as? String else { return nil }
        return key
    }
}
