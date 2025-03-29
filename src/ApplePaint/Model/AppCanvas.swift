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

    
    private var colorPanelDelegate = ColorPanelDelegate.shared
    @Published var isErasing = false
    @Published var tappedLocation: CGPoint?

    
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
    
    @Published var customizeColor: [Color] = []
    var tempColor: [Color] = []
    @Published var selectedColor: Color = .blue
    @Published var previousColor: Color = .black

    
    @Published var paths:
        [(color: Color, lineWidth: CGFloat, points: [CGPoint])] = []
    @Published var currentPoints: [CGPoint] = []
    @Published var redoStack:
        [(color: Color, lineWidth: CGFloat, points: [CGPoint])] = []

    private init() {
        customizeColor = AppSetter.shared.getCustomizeColor()
        tempColor = customizeColor
        previousColor = selectedColor
    }

    
    func colorRollback() {
        selectedColor = previousColor
    }

    
    func appendColor() {
        colorPanelDelegate.openPanel()
    }

    
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

    
    func setCustomizeColor(color: Color) {
        tempColor.append(color)
        var storeColor = AppSetter.shared.getCustomizeColor()
        if !storeColor.contains(color) {
            storeColor.append(color)
            AppSetter.shared.saveCustomizeColor(color: storeColor)
        }
    }

    
    func eraseAt(location: CGPoint) {
        paths.removeAll { path in
            path.points.contains { point in
                let distance = hypot(point.x - location.x, point.y - location.y)
                return distance <= AppSetter.shared.lineWidth
            }
        }
    }
    
    func undo() {
        guard let lastPath = paths.popLast() else { return }
        redoStack.append(lastPath)
    }
    
    func redo() {
        guard let lastRedo = redoStack.popLast() else { return }
        paths.append(lastRedo)
    }
    
    func shrinkWindow() {
        adjustWindowSize(deltaHeight: -40)
    }
    
    func enlargeWindow() {
        adjustWindowSize(deltaHeight: 40)
    }
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
