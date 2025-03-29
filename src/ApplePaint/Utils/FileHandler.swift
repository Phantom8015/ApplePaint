//
//  FileHandler.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/29.
//

import AppKit
import UniformTypeIdentifiers


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
