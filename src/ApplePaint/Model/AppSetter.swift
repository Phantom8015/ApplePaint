//
//  AppSetting.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/27.
//



import SwiftUI

class AppSetter: ObservableObject {

    static var shared = AppSetter()

    // MARK: Settings
    @AppStorage("hiddenUndoRedoTool") var hiddenUndoRedoTool = false
    @AppStorage("hiddenEraserTool") var hiddenEraserTool = false
    @AppStorage("hiddenClearTool") var hiddenClearTool = false
    @AppStorage("hiddenBackgroudTool") var hiddenBackgroudTool = false

    // MARK: Color and Thickness
    @AppStorage("customizeColorSet") private var CustomizeColorSet = Data()
    @AppStorage("lineWidth") var lineWidth: Double = 6.0


    // MARK: Default Color Background
    let canvasBackgroudColorSet: [Color] = [
        Color(hex: "#ebfef1"), Color(hex: "#ffeff7"), Color(hex: "#fee6e4"),
        Color(hex: "#fefeee"), Color(hex: "#f8feef"), Color(hex: "#edffed"),
        Color(hex: "#f3fefc"), Color(hex: "#e8f4fe"), Color(hex: "#f3f2ff"),
        Color(hex: "#faf1ff"), Color(hex: "#ffebfe"), Color(hex: "#fff1fc"),
        Color(hex: "#020000"), Color(hex: "#001616"), Color(hex: "#001902"),
        Color(hex: "#130011"), Color(hex: "#0e002e"), Color(hex: "#351700"),
    ]
    
    // MARK: BackGroud Setting
    @AppStorage("scaledToFill") var scaledToFill = false
    @AppStorage("backgroudType") var canvasBackground: CanvasBackground = .VisualEffectBlur
    @AppStorage("colorBackgroud") var colorBackgourd = "#ebfef1"
    @AppStorage("pictureBackgroud") var pictureBackgroud = "blackboard1"
    @AppStorage("customizePicture") var customizePicture = Data()
    
    // MARK: Temporary
    @Published var showToolView = true
    @Published var showToast = false
    @Published var toastMessage = ""
    private var toastQueue: [String] = []
    private var toastTimer: Timer?
    
    // MARK: Save Color
    func saveCustomizeColor(color: [Color]) {
        if let encodedData = JSON.encode(
            color.map {
                $0.toHex()
            })
        {
            CustomizeColorSet = encodedData
        }
    }

    // MARK: Get Color
    func getCustomizeColor() -> [Color] {
        if let decodedData = JSON.decode([String].self, from: CustomizeColorSet)
        {
            return decodedData.map { item in
                Color(hex: item)
            }
        }
        return []
    }

    // MARK: Show Toast
    func showToast(message: String) {
        toastQueue.append(message)
        processNextToast()
    }
    
    // MARK: Toast Process
    private func processNextToast() {
        
        toastTimer?.invalidate()
        
        if toastQueue.isEmpty {
            showToast = false
            return
        }
        
        
        toastMessage = toastQueue.removeFirst()
        showToast = true
        
        
        toastTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            self?.processNextToast()
        }
    }
}
