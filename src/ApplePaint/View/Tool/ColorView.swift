//
//  ColorView.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/26.
//

import SwiftUI

struct ColorView: View {

    @EnvironmentObject var appCanvas: AppCanvas
    @EnvironmentObject var appSetter: AppSetter

    // MARK: Body
    var body: some View {
        VStack(spacing: 8) {
            ForEach(
                (appCanvas.baseColor + appCanvas.customizeColor), id: \.self
            ) { color in
                color
                    .frame(width: 20, height: 20).cornerRadius(12)
                    .simultaneousGesture(
                        TapGesture(count: 1)
                            .onEnded {
                                appCanvas.previousColor =
                                    appCanvas.selectedColor
                                appCanvas.selectedColor = color
                                appCanvas.isErasing = false
                                appSetter.showToast(
                                    message: NSLocalizedString(
                                        "Pick Color: ", comment: "选择颜色:")
                                        + appCanvas.selectedColor.toHex())
                            }
                    )
                    .simultaneousGesture(
                        TapGesture(count: 2)
                            .onEnded {
                                appCanvas.appendColor()
                                appSetter.showToast(
                                    message: NSLocalizedString(
                                        "Open Color Panel", comment: "打开颜色面板"))
                            }
                    )
                    .contextMenu {
                        Button(
                            action: {
                                appCanvas.deleteCustomizeColor(color: color)
                                appSetter.showToast(
                                    message: NSLocalizedString(
                                        "Remove Color", comment: "删除颜色"))
                            },
                            label: {
                                Text(
                                    NSLocalizedString(
                                        "Remove Color", comment: "删除颜色"))
                            })
                        Button(
                            action: {
                                let pasteBoard = NSPasteboard.general
                                pasteBoard.clearContents()
                                pasteBoard.setString(
                                    color.toHex(),
                                    forType: .string)
                                appSetter.showToast(
                                    message: NSLocalizedString(
                                        "Copy Color", comment: "拷贝颜色 Hex")
                                + ": " + color.toHex())
                            },
                            label: {
                                Text(
                                    NSLocalizedString(
                                        "Copy Color", comment: "拷贝颜色 Hex"))
                            })
                        if !(appCanvas.baseColor + appCanvas.tempColor)
                            .contains(color)
                        {
                            Button(
                                action: {
                                    appCanvas.setCustomizeColor(color: color)
                                    appSetter.showToast(
                                        message: NSLocalizedString(
                                            "Add Color Perpetual",
                                            comment: "添加颜色")
                                            + ":    "
                                            + color.toHex())
                                },
                                label: {
                                    Text(
                                        NSLocalizedString(
                                            "Add Color Perpetual",
                                            comment: "添加颜色"))
                                })
                        }
                    }
            }
        }
    }
}

#Preview {
    ColorView()
        .environmentObject(AppCanvas.shared)
}
