//
//  ColorPanelDelegate.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/27.
//
import SwiftUI

class ColorPanelDelegate: NSObject {

    static var shared = ColorPanelDelegate()

    private var newColor: Color?
    private var colorAddingWorkItem: DispatchWorkItem?

    
    func openPanel() {
        let colorPanel = NSColorPanel.shared
        colorPanel.setTarget(self)
        colorPanel.setAction(#selector(colorPanelDidChangeColor(_:)))
        colorPanel.orderFront(nil)
        colorPanel.makeKeyAndOrderFront(nil)
    }

    
    @objc func colorPanelDidChangeColor(_ sender: NSColorPanel) {
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
                            "Color Already Exist", comment: "")
                            + ":    "
                            + newColor.toHex()
                            + "  "
                            + NSLocalizedString("Selected", comment: ""))
                } else {
                    // 暂时添加颜色
                    AppCanvas.shared.customizeColor.append(newColor)
                    AppSetter.shared.showToast(
                        message: NSLocalizedString(
                            "Temporarily Add Color", comment: "")
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
