//
//  SettingView.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/26.
//

import SwiftUI

struct SettingView: View {

    @EnvironmentObject var appSetter: AppSetter
    
    var body: some View {
        LazyVStack {
            VStack(alignment: .leading) {
                Text(NSLocalizedString("Tool", comment: ""))
                    .fontWeight(.bold).font(.subheadline)
                    .foregroundColor(Color.gray)
                    .padding(.leading, 8)
                VStack {
                    Toggles(
                        label: NSLocalizedString(
                            "Hide Undo Redo", comment: ""),
                        action: $appSetter.hiddenUndoRedoTool)
                    Toggles(
                        label: NSLocalizedString(
                            "Hide Eraser", comment: ""),
                        action: $appSetter.hiddenEraserTool)
                    Toggles(
                        label: NSLocalizedString(
                            "Hide Clear Tool", comment: ""),
                        action: $appSetter.hiddenClearTool)
                    Toggles(
                        label: NSLocalizedString(
                            "Hide Backgroud Tool", comment: ""),
                        action: $appSetter.hiddenBackgroudTool)
                }
                .padding(8)
                .background(Color("CardView"))
                .cornerRadius(8)
                .shadow(color: .gray.opacity(0.5), radius: 0.4)
            }
        }.frame(width: 320).padding()
    }
}

#Preview {
    SettingView()
        .environmentObject(AppSetter.shared)
}

