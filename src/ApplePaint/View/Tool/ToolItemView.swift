//
//  ToolView.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/26.
//

import SwiftUI

struct ToolItemView: View {

    @EnvironmentObject var appCanvas: AppCanvas
    @EnvironmentObject var appSetter: AppSetter
    @State private var showBackgroud = false
    @State private var showLineWidthPicker = false

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 24) {
                Image(systemName: "scribble.variable")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.accentColor)
                    .onHover { _ in
                        showBackgroud = false
                        showLineWidthPicker = true
                    }
                    .popover(isPresented: $showLineWidthPicker) {
                        HStack {
                            Slider(
                                value: $appSetter.lineWidth, in: 1...20, step: 1
                            )
                            .frame(width: 240)
                            Text(String(describing: Int(appSetter.lineWidth)))
                                .frame(width: 24)
                        }
                        .padding()
                        .onHover { hovering in
                            showBackgroud = false
                            showLineWidthPicker =  hovering
                        }
                        .onDisappear {
                            showLineWidthPicker = false
                        }
                    }
                
                // MARK: Undo Redo
                if !appSetter.hiddenUndoRedoTool {
                    Image(systemName: "arrow.uturn.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            appCanvas.undo()
                            appSetter.showToast(
                                message: NSLocalizedString(
                                    "Undo", comment: "Undo"))
                        }

                    Image(systemName: "arrow.uturn.forward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            appCanvas.redo()
                            appSetter.showToast(
                                message: NSLocalizedString(
                                    "Redo", comment: "Redo"))
                        }
                }
                // MARK: Eraser
                if !appSetter.hiddenEraserTool {
                    Image(systemName: "eraser")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(
                            appCanvas.isErasing ? .red : .accentColor
                        )
                        .onTapGesture {
                            appCanvas.isErasing.toggle()
                            if appCanvas.isErasing {
                                appSetter.showToast(
                                    message: NSLocalizedString(
                                        "Enable Eraser",
                                        comment: "Enable Eraser"))
                            } else {
                                appSetter.showToast(
                                    message: NSLocalizedString(
                                        "Disable Eraser",
                                        comment: "Disable Eraser"))
                            }
                        }
                }
                // MARK: Clear All
                if !appSetter.hiddenClearTool {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.red)
                        .onTapGesture {
                            appCanvas.paths = []
                            appCanvas.redoStack = []
                            appCanvas.currentPoints = []
                            appSetter.showToast(
                                message: NSLocalizedString(
                                    "Clear All", comment: "Clear All"))
                        }
                }
                // MARK: Backgroud
                if !appSetter.hiddenBackgroudTool {
                    Image(systemName: "apple.image.playground")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.accentColor)
                        .onHover { _ in
                            showLineWidthPicker = false
                            showBackgroud = true
                        }
                        .popover(
                            isPresented: $showBackgroud
                        ) {
                            CanvasBackgroudView()
                                .onHover { hovering in
                                    showLineWidthPicker = false
                                    showBackgroud = hovering
                                }
                                .onDisappear {
                                    showBackgroud = false
                                }
                        }
                }
            }
        }
    }
}

#Preview {
    ToolItemView()
        .environmentObject(AppCanvas.shared)
        .environmentObject(AppSetter.shared)
}
