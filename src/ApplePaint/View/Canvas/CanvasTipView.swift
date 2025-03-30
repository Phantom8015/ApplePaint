//
//  CanvasTipView.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/30.
//


import SwiftUI

struct CanvasTipView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Texts(
                label: NSLocalizedString(
                    "Double clicking a color ",
                    comment: "双击任一颜色")
                    + NSLocalizedString(
                        "opens the Color Panel", comment: "打开颜色面板"))
            Texts(
                label: NSLocalizedString(
                    "Right Click a color for more features",
                    comment: "更多功能 右键任一颜色"))
            Texts(
                label: NSLocalizedString(
                    "Hold Shift to Draw a Straight Line",
                    comment: "长按Shift画直线"))
            Divider()
            Texts(
                label: " ⌘ c  "
                    + NSLocalizedString(
                        "Open Canvas Window", comment: "打开画布"))
            Texts(
                label: " ⌘ f  "
                    + NSLocalizedString(
                        "Open Color Panel", comment: "打开颜色面板"))
            Texts(
                label: " ⌥ 1 ... 5  to "
                    + NSLocalizedString(
                        "Pick Color", comment: "选择颜色"))
            Texts(
                label: " ⇧ 1 ... 10  to "
                    + NSLocalizedString(
                        "Choose Thickness", comment: "选择画笔粗细"))
            Texts(
                label: " ⌘ e  "
                    + NSLocalizedString(
                        "Eraser", comment: "橡皮擦"))
            Texts(
                label: " ⌘ ⇧ c  "
                    + NSLocalizedString(
                        "Clear All", comment: "清空画布"))
            Texts(
                label: " ⌘ 1 ... 2  "
                    + NSLocalizedString(
                        "Bring Window to Front", comment: "置顶窗口"
                    ))
        }.frame(width: 320)
    }
}

#Preview {
    CanvasTipView()
}
