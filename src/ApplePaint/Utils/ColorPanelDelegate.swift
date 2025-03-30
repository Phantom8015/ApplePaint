//
//  ColorPanelDelegate.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/27.
//
import SwiftUI

class ColorPanelDelegate: NSObject {

    static var shared = ColorPanelDelegate()

    // MARK: Properties
    private var newColor: Color?
    private var colorAddingWorkItem: DispatchWorkItem?

    // MARK: Open Color Panel
    func openPanel() {
        let colorPanel = NSColorPanel.shared
        colorPanel.setTarget(self)
        colorPanel.setAction(#selector(colorPanelDidChangeColor(_:)))
        colorPanel.orderFront(nil)
        colorPanel.makeKeyAndOrderFront(nil)
    }

    // MARK: NSColorPanel
    @objc private func colorPanelDidChangeColor(_ sender: NSColorPanel) {
        newColor = Color(nsColor: sender.color)
        if let newColor = newColor {
            AppCanvas.shared.previousColor = AppCanvas.shared.selectedColor
            AppCanvas.shared.selectedColor = newColor

            colorAddingWorkItem?.cancel()
            let workItem = DispatchWorkItem {
                if (AppCanvas.shared.customizeColor + AppCanvas.shared.baseColor)
                    .contains(newColor)
                {
                    AppCanvas.shared.selectedColor = newColor
                    AppSetter.shared.showToast(
                        message: NSLocalizedString(
                            "Color Already Exists", comment: "")
                            + ":    "
                            + newColor.toHex()
                            + "  "
                            + NSLocalizedString("Selected", comment: ""))
                } else {
                    // 暂时添加颜色
                    AppCanvas.shared.customizeColor.append(newColor)
                    AppSetter.shared.showToast(
                        message: NSLocalizedString(
                            "Color Temporarily Added", comment: "")
                            + ":    "
                            + newColor.toHex())
                }
            }
            colorAddingWorkItem = workItem
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.6, execute: workItem)
        }
    }
}
