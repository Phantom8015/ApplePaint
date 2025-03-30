//
//  JSON.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/27.
//

import Foundation

class JSON {
    // MARK: encode Data to JSON
    static func encode<T: Codable>(_ value: T) -> Data? {
        let encoder = JSONEncoder()
        // 格式化输出
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(value)
            return data
        } catch {
            AppSetter.shared.showToast(
                message: NSLocalizedString("Encoding failed", comment: "Encoding failed")
                    + error.localizedDescription)
            return nil
        }
    }
    
    // MARK: decode Data to JSON
    static func decode<T: Codable>(_ type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedValue = try decoder.decode(T.self, from: data)
            return decodedValue
        } catch {
            if data.isEmpty {
                if let emptyArray = [] as? T {
                    return emptyArray
                }
            }
            AppSetter.shared.showToast(
                message: NSLocalizedString("Decoding failed: ", comment: "Decoding failed")
                    + error.localizedDescription)
            return nil
        }
    }
}
