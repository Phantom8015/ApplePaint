//
//  AppSetting.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/27.
//

import SwiftUI

class AppSetter: ObservableObject {

    static var shared = AppSetter()

    // MARK: 设置
    @AppStorage("hiddenUndoRedoTool") var hiddenUndoRedoTool = false
    @AppStorage("hiddenEraserTool") var hiddenEraserTool = false
    @AppStorage("hiddenClearTool") var hiddenClearTool = false
    @AppStorage("hiddenBackgroudTool") var hiddenBackgroudTool = false

    // MARK: Canvas
    // 存储永久保存的颜色的数据
    @AppStorage("customizeColorSet") private var CustomizeColorSet = Data()
    // 线条
    @AppStorage("lineWidth") var lineWidth: Double = 6.0

    // MARK: 背景
    let canvasBackgroudColorSet: [Color] = [
        Color(hex: "#ebfef1"), Color(hex: "#ffeff7"), Color(hex: "#fee6e4"),
        Color(hex: "#fefeee"), Color(hex: "#f8feef"), Color(hex: "#edffed"),
        Color(hex: "#f3fefc"), Color(hex: "#e8f4fe"), Color(hex: "#f3f2ff"),
        Color(hex: "#faf1ff"), Color(hex: "#ffebfe"), Color(hex: "#fff1fc"),
        Color(hex: "#020000"), Color(hex: "#001616"), Color(hex: "#001902"),
        Color(hex: "#130011"), Color(hex: "#0e002e"), Color(hex: "#351700"),
    ]
    // 缩放至填充
    @AppStorage("scaledToFill") var scaledToFill = false
    // 背景选择 VisualEffectBlur, Colorful, Picture, Customize
    @AppStorage("backgroudType") var canvasBackground: CanvasBackground = .VisualEffectBlur
    // 选择 颜色作为背景
    @AppStorage("colorBackgroud") var colorBackgourd = "#ebfef1"
    // 选择 app 图片作为背景
    @AppStorage("pictureBackgroud") var pictureBackgroud = "blackboard1"
    // 自定义图片背景
    @AppStorage("customizePicture") var customizePicture = Data()
    
    // MARK: 状态
    // Hover
    @Published var showLineWidthPicker = false
    @Published var showBackgroud = false
    // Toast
    @Published var showToast = false
    @Published var toastMessage = ""
    
    // MARK: 存储颜色
    func saveCustomizeColor(color: [Color]) {
        if let encodedData = JSON.encode(
            color.map {
                $0.toHex()
            })
        {
            CustomizeColorSet = encodedData
        }
    }

    // MARK: 获取保存的颜色
    func getCustomizeColor() -> [Color] {
        if let decodedData = JSON.decode([String].self, from: CustomizeColorSet)
        {
            return decodedData.map { item in
                Color(hex: item)
            }
        }
        return []
    }

    // MARK: 显示 Toast 方法
    func showToast(message: String) {
        toastMessage = message
        showToast.toggle()
    }

    // MARK: 显示 hover 方法
    func hoverHandler(target: HoverHandler) {
        switch target {
        case .Thickness:
            self.showBackgroud = false
            self.showLineWidthPicker = true
        case .Backgroud:
            self.showLineWidthPicker = false
            self.showBackgroud = true
        }
    }
}
