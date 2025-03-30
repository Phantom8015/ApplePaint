//
//  ToolView.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/27.
//

import SwiftUI

struct ToolView:View {
    
    @EnvironmentObject var appCanvas: AppCanvas
    @EnvironmentObject var appSetter: AppSetter
    
    var body: some View {
        VStack {
            ColorView()
                .environmentObject(appCanvas)
                .environmentObject(appSetter)
              
            ToolItemView()
                .environmentObject(appCanvas)
                .environmentObject(appSetter)
        }
        .onHover{_ in
            if let window = NSApplication.shared.windows.first(
                where: {
                    $0.identifier?.rawValue == "tools"
                })
            {
                window.orderFront(nil)
                window.makeKeyAndOrderFront(nil)
            }
        }
        .padding(.vertical)
        .frame(width: 48)
        .frame(maxHeight: .infinity)
        .background {
            switch appSetter.canvasBackground {
            case .VisualEffectBlur:
                VisualEffectBlur()
            case .Colorful:
                Color(hex: appSetter.colorBackgourd)
            case .Picture:
                Color.clear
            case .Customize:
                Color.clear
            }
        }
    }
}
