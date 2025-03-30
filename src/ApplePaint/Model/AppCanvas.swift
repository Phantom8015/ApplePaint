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

    // MARK: Configuration
    private var colorPanelDelegate = ColorPanelDelegate.shared
    @Published var isErasing = false
    @Published var tappedLocation: CGPoint?

    // MARK: Color Properties
    @Published var baseColor: [Color] = [
        .primary, // This will be white in dark mode and black in light mode
        Color(hex: "#0000FF"), Color(hex: "#FF0000"), 
        Color(hex: "#00FF00"), Color(hex: "#FFA500"), Color(hex: "#800080"), 
        Color.white, Color.black,
    ]
    {
        didSet {
            if baseColor.isEmpty {
                baseColor.append(.primary) // Default to primary color if empty
            }
        }
    }
    @Published var customizeColor: [Color] = []
    var tempColor: [Color] = []
    @Published var selectedColor: Color = .primary // Default to primary color
    @Published var previousColor: Color = Color(hex: "#000000")

    
    // MARK: Canvas Properties
    @Published var paths:
        [(color: Color, lineWidth: CGFloat, points: [CGPoint])] = []
    @Published var currentPoints: [CGPoint] = []
    @Published var redoStack:
        [(color: Color, lineWidth: CGFloat, points: [CGPoint])] = []
    @Published var fileUrl:URL?
    
    private init() {
        // MARK: Init Color
        customizeColor = AppSetter.shared.getCustomizeColor()
        tempColor = customizeColor
        
        // Set default color based on appearance
        updateDefaultColorForAppearance()
        
        // Listen for appearance changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppearanceChange),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
        
        // Also observe effective appearance changes
        DistributedNotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppearanceChange),
            name: Notification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil
        )
        
        previousColor = selectedColor
    }

    @objc private func handleAppearanceChange() {
        updateDefaultColorForAppearance()
    }

    private func updateDefaultColorForAppearance() {
        let isDarkMode = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        
        // Set the first color based on appearance
        if !baseColor.isEmpty {
            if isDarkMode {
                // Use white in dark mode
                baseColor[0] = Color.white
            } else {
                // Use black in light mode
                baseColor[0] = Color.black
            }
        }
        
        // Update selected color if it was the default color
        if selectedColor == Color.white || selectedColor == Color.black {
            selectedColor = isDarkMode ? Color.white : Color.black
        }
    }

    // MARK: Color Rollback
    func colorRollback() {
        selectedColor = previousColor
    }

    // MARK: Append Color
    func appendColor() {
        colorPanelDelegate.openPanel()
    }

    // MARK: Delete Color
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

    // MARK: Add Color
    func setCustomizeColor(color: Color) {
        tempColor.append(color)
        var storeColor = AppSetter.shared.getCustomizeColor()
        if !(storeColor + baseColor).contains(color) {
            storeColor.append(color)
            AppSetter.shared.saveCustomizeColor(color: storeColor)
            AppSetter.shared.showToast(message: NSLocalizedString("Add Color Perpetual", comment: "")
                                       + ": " + color.toHex())
        }
    }

    // MARK: Erase at
    func eraseAt(location: CGPoint) {
        paths.removeAll { path in
            path.points.contains { point in
                let distance = hypot(point.x - location.x, point.y - location.y)
                return distance <= AppSetter.shared.lineWidth
            }
        }
    }
    
    // MARK: Undo
    func undo() {
        guard let lastPath = paths.popLast() else { return }
        redoStack.append(lastPath)
    }
    
    // MARK: Redo
    func redo() {
        guard let lastRedo = redoStack.popLast() else { return }
        paths.append(lastRedo)
    }
    
    // MARK: Shrink Canvas Window
    func shrinkWindow() {
        adjustWindowSize(deltaHeight: -40)
    }
    
    // MARK: Enlarge Canvas Window
    func enlargeWindow() {
        adjustWindowSize(deltaHeight: 40)
    }
    
    // MARK: Set Window
    private func adjustWindowSize(deltaHeight: CGFloat) {

        guard let screenFrame = NSScreen.main?.frame else { return }

        if let window = NSApplication.shared.windows.first(where: {
            $0.title == "Canvas"
        }) {
            var frame = window.frame

            let height = frame.height

            let newHeight = height + deltaHeight
            let newWidth = newHeight * (16.0 / 10.0)

            frame.size = CGSize(width: newWidth, height: newHeight)

            if newHeight <= 300 || newWidth <= 480 {
                frame.size = CGSize(width: 480, height: 300)
            }
            if newHeight > screenFrame.height || newWidth > screenFrame.width {
                frame.size = CGSize(width: screenFrame.width, height: screenFrame.height)
            }
            let x = (screenFrame.size.width - frame.width) / 2 + screenFrame.origin.x
            let y = (screenFrame.size.height - frame.height) / 2 + screenFrame.origin.y
            window.setFrame(NSRect(x: x, y: y, width: frame.width, height: frame.height),
                            display: true, animate: true)
        }
    }

}
