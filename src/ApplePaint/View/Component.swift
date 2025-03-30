//
//  Component.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/29.
//

import SwiftUI

// MARK: Toggle
struct Toggles: View {
    let label: String
    @Binding var action: Bool
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Toggle("", isOn: $action)
                .toggleStyle(.switch)
                .labelsHidden()
        }
    }
}

// MARK: Texts
struct Texts:View {
    let label:String
    var body: some View {
        HStack{
            Text(label)
                .foregroundStyle(AppCanvas.shared.selectedColor)
        }
    }
}
