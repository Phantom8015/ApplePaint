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

    var body: some View {
        VStack(spacing: 8) {
            ForEach(
                (appCanvas.baseColor + appCanvas.customizeColor), id: \.self
            ) { color in
                color
                    .frame(width: 16, height: 16).cornerRadius(8)
                    .simultaneousGesture(
                        TapGesture(count: 1)
                            .onEnded {
                                appCanvas.previousColor =
                                    appCanvas.selectedColor
                                appCanvas.selectedColor = color
                                appCanvas.isErasing = false
                                appSetter.showToast(
                                    message: NSLocalizedString(
                                        "Pick Color: ", comment: "Pick Color: ")
                                        + appCanvas.selectedColor.toHex())
                            }
                    )
                    .simultaneousGesture(
                        TapGesture(count: 2)
                            .onEnded {
                                appCanvas.appendColor()
                                appSetter.showToast(
                                    message: NSLocalizedString(
                                        "Open Color Panel", comment: "Open Color Panel"))
                            }
                    )
                    .contextMenu {
                        Button(
                            action: {
                                appCanvas.deleteCustomizeColor(color: color)
                                appSetter.showToast(
                                    message: NSLocalizedString(
                                        "Remove Color", comment: "Remove Color"))
                            },
                            label: {
                                Text(
                                    NSLocalizedString(
                                        "Remove Color", comment: "Remove Color"))
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
                                        "Copy Color", comment: "Copy Color Hex")
                                + ": " + color.toHex())
                            },
                            label: {
                                Text(
                                    NSLocalizedString(
                                        "Copy Color", comment: "Copy Color Hex"))
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
                                            comment: "Add Color")
                                            + ":    "
                                            + color.toHex())
                                },
                                label: {
                                    Text(
                                        NSLocalizedString(
                                            "Add Color Perpetual",
                                            comment: "Add Color"))
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
