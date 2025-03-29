//
//  VisualEffectBlur.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/26.
//

import SwiftUI

struct VisualEffectBlur: NSViewRepresentable {
    
    // MARK: 视觉效果视图
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .fullScreenUI
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
