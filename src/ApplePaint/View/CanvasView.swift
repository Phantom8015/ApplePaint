//
//  ApplePaintApp.swift
//  ApplePaint
//
//  Created by Evaan Chowdhry on 2025-01-04.
//

import AlertToast
import SwiftUI

struct CanvasView: View {

    @EnvironmentObject var appCanvas: AppCanvas
    @EnvironmentObject var appSetter: AppSetter

    @State private var isShiftPressed = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ToolView()
                    .environmentObject(appCanvas)
                    .environmentObject(appSetter)
                    .frame(width: 48)
                    .background(Color.clear)
                
                ZStack {
                    switch appSetter.canvasBackground {
                    case .VisualEffectBlur:
                        VisualEffectBlur()
                    case .Colorful:
                        Color(hex: appSetter.colorBackgourd).ignoresSafeArea()
                    case .Picture:
                        Image(appSetter.pictureBackgroud)
                            .resizable().scaledToFill()
                    case .Customize:
                        let image =
                            NSImage(data: appSetter.customizePicture)
                            ?? .blackboard1
                        if appSetter.scaledToFill {
                            Image(nsImage: image)
                                .resizable().scaledToFill()
                        } else {
                            Image(nsImage: image)
                                .resizable().scaledToFit()
                        }
                    }

                // MARK: Canvas
                if appCanvas.paths.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Texts(
                            label: NSLocalizedString(
                                "Double Mouse Click Color", comment: "双击任一颜色")
                                + NSLocalizedString(
                                    "Open Color Panel", comment: "打开颜色面板"))
                        Texts(
                            label: NSLocalizedString(
                                "Right Click for More Features",
                                comment: "更多功能 右键任一颜色")
                                + NSLocalizedString(
                                    "Open Color Panel", comment: "打开颜色面板"))
                        Texts(
                            label: NSLocalizedString(
                                "Hold Shift to Draw a Straight Line",
                                comment: "长按Shift画直线"))
                        Divider()
                        Texts(
                            label: " ⌘ c  "
                                + NSLocalizedString(
                                    "Open Canvas Window", comment: "打开画布"))
                        Texts(
                            label: " ⌘ f  "
                                + NSLocalizedString(
                                    "Open Color Panel", comment: "打开颜色面板"))
                        Texts(
                            label: " ⌘ t  "
                                + NSLocalizedString(
                                    "Open Tool Window", comment: "打开工具面板"))
                        Texts(
                            label: " ⌥ 1 ... 5  to "
                                + NSLocalizedString(
                                    "Pick Color", comment: "选择颜色"))
                        Texts(
                            label: " ⇧ 1 ... 10  to "
                                + NSLocalizedString(
                                    "ChooseThickness", comment: "选择画笔粗细"))
                        Texts(
                            label: " ⌘ e  "
                                + NSLocalizedString("Eraser", comment: "橡皮擦"))
                        Texts(
                            label: " ⌘ ⇧ c  "
                                + NSLocalizedString(
                                    "Clear All", comment: "清空画布"))
                        Texts(
                            label: " ⌘ 1 ... 3  "
                                + NSLocalizedString(
                                    "Bring Window to Front", comment: "置顶窗口"))
                    }.frame(width: 320)
                }

                    Canvas { context, size in
                        for path in appCanvas.paths {
                            if path.points.count > 1 {
                                var path2D = Path()
                                path2D.move(to: path.points[0])

                                for i in 0..<path.points.count - 1 {
                                    let mid = CGPoint(
                                        x: (path.points[i].x + path.points[i + 1].x)
                                            / 2,
                                        y: (path.points[i].y + path.points[i + 1].y)
                                            / 2
                                    )
                                    path2D.addQuadCurve(
                                        to: mid, control: path.points[i])
                                }
                                path2D.addLine(to: path.points.last ?? .zero)

                                context.stroke(
                                    path2D,
                                    with: .color(path.color),
                                    style: StrokeStyle(
                                        lineWidth: path.lineWidth, lineCap: .round)
                                )
                            } else {
                                let dot = Path(
                                    ellipseIn: CGRect(
                                        x: path.points[0].x - path.lineWidth / 2,
                                        y: path.points[0].y - path.lineWidth / 2,
                                        width: path.lineWidth,
                                        height: path.lineWidth
                                    ))
                                context.fill(dot, with: .color(path.color))
                            }
                        }

                        if !appCanvas.currentPoints.isEmpty {
                            var currentPath = Path()
                            currentPath.move(to: appCanvas.currentPoints[0])

                            for i in 0..<appCanvas.currentPoints.count - 1 {
                                let mid = CGPoint(
                                    x: (appCanvas.currentPoints[i].x
                                        + appCanvas.currentPoints[i + 1].x) / 2,
                                    y: (appCanvas.currentPoints[i].y
                                        + appCanvas.currentPoints[i + 1].y) / 2
                                )
                                currentPath.addQuadCurve(
                                    to: mid, control: appCanvas.currentPoints[i])
                            }
                            currentPath.addLine(
                                to: appCanvas.currentPoints.last ?? .zero)

                            context.stroke(
                                currentPath,
                                with: .color(
                                    appCanvas.isErasing
                                        ? Color.clear : appCanvas.selectedColor),
                                style: StrokeStyle(
                                    lineWidth: appSetter.lineWidth, lineCap: .round)
                            )
                        }
                    }

                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            SimultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let tapLocation = value.location
                                        
                                        isShiftPressed = NSEvent.modifierFlags
                                            .contains(.shift)
                                        if appCanvas.currentPoints.isEmpty {
                                            appCanvas.currentPoints = [tapLocation]
                                        } else {
                                            
                                            if isShiftPressed,
                                                let firstPoint = appCanvas
                                                    .currentPoints.first
                                            {
                                                
                                                let dx = abs(
                                                    firstPoint.x - tapLocation.x)
                                                let dy = abs(
                                                    firstPoint.y - tapLocation.y)

                                                if dx > dy {
                                                    
                                                    appCanvas.currentPoints = [
                                                        firstPoint,
                                                        CGPoint(
                                                            x: tapLocation.x,
                                                            y: firstPoint.y),
                                                    ]
                                                } else {
                                                    
                                                    appCanvas.currentPoints = [
                                                        firstPoint,
                                                        CGPoint(
                                                            x: firstPoint.x,
                                                            y: tapLocation.y),
                                                    ]
                                                }
                                            } else {
                                                
                                                appCanvas.currentPoints.append(
                                                    tapLocation)
                                            }
                                        }

                                        if appCanvas.isErasing {
                                            appCanvas.eraseAt(location: tapLocation)
                                        }
                                    }
                                    .onEnded { _ in
                                        if !appCanvas.currentPoints.isEmpty {
                                            let finalColor =
                                                appCanvas.isErasing
                                                ? Color.clear
                                                : appCanvas.selectedColor
                                            if !appCanvas.isErasing {
                                                appCanvas.paths.append(
                                                    (
                                                        finalColor,
                                                        appSetter.lineWidth,
                                                        appCanvas.currentPoints
                                                    ))
                                            }
                                            appCanvas.redoStack.removeAll()
                                        }
                                        appCanvas.currentPoints = []
                                    },
                                TapGesture()
                                    .onEnded {
                                        if let location = appCanvas.tappedLocation {
                                            appCanvas.paths.append(
                                                (
                                                    appCanvas.selectedColor,
                                                    appSetter.lineWidth, [location]
                                                ))
                                        }
                                    }
                            )
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onHover { _ in
                if let window = NSApplication.shared.windows.first(
                    where: {
                        $0.identifier?.rawValue == "canvas"
                    })
                {
                    window.orderFront(nil)
                    window.makeKeyAndOrderFront(nil)
                }
            }
        }
    }
}

#Preview {
    CanvasView()
        .environmentObject(AppCanvas.shared)
        .environmentObject(AppSetter.shared)
}
