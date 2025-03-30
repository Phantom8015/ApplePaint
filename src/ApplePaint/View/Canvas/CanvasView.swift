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
        ZStack {
            // MARK: Background
            switch appSetter.canvasBackground {
            case .VisualEffectBlur:
                VisualEffectBlur()
            case .Colorful:
                Color(hex: appSetter.colorBackgourd).ignoresSafeArea()
            case .Picture:
                Image(appSetter.pictureBackgroud).resizable()
            case .Customize:
                let image =
                    NSImage(data: appSetter.customizePicture)
                    ?? .blackboard1
                if appSetter.scaledToFill {
                    Image(nsImage: image).resizable().scaledToFill()
                } else {
                    Image(nsImage: image).resizable().scaledToFit()
                }
            }
            // MARK: ToolView
            if appSetter.showToolView {
                ToolView()
                    .environmentObject(appCanvas)
                    .environmentObject(appSetter)
                    .frame(width: 48)
                    .background(Color.clear)
                    .zIndex(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // MARK: Tips
            if appCanvas.paths.isEmpty {
                CanvasTipView()
            }

            // MARK: Canvas
            Canvas { context, size in
                for path in appCanvas.paths {
                    if path.points.count > 1 {
                        var path2D = Path()
                        path2D.move(to: path.points[0])

                        for i in 0..<path.points.count - 1 {
                            let mid = CGPoint(
                                x: (path.points[i].x
                                    + path.points[i + 1].x)
                                    / 2,
                                y: (path.points[i].y
                                    + path.points[i + 1].y)
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
                                lineWidth: path.lineWidth,
                                lineCap: .round)
                        )
                    } else {
                        let dot = Path(
                            ellipseIn: CGRect(
                                x: path.points[0].x - path.lineWidth
                                    / 2,
                                y: path.points[0].y - path.lineWidth
                                    / 2,
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
                            to: mid, control: appCanvas.currentPoints[i]
                        )
                    }
                    currentPath.addLine(
                        to: appCanvas.currentPoints.last ?? .zero)

                    context.stroke(
                        currentPath,
                        with: .color(
                            appCanvas.isErasing
                                ? Color.clear : appCanvas.selectedColor),
                        style: StrokeStyle(
                            lineWidth: appSetter.lineWidth,
                            lineCap: .round)
                    )
                }
            }
            
            // MARK: Drawing
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
                                    appCanvas.currentPoints = [
                                        tapLocation
                                    ]
                                } else {

                                    if isShiftPressed,
                                        let firstPoint = appCanvas
                                            .currentPoints.first
                                    {

                                        let dx = abs(
                                            firstPoint.x - tapLocation.x
                                        )
                                        let dy = abs(
                                            firstPoint.y - tapLocation.y
                                        )

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
                                    appCanvas.eraseAt(
                                        location: tapLocation)
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
                                if let location = appCanvas
                                    .tappedLocation
                                {
                                    appCanvas.paths.append(
                                        (
                                            appCanvas.selectedColor,
                                            appSetter.lineWidth,
                                            [location]
                                        ))
                                }
                            }
                    )
                )
        }
        .frame(minWidth: 480, minHeight: 300)
        .onHover { _ in
            // window actived when window hovered
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

#Preview {
    CanvasView()
        .environmentObject(AppCanvas.shared)
        .environmentObject(AppSetter.shared)
}
