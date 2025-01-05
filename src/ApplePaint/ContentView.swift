//
//  ApplePaintApp.swift
//  ApplePaint
//
//  Created by Evaan Chowdhry on 2025-01-04.
//

import SwiftUI

struct ContentView: View {
    @State private var paths: [(color: Color, lineWidth: CGFloat, points: [CGPoint])] = []
    @State private var currentPoints: [CGPoint] = []
    @State private var previousPoint: CGPoint?
    @State private var selectedColor: Color = .blue
    @State private var tempColor: Color = .blue
    @State private var lineWidth: CGFloat = 3.0
    @State private var isErasing = false
    @State private var showColorPicker = false
    @State private var showLineWidthPicker = false
    @State private var colors: [Color] = [.blue, .red, .green, .orange, .purple, .black]
    @State private var redoStack: [(color: Color, lineWidth: CGFloat, points: [CGPoint])] = []
    @State private var tappedLocation: CGPoint?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Color.white
                
                
                Canvas { context, size in
                    for path in paths {
                        if path.points.count > 1 {
                            var path2D = Path()
                            path2D.move(to: path.points[0])
                            
                            for i in 0..<path.points.count - 1 {
                                let mid = CGPoint(
                                    x: (path.points[i].x + path.points[i + 1].x) / 2,
                                    y: (path.points[i].y + path.points[i + 1].y) / 2
                                )
                                path2D.addQuadCurve(to: mid, control: path.points[i])
                            }
                            path2D.addLine(to: path.points.last ?? .zero)
                            
                            context.stroke(
                                path2D,
                                with: .color(path.color),
                                style: StrokeStyle(lineWidth: path.lineWidth, lineCap: .round)
                            )
                        } else {
                            let dot = Path(ellipseIn: CGRect(
                                x: path.points[0].x - path.lineWidth/2,
                                y: path.points[0].y - path.lineWidth/2,
                                width: path.lineWidth,
                                height: path.lineWidth
                            ))
                            context.fill(dot, with: .color(path.color))
                        }
                    }
                    
                    
                    if !currentPoints.isEmpty {
                        var currentPath = Path()
                        currentPath.move(to: currentPoints[0])
                        
                        for i in 0..<currentPoints.count - 1 {
                            let mid = CGPoint(
                                x: (currentPoints[i].x + currentPoints[i + 1].x) / 2,
                                y: (currentPoints[i].y + currentPoints[i + 1].y) / 2
                            )
                            currentPath.addQuadCurve(to: mid, control: currentPoints[i])
                        }
                        currentPath.addLine(to: currentPoints.last ?? .zero)
                        
                        context.stroke(
                            currentPath,
                            with: .color(isErasing ? .white : selectedColor),
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
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
                                    if currentPoints.isEmpty {
                                        currentPoints = [tapLocation]
                                    } else {
                                        currentPoints.append(tapLocation)
                                    }
                                }
                                .onEnded { _ in
                                    if !currentPoints.isEmpty {
                                        let finalColor = isErasing ? Color.white : selectedColor
                                        paths.append((finalColor, lineWidth, currentPoints))
                                        redoStack.removeAll()
                                    }
                                    currentPoints = []
                                },
                            TapGesture()
                                .onEnded {
                                    if let location = tappedLocation {
                                        paths.append((selectedColor, lineWidth, [location]))
                                    }
                                }
                        )
                    )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .overlay(
                VStack {
                    HStack(spacing: 8) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == color && !isErasing ? Color.accentColor : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                    isErasing = false
                                }
                        }

                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .shadow(color: Color.black.opacity(0.2), radius: 4)
                            .overlay(
                                Image(systemName: "paintpalette")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.blue)
                            )
                            .onTapGesture {
                                tempColor = selectedColor
                                showColorPicker = true
                            }

                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Image(systemName: "eraser")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(isErasing ? .red : .accentColor)
                            )
                            .onTapGesture {
                                isErasing.toggle()
                            }

                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .fill(selectedColor)
                                    .frame(width: lineWidth)
                                    .overlay(
                                        Image(systemName: "scribble.variable")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 12, height: 12)
                                            .foregroundColor(.accentColor)
                                    )
                            )
                            .onTapGesture {
                                showLineWidthPicker = true
                            }

                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .shadow(color: Color.black.opacity(0.2), radius: 4)
                            .overlay(
                                Image(systemName: "arrow.uturn.backward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.accentColor)
                            )
                            .onTapGesture {
                                undo()
                            }

                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .shadow(color: Color.black.opacity(0.2), radius: 4)
                            .overlay(
                                Image(systemName: "arrow.uturn.forward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.accentColor)
                            )
                            .onTapGesture {
                                redo()
                            }

                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .shadow(color: Color.black.opacity(0.2), radius: 4)
                            .overlay(
                                Image(systemName: "trash")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.red)
                            )
                            .onTapGesture {
                                paths = []
                                redoStack = []
                                currentPoints = []
                            }
                    }
                    .padding(8)
                    .background(Capsule().fill(Color.white).shadow(radius: 2))
                }
                .padding(.bottom, 16),
                alignment: .bottom
            )
            .sheet(isPresented: $showColorPicker, onDismiss: {
                if !colors.contains(tempColor) {
                    colors.append(tempColor)
                }
                selectedColor = tempColor
                isErasing = false
            }) {
                ColorPicker("Pick a Color", selection: $tempColor, supportsOpacity: true)
                    .padding()
            }
            .sheet(isPresented: $showLineWidthPicker) {
                VStack(spacing: 16) {
                    Text("Adjust Line Thickness")
                        .font(.headline)

                    HStack {
                        Slider(value: $lineWidth, in: 1...20, step: 1)
                        Circle()
                            .fill(selectedColor)
                            .frame(width: lineWidth, height: lineWidth)
                            .overlay(Circle().stroke(Color.black.opacity(0.2), lineWidth: 1))
                    }
                    .padding()

                    Button(action: {
                        showLineWidthPicker = false
                    }) {
                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
            }
        }
    }

    private func undo() {
        guard let lastPath = paths.popLast() else { return }
        redoStack.append(lastPath)
    }

    private func redo() {
        guard let lastRedo = redoStack.popLast() else { return }
        paths.append(lastRedo)
    }
}
