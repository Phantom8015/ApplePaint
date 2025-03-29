//
//  Color.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/27.
//

import SwiftUI

extension Color {
    
    // MARK: init hex 到 Color
    init(hex: String) {
        var hexSanitized: String
        if hex.contains("#") {
            hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "#", with: "")
        } else {
            hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
    
    // MARK: 获取 hex
    func toHex() -> String {
        guard let components = self.cgColor?.components else {
            return "#000000"
        }

        if components.count >= 3 {
            let r = components[0]
            let g = components[1]
            let b = components[2]

            let red = Int(r * 255)
            let green = Int(g * 255)
            let blue = Int(b * 255)
            return String(format: "#%02X%02X%02X", red, green, blue)
        } else if components.count == 2 {
            let white = components[0]
            let gray = Int(white * 255)
            return String(format: "#%02X%02X%02X", gray, gray, gray)
        }
        
        return "#000000"
    }

    // MARK: 获取相反色（补色）
    func opposite() -> Color {
        
        let ciColor = CIColor(color: NSColor(self))!

        let invertedRed = 1.0 - ciColor.red
        let invertedGreen = 1.0 - ciColor.green
        let invertedBlue = 1.0 - ciColor.blue

        return Color(
            red: invertedRed,
            green: invertedGreen,
            blue: invertedBlue
        )
    }
    
}



