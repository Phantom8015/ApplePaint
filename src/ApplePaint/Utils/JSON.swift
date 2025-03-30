//
//  JSON.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/27.
//

import Foundation

class JSON {

    // MARK: 编码泛型方法
    static func encode<T: Codable>(_ value: T) -> Data? {
        let encoder = JSONEncoder()
        // 格式化输出
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(value)
            return data
        } catch {
            AppSetter.shared.showToast(
                message: NSLocalizedString("Encoding failed", comment: "编码失败: ")
                    + error.localizedDescription)
            return nil
        }
    }

    // MARK: 解码泛型方法
    static func decode<T: Codable>(_ type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedValue = try decoder.decode(T.self, from: data)
            return decodedValue
        } catch {
            AppSetter.shared.showToast(
                message: NSLocalizedString("Decoding failed: ", comment: "解码失败")
                    + error.localizedDescription)
            return nil
        }
    }
}
