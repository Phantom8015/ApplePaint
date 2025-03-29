//
//  SettingView.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/26.
//

import SwiftUI

struct SettingView: View {

    @EnvironmentObject var appSetter: AppSetter
    // MARK: Body
    var body: some View {
        LazyVStack {
            // Top
            VStack(alignment: .leading) {
                Text(NSLocalizedString("Tool", comment: "工具"))
                    .fontWeight(.bold).font(.subheadline)
                    .foregroundColor(Color.gray)
                    .padding(.leading, 8)
                VStack {
                    Toggles(
                        label: NSLocalizedString(
                            "Hidden UndoRedo", comment: "隐藏 撤回按钮组"),
                        action: $appSetter.hiddenUndoRedoTool)
                    Toggles(
                        label: NSLocalizedString(
                            "Hidden Eraser", comment: "隐藏 橡皮擦"),
                        action: $appSetter.hiddenEraserTool)
                    Toggles(
                        label: NSLocalizedString(
                            "Hidden Clear Tool", comment: "隐藏清空"),
                        action: $appSetter.hiddenClearTool)
                    Toggles(
                        label: NSLocalizedString(
                            "Hidden BackGroud Tool", comment: "隐藏背景"),
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

