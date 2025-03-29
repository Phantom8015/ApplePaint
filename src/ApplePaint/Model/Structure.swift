//
//  structure.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/28.
//

import AppKit

// MARK: 背景类型
enum CanvasBackground: String {
    case VisualEffectBlur, Colorful, Picture, Customize
}

// MARK: Hover状态
enum HoverHandler {
    case Thickness, Backgroud
}

// MARK: 内置图片
extension NSImage.Name {
    static let blackboard1 = "blackboard1"
    static let blackboard2 = "blackboard2"
    static let blackboard3 = "blackboard3"
    static let blackboard4 = "blackboard4"
}
