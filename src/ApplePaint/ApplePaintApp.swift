//
//  ApplePaintApp.swift
//  ApplePaint
//
//  Created by Evaan Chowdhry on 2025-01-04.
//

import SwiftUI

struct VisualEffectBlur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .fullScreenUI
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

@main
struct ApplePaintApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                VisualEffectBlur()
                    .edgesIgnoringSafeArea(.all)
                ContentView()
            }
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .windowResizability(.contentSize)
    }
}
