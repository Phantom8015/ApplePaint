//
//  structure.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/28.
//

import AppKit

// MARK: Backgroud Type
enum CanvasBackground: String {
    case VisualEffectBlur, Colorful, Picture, Customize
}

// MARK: Blackboard Properties
extension NSImage.Name {
    static let blackboard1 = "blackboard1"
    static let blackboard2 = "blackboard2"
    static let blackboard3 = "blackboard3"
    static let blackboard4 = "blackboard4"
}

// MARK: PainPath & PaintData
struct PaintPath: Codable {
    // 用 HEX 码表示颜色
    var color: String
    var lineWidth: CGFloat
    var points: [CGPoint]
}
struct PaintData: Codable {
    var paths: [PaintPath]
    var currentPoints: [CGPoint]
    var redoStack: [PaintPath]
}

// MARK: Export Image Type
enum ExportFormat {
    case Png, Jpeg, Tiff
}
