//
//  FileHandler.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/29.
//

import AppKit
import SwiftUICore
import UniformTypeIdentifiers

private let saveFolder = NSLocalizedString("Save", comment: "选择保存位置")
private let saveSuccess = NSLocalizedString("Saved Successfully", comment: "保存成功")
private let saveFailed = NSLocalizedString("Save Failed", comment: "保存失败")
private let defaultFileName = "drawing"

// MARK: Select File return URL
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

// MARK: Open Canvas File .paint
func openCanvasFile() {
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    
    // Update to use the new UTType identifier
    if let paintType = UTType("com.applePaint.canvas") {
        panel.allowedContentTypes = [paintType]
    } else {
        panel.allowedContentTypes = [UTType(filenameExtension: "paint")!]
    }
    
    if panel.runModal() == .OK, let fileURL = panel.url {
        do {
            let fileData = try Data(contentsOf: fileURL)
            let decodedPaintData = JSON.decode(PaintData.self, from: fileData)
            if let paths = decodedPaintData?.paths {
                AppCanvas.shared.paths = paths.map { path in
                    (
                        color: Color(hex: path.color),
                        lineWidth: path.lineWidth, points: path.points
                    )
                }
            }
            AppCanvas.shared.currentPoints =
                decodedPaintData?.currentPoints ?? []
            if let redoStack = decodedPaintData?.redoStack {
                AppCanvas.shared.redoStack = redoStack.map { redoStack in
                    (
                        color: Color(hex: redoStack.color),
                        lineWidth: redoStack.lineWidth, points: redoStack.points
                    )
                }
            }
            AppCanvas.shared.fileUrl = fileURL
        } catch {
            AppSetter.shared.showToast(
                message: NSLocalizedString(
                    "Loading Failed", comment: "加载失败"))
        }
    }
}

// MARK: Save Canvas File .paint
func saveCanvasFile() {
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

    if AppCanvas.shared.fileUrl != nil {
        do {
            if try encode?.write(to: AppCanvas.shared.fileUrl!) != nil {
                AppSetter.shared.showToast( message: saveSuccess)
            }
        } catch {
            print(error)
            AppSetter.shared.showToast(
                message: saveFailed + error.localizedDescription
            )
        }
        return
    }

    let panel = NSSavePanel()
    panel.canCreateDirectories = true
    panel.nameFieldStringValue = defaultFileName
    panel.title = NSLocalizedString("Save Canvas", comment: "保存画布")
    panel.prompt = saveFolder
    
    // Update to use the new UTType identifier
    if let paintType = UTType("com.applePaint.canvas") {
        panel.allowedContentTypes = [paintType]
    } else {
        panel.allowedContentTypes = [UTType(filenameExtension: "paint")!]
    }
    
    panel.allowsOtherFileTypes = false
    panel.isExtensionHidden = false

    if panel.runModal() == .OK, let folderURL = panel.url {
        do {
            if try encode?.write(to: folderURL) != nil {
                AppSetter.shared.showToast(message: saveSuccess)
            }
        } catch {
            AppSetter.shared.showToast(
                message: saveFailed + error.localizedDescription
            )
        }
    }
}

// MARK: Export Drawing Data
func exportPaint(exportFormat: ExportFormat) {
    AppSetter.shared.showToolView = false
    guard
        let window = NSApplication.shared.windows.first(where: {
            $0.identifier?.rawValue == "canvas"
        })
    else { return }
    guard let contentView = window.contentView else {
        return
    }
    let size = contentView.bounds.size
    let image = NSImage(size: size)
    let bitmapRep = contentView.bitmapImageRepForCachingDisplay(
        in: contentView.bounds)
    let panel = NSSavePanel()
    panel.canCreateDirectories = true
    panel.nameFieldStringValue = defaultFileName
    panel.title = NSLocalizedString("Save As Image", comment: "Save As Image")
    panel.prompt = saveFolder
    
    let appending: String
    let filetype: NSBitmapImageRep.FileType
    
    switch exportFormat {
    case .Png:
        filetype = .png
        appending = "png"
        panel.allowedContentTypes = [UTType(filenameExtension: "png")!]
    case .Jpeg:
        filetype = .jpeg
        appending = "jpeg"
        panel.allowedContentTypes = [UTType(filenameExtension: "jpeg")!]
    case .Tiff:
        filetype = .tiff
        appending = "tiff"
        panel.allowedContentTypes = [UTType(filenameExtension: "tiff")!]
    }
    
    panel.allowsOtherFileTypes = false
    panel.isExtensionHidden = false
    
    // Must wait for the main thread, view to update
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        contentView.cacheDisplay(in: contentView.bounds, to: bitmapRep!)
        AppSetter.shared.showToolView = true
    }
    image.addRepresentation(bitmapRep!)

    if panel.runModal() == .OK, let fileURL = panel.url {
        do {
            if let tiffRepresentation = image.tiffRepresentation,
                let bitmap = NSBitmapImageRep(data: tiffRepresentation),
                let data = bitmap.representation(
                    using: filetype, properties: [:])
            {
                try data.write(to: fileURL)
                AppSetter.shared.showToast(message: saveSuccess)
            }
        } catch {
            AppSetter.shared.showToast(
                message: saveFailed + error.localizedDescription
            )
        }
    }
}
