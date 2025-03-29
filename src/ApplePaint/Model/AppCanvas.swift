//
//  AppCanvas.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/26.
//

import Foundation
import SwiftUI

class AppCanvas: ObservableObject {

    static let shared = AppCanvas()

    // MARK: 状态
    private var colorPanelDelegate = ColorPanelDelegate.shared
    @Published var isErasing = false
    @Published var tappedLocation: CGPoint?

    // MARK: Canvas
    // 基础颜色集
    @Published var baseColor: [Color] = [
        Color(hex: "#0000FF"), Color(hex: "#FF0000"), Color(hex: "#00FF00"),
        Color(hex: "#FFA500"), Color(hex: "#800080"), Color(hex: "#000000"),
        Color(hex: "#FFFFFF"),
    ]
    {
        didSet {
            if baseColor.isEmpty {
                baseColor.append(.white)
            }
        }
    }
    // MARK: 颜色
    // 用于永久保存颜色
    @Published var customizeColor: [Color] = []
    var tempColor: [Color] = []
    @Published var selectedColor: Color = .blue
    @Published var previousColor: Color = .black

    // MARK: 内容
    @Published var paths:
        [(color: Color, lineWidth: CGFloat, points: [CGPoint])] = []
    @Published var currentPoints: [CGPoint] = []
    @Published var redoStack:
        [(color: Color, lineWidth: CGFloat, points: [CGPoint])] = []

    private init() {
        // 初始化自定义颜色
        customizeColor = AppSetter.shared.getCustomizeColor()
        tempColor = customizeColor
        previousColor = selectedColor
    }

    // MARK: 回退颜色
    func colorRollback() {
        selectedColor = previousColor
    }

    // MARK: 暂时添加颜色
    func appendColor() {
        colorPanelDelegate.openPanel()
    }

    // MARK: 永久删除颜色
    func deleteCustomizeColor(color: Color) {
        if baseColor.contains(color) {
            baseColor.removeAll { item in
                item == color
            }
        }
        customizeColor.removeAll { item in
            item == color
        }
        AppSetter.shared.saveCustomizeColor(color: customizeColor)
    }

    // MARK: 添加颜色
    func setCustomizeColor(color: Color) {
        tempColor.append(color)
        var storeColor = AppSetter.shared.getCustomizeColor()
        // 不包含就添加
        if !storeColor.contains(color) {
            storeColor.append(color)
            AppSetter.shared.saveCustomizeColor(color: storeColor)
        }
    }

    // MARK: 清除
    func eraseAt(location: CGPoint) {
        paths.removeAll { path in
            path.points.contains { point in
                let distance = hypot(point.x - location.x, point.y - location.y)
                return distance <= AppSetter.shared.lineWidth
            }
        }
    }
    // MARK: 撤回
    func undo() {
        guard let lastPath = paths.popLast() else { return }
        redoStack.append(lastPath)
    }
    // MARK: 取消撤回
    func redo() {
        guard let lastRedo = redoStack.popLast() else { return }
        paths.append(lastRedo)
    }
    // MARK: 减小窗口
    func shrinkWindow() {
        adjustWindowSize(deltaHeight: -40)
    }
    // MARK: 增加窗口
    func enlargeWindow() {
        adjustWindowSize(deltaHeight: 40)
    }
    //    MARK: 窗口的内部方法
    private func adjustWindowSize(deltaHeight: CGFloat) {

        guard let screenSize = NSScreen.main?.frame else { return }

        if let window = NSApplication.shared.windows.first(where: {
            $0.title == "Canvas"
        }) {
            var frame = window.frame

            let height = frame.height

            let newHeight = height + deltaHeight
            let newWidth = newHeight * (16.0 / 10.0)

            frame.size = CGSize(width: newWidth, height: newHeight)

            // width: 480, height: 300
            if newHeight <= 300 || newWidth <= 480 {
                frame.size = CGSize(width: 300, height: 480)
                window.setFrame(frame, display: true, animate: true)
                return
            }
            if newHeight > screenSize.height || newWidth > screenSize.width {
                frame.size = CGSize(
                    width: screenSize.width, height: screenSize.height)
                window.setFrame(frame, display: true, animate: true)
                return
            }

            window.setFrame(frame, display: true, animate: true)
        }
    }

}
