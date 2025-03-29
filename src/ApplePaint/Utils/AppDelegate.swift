//
//  AppDelegate.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/29.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: 取消 NSColorPanel
    func applicationWillTerminate(_ notification: Notification) {
        // 在应用退出时执行
        DispatchQueue.main.async {
            NSColorPanel.shared.orderOut(nil)
        }
    }
}
