//
//  ApplePaintApp.swift
//  ApplePaint
//
//  Created by Evaan Chowdhry on 2025-01-04.
//

import AlertToast
import SwiftUI

@main
struct ApplePaintApp: App {

    @Environment(\.openWindow) var openWindow
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appCanvas = AppCanvas.shared
    @StateObject var appSetter = AppSetter.shared
    
    let undo = NSLocalizedString("Undo", comment: "")
    let redo = NSLocalizedString("Redo", comment: "")
    let eraser = NSLocalizedString("Eraser", comment: "")
    let enableEraser = NSLocalizedString("Enable Eraser", comment: "")
    let disableEraser = NSLocalizedString("Disable Eraser", comment: "")
    let clearAll = NSLocalizedString("Clear All", comment: "")
    let colorRollBack = NSLocalizedString("Color RollBack", comment: "")
    let addColorPerpetual = NSLocalizedString("Add Color Perpetual", comment: "")
    let removeColor = NSLocalizedString("Remove Color", comment: "")
    let thickness = NSLocalizedString("Thickness", comment: "")
    let thickness1 = NSLocalizedString("Thickness 1", comment: "")
    let thickness2 = NSLocalizedString("Thickness 2", comment: "")
    let thickness3 = NSLocalizedString("Thickness 3", comment: "")
    let thickness4 = NSLocalizedString("Thickness 4", comment: "")
    let thickness5 = NSLocalizedString("Thickness 5", comment: "")
    let thickness6 = NSLocalizedString("Thickness 6", comment: "")
    let thickness7 = NSLocalizedString("Thickness 7", comment: "")
    let thickness8 = NSLocalizedString("Thickness 8", comment: "")
    let thickness9 = NSLocalizedString("Thickness 9", comment: "")
    let thickness10 = NSLocalizedString("Thickness 10", comment: "")
    let pickColor = NSLocalizedString("Pick Color", comment: "")
    let selectedColor = NSLocalizedString("Pick Color: ", comment: "")
    let openCanvasWindow = NSLocalizedString("Open Canvas Window", comment: "")
    let openColorPanel = NSLocalizedString("Open Color Panel", comment: "")
    let bringCanvasToFront = NSLocalizedString("Bring Canvas to Front", comment: "")
    let bringColorPanelToFront = NSLocalizedString("Bring Color Panel to Front", comment: "")
    let enlargeSize = NSLocalizedString("Enlarge Canvas Size", comment: "")
    let shrinkSize = NSLocalizedString("Shrink Canvas Size", comment: "")

    
    var body: some Scene {
        Group {
            Window("Canvas", id: "canvas") {
                CanvasView()
                    .environmentObject(appCanvas)
                    .environmentObject(appSetter)
                    .edgesIgnoringSafeArea(.all)
                    .toast(isPresenting: $appSetter.showToast) {
                        AlertToast(
                            displayMode: .hud, type: .regular, title: appSetter.toastMessage)
                    }
                    .onAppear {
                        let _ = NSApplication.shared.windows.map { window in
                            window.tabbingMode = .disallowed
                        }
                        DispatchQueue.main.async {
                            openWindow(id: "canvas")
                        }
                    }
            }
            .windowStyle(.hiddenTitleBar)
            .windowToolbarStyle(.unified)
            .windowResizability(.contentSize)
        }
        .commands {
            
            CommandGroup(replacing: .newItem) {}
            // MARK: Save
            CommandGroup(replacing: .saveItem){
                Button(
                    action: {
                        saveFileToFolder()
                    },
                    label: {
                        Text(NSLocalizedString("Save Canvas", comment: "保存画布"))
                    }
                ).keyboardShortcut("s", modifiers: .command)
                Button(
                    action: {
                        openFileToFolder()
                    },
                    label: {
                        Text(NSLocalizedString("Open Canvas", comment: "打开画布"))
                    }
                ).keyboardShortcut("o", modifiers: .command)
            }
            // MARK: UndoRedo
            CommandGroup(replacing: .undoRedo) {
                Button(
                    action: {
                        appCanvas.undo()
                        appSetter.showToast(message: undo)
                    },
                    label: {
                        Text(undo)
                    }
                ).keyboardShortcut("z", modifiers: .command)

                Button(
                    action: {
                        appCanvas.redo()
                        appSetter.showToast(message: redo)
                    },
                    label: {
                        Text(redo)
                    }
                ).keyboardShortcut("z", modifiers: [.command, .shift])

                Button(
                    action: {
                        appCanvas.isErasing.toggle()
                        if appCanvas.isErasing{
                            appSetter.showToast(message: NSLocalizedString("Enable Eraser", comment: "打开橡皮擦"))
                        }else{
                            appSetter.showToast(message: NSLocalizedString("Unenable Eraser", comment: "关闭橡皮擦"))
                        }
                    },
                    label: {
                        Text(NSLocalizedString("Eraser", comment: "橡皮擦"))
                    }
                ).keyboardShortcut("e", modifiers: .command)

                Button(
                    action: {
                        appCanvas.paths = []
                        appCanvas.redoStack = []
                        appCanvas.currentPoints = []
                        appSetter.showToast(message: clearAll)
                    },
                    label: {
                        Text(clearAll)
                    }
                ).keyboardShortcut("c", modifiers: [.command, .shift])

                Divider()
                Button(
                    action: {
                        appCanvas.colorRollback()
                        appSetter.showToast(message: colorRollBack)
                    },
                    label: {
                        Text(colorRollBack)
                    }
                ).keyboardShortcut("b", modifiers: .option)

                Button(
                    action: {
                        appCanvas.setCustomizeColor(color: appCanvas.selectedColor)
                        appSetter.showToast(message: addColorPerpetual)
                    },
                    label: {
                        Text(addColorPerpetual)
                    }
                ).keyboardShortcut("a", modifiers: .option)

                Button(
                    action: {
                        appCanvas.deleteCustomizeColor(
                            color: appCanvas.selectedColor)
                        appCanvas.selectedColor =
                            appCanvas.customizeColor.first
                            ?? appCanvas.tempColor.first
                            ?? appCanvas.baseColor.first!
                        appSetter.showToast(message: removeColor)
                    },
                    label: {
                        Text(removeColor)
                    }
                ).keyboardShortcut("r", modifiers: .option)

            }
            
            CommandGroup(replacing: .pasteboard) {
                Menu(NSLocalizedString("Thickness", comment: "画笔粗细")) {
                    Button(
                        action: {
                            appSetter.lineWidth = 1
                            appSetter.showToast(message: thickness1)
                        },
                        label: {
                            Text(thickness1)
                        }
                    ).keyboardShortcut("1", modifiers: .shift)
                    Button(
                        action: {
                            appSetter.lineWidth = 2
                            appSetter.showToast(message: thickness2)
                        },
                        label: {
                            Text(thickness2)
                        }
                    ).keyboardShortcut("2", modifiers: .shift)
                    Button(
                        action: {
                            appSetter.lineWidth = 3
                            appSetter.showToast(message: thickness3)
                        },
                        label: {
                            Text(thickness3)
                        }
                    ).keyboardShortcut("3", modifiers: .shift)
                    Button(
                        action: {
                            appSetter.lineWidth = 4
                            appSetter.showToast(message: thickness4)
                        },
                        label: {
                            Text(thickness4)
                        }
                    ).keyboardShortcut("4", modifiers: .shift)
                    Button(
                        action: {
                            appSetter.lineWidth = 5
                            appSetter.showToast(message: thickness5)
                        },
                        label: {
                            Text(thickness5)
                        }
                    ).keyboardShortcut("5", modifiers: .shift)
                    Button(
                        action: {
                            appSetter.lineWidth = 6
                            appSetter.showToast(message: thickness6)
                        },
                        label: {
                            Text(thickness6)
                        }
                    ).keyboardShortcut("6", modifiers: .shift)
                    Button(
                        action: {
                            appSetter.lineWidth = 7
                            appSetter.showToast(message: thickness7)
                        },
                        label: {
                            Text(thickness7)
                        }
                    ).keyboardShortcut("7", modifiers: .shift)
                    Button(
                        action: {
                            appSetter.lineWidth = 8
                            appSetter.showToast(message: thickness8)
                        },
                        label: {
                            Text(thickness8)
                        }
                    ).keyboardShortcut("8", modifiers: .shift)
                    Button(
                        action: {
                            appSetter.lineWidth = 9
                            appSetter.showToast(message: thickness9)
                        },
                        label: {
                            Text(thickness9)
                        }
                    ).keyboardShortcut("9", modifiers: .shift)
                    Button(
                        action: {
                            appSetter.lineWidth = 10
                            appSetter.showToast(message: thickness10)
                        },
                        label: {
                            Text(thickness10)
                        }
                    ).keyboardShortcut("0", modifiers: .shift)

                }
                Menu(pickColor) {
                    Button(
                        action: {
                            appCanvas.selectedColor =
                                (appCanvas.customizeColor
                                + appCanvas.tempColor
                                + appCanvas.baseColor).first!
                            appSetter.showToast(message: selectedColor + appCanvas.selectedColor.toHex())
                        },
                        label: {
                            Text(pickColor + "  1")
                        }
                    ).keyboardShortcut("1", modifiers: .option)
                    Button(
                        action: {
                            appCanvas.selectedColor =
                                (appCanvas.customizeColor
                                + appCanvas.tempColor
                                + appCanvas.baseColor)[1]
                            appSetter.showToast(message: selectedColor + appCanvas.selectedColor.toHex())
                        },
                        label: {
                            Text(pickColor + "  2")
                        }
                    ).keyboardShortcut("2", modifiers: .option)
                    Button(
                        action: {
                            appCanvas.selectedColor =
                                (appCanvas.customizeColor
                                + appCanvas.tempColor
                                + appCanvas.baseColor)[2]
                            appSetter.showToast(message: selectedColor + appCanvas.selectedColor.toHex())
                        },
                        label: {
                            Text(pickColor + "  3")
                        }
                    ).keyboardShortcut("3", modifiers: .option)
                    Button(
                        action: {
                            appCanvas.selectedColor =
                                (appCanvas.customizeColor
                                + appCanvas.tempColor
                                + appCanvas.baseColor)[3]
                            appSetter.showToast(message: selectedColor + appCanvas.selectedColor.toHex())
                        },
                        label: {
                            Text(pickColor + "  4")
                        }
                    ).keyboardShortcut("4", modifiers: .option)
                    Button(
                        action: {
                            appCanvas.selectedColor =
                                (appCanvas.customizeColor
                                + appCanvas.tempColor
                                + appCanvas.baseColor)[4]
                            appSetter.showToast(message: selectedColor + appCanvas.selectedColor.toHex())
                        },
                        label: {
                            Text(pickColor + "  5")
                        }
                    ).keyboardShortcut("5", modifiers: .option)
                }
            }
            
            CommandGroup(before: .sidebar) {
                Button(
                    action: {
                        openWindow(id: "canvas")
                        appSetter.showToast(message: openCanvasWindow)
                    },
                    label: {
                        Text(openCanvasWindow)
                    }
                ).keyboardShortcut("c", modifiers: .command)
                Button(
                    action: {
                        appCanvas.appendColor()
                        appSetter.showToast(message: openColorPanel)
                    },
                    label: {
                        Text(openColorPanel)
                    }
                ).keyboardShortcut("f", modifiers: .command)
            }
            
            CommandGroup(before: .windowArrangement) {

                Button(
                    action: {
                        if let window = NSApplication.shared.windows.first(
                            where: { $0.identifier?.rawValue == "canvas" })
                        {
                            window.orderFront(nil)
                            window.makeKeyAndOrderFront(nil)
                        }
                        appSetter.showToast(message: bringCanvasToFront)
                    },
                    label: {
                        Text(bringCanvasToFront)
                    }
                ).keyboardShortcut("1", modifiers: .command)

                Button(
                    action: {
                        appCanvas.appendColor()
                        appSetter.showToast(message: bringColorPanelToFront)
                    },
                    label: {
                        Text(bringColorPanelToFront)
                    }
                ).keyboardShortcut("2", modifiers: .command)

                Button(
                    action: {
                        appCanvas.enlargeWindow()
                        appSetter.showToast(message: enlargeSize)
                    },
                    label: {
                        Text(enlargeSize)
                    }
                ).keyboardShortcut("=", modifiers: .command)

                Button(
                    action: {
                        appCanvas.shrinkWindow()
                        appSetter.showToast(message: shrinkSize)
                    },
                    label: {
                        Text(shrinkSize)
                    }
                ).keyboardShortcut("-", modifiers: .command)
            }
        }
        
        Settings {
            SettingView()
                .environmentObject(appSetter)
        }
    }
}
