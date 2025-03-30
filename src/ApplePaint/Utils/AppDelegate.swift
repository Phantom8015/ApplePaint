//
//  AppDelegate.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/29.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationWillTerminate(_ notification: Notification) {
        DispatchQueue.main.async {
            NSColorPanel.shared.orderOut(nil)
        }
    }
}
