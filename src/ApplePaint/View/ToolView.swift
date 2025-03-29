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
    // MARK: Body
    var body: some View {
        VStack {
            ColorView()
                .environmentObject(appCanvas)
                .environmentObject(appSetter)
              
            Divider().frame(height: 2)
                .overlay {
                    Rectangle().foregroundStyle(.gray.opacity(0.6))
                }.cornerRadius(1)
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
    }
}
