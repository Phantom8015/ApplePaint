//
//  FileHandler.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/29.
//

import AppKit
import UniformTypeIdentifiers
import SwiftUICore


func selectFile(type: [UTType]) -> URL? {
    let panel = NSOpenPanel()
    panel.allowedContentTypes = type
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    panel.canCreateDirectories = false

    if panel.runModal() == .OK, let url = panel.urls.first {
        return url
    }
    return nil
}

// TODO 导出 Json 导入 Json、导出图片
func saveFileToFolder() {
    let panel = NSSavePanel()
    panel.directoryURL =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first
    panel.canCreateDirectories = true
    panel.nameFieldStringValue = "drawing"
    panel.title = NSLocalizedString("Save Canvas", comment: "保存画布")
    panel.prompt = NSLocalizedString(
        "Select The Folder to Save", comment: "选择保存位置")

    if panel.runModal() == .OK, let folderURL = panel.url {
        do {
            if AppCanvas.shared.paths.isEmpty {
                AppSetter.shared.showToast(
                    message: NSLocalizedString(
                        "No Content", comment: "没有内容")
                )
                return
            }
            let pathsData = AppCanvas.shared.paths.map {
                PaintPath(
                    color: $0.color.toHex(), lineWidth: $0.lineWidth,
                    points: $0.points)
            }
            let redoStackData = AppCanvas.shared.redoStack.map {
                PaintPath(
                    color: $0.color.toHex(), lineWidth: $0.lineWidth,
                    points: $0.points)
            }
            let paintData = PaintData(
                paths: pathsData,
                currentPoints: AppCanvas.shared.currentPoints,
                redoStack: redoStackData)
            let encode = JSON.encode(paintData)
            let fileURL = folderURL.appendingPathExtension("paint")
            if try encode?.write(to: fileURL) != nil {
                AppSetter.shared.showToast(
                    message: NSLocalizedString(
                        "Save Successfully", comment: "保存成功"))
            }
        } catch {
            print(error)
            AppSetter.shared.showToast(
                message: NSLocalizedString(
                    "Save Failed", comment: "保存失败") + error.localizedDescription
            )
        }
    }
}

func openFileToFolder() {
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    if panel.runModal() == .OK, let fileURL = panel.url {
        do {
            let fileData = try Data(contentsOf: fileURL)
            let decodedPaintData = JSON.decode(PaintData.self, from: fileData)
            if let paths = decodedPaintData?.paths {
                AppCanvas.shared.paths = paths.map { path in
                    (color: Color(hex: path.color), lineWidth: path.lineWidth, points: path.points)
                }
            }
            AppCanvas.shared.currentPoints = decodedPaintData?.currentPoints ?? []
            if let redoStack = decodedPaintData?.redoStack {
                AppCanvas.shared.redoStack = redoStack.map { redoStack in
                    (color: Color(hex: redoStack.color), lineWidth: redoStack.lineWidth, points: redoStack.points)
                }
            }
        } catch {
            AppSetter.shared.showToast(
                message: NSLocalizedString(
                    "Loading Failed", comment: "加载失败"))
        }
    }
}
