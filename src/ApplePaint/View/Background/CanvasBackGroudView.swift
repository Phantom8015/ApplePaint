//
//  CanvasBackGroudView.swift
//  ApplePaint
//
//  Created by NullSilck on 2025/3/28.
//

import SwiftUI

struct CanvasBackGroudView: View {

    @EnvironmentObject var appSetter: AppSetter
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var selectedImage = NSImage(
        data: AppSetter.shared.customizePicture)
    let pictures: [NSImage] = [
        NSImage(named: .blackboard1)!,
        NSImage(named: .blackboard2)!,
        NSImage(named: .blackboard3)!,
        NSImage(named: .blackboard4)!,
    ]

    
    var body: some View {
        VStack {
            Picker("", selection: $appSetter.canvasBackground) {
                Text(
                    NSLocalizedString(
                        "Acrylic", comment: "")
                ).tag(CanvasBackground.VisualEffectBlur).padding(.vertical)
                Text(
                    NSLocalizedString("colorful", comment: "")
                ).tag(CanvasBackground.Colorful)
                Text(
                    NSLocalizedString(
                        "Picture", comment: "")
                ).tag(CanvasBackground.Picture)
                Text(
                    NSLocalizedString(
                        "Customize", comment: "")
                ).tag(CanvasBackground.Customize)
            }.pickerStyle(.segmented).labelsHidden().padding(.horizontal, 8)
                .padding(.vertical, 8)
            switch appSetter.canvasBackground {
            case .VisualEffectBlur:
                EmptyView()
            case .Colorful:
                returnColorful()
            case .Picture:
                returnPicture()
            case .Customize:
                returnCustomize()
            }
        }
    }
    
    private func returnColorful() -> some View {
        return VStack {
            LazyVGrid(columns: columns) {
                ForEach(appSetter.canvasBackgroudColorSet, id: \.self) {
                    color in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: 120, height: 75)
                        .shadow(color: .gray.opacity(0.5), radius: 0.4)
                        .padding(.bottom, 8)
                        .onTapGesture {
                            chooseColor(color: color)
                        }
                }
            }
        }
    }
    
    private func chooseColor(color: Color) {
        appSetter.colorBackgourd = color.toHex()
    }
    
    private func returnPicture() -> some View {
        return VStack {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(pictures, id: \.self) { picture in
                    RoundedRectangle(cornerRadius: 8)
                        .overlay {
                            Image(nsImage: picture)
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 120, height: 75).cornerRadius(8).clipped()
                        .shadow(color: .gray.opacity(0.5), radius: 0.4)
                        .padding(.bottom, 8)
                        .onTapGesture {
                            choosePicture(picture: picture.name() ?? "blackboard1")
                        }
                }
            }
        }
    }

    
    private func choosePicture(picture: String) {
        appSetter.pictureBackgroud = picture
    }
    
    private func returnCustomize() -> some View {
        return VStack {
            Toggles(
                label: NSLocalizedString(
                    "Scaled to Fill", comment: ""),
                action: $appSetter.scaledToFill).padding(.horizontal, 16)
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray.opacity(0.2))
                .overlay {
                    Image(nsImage: selectedImage ?? .init())
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            Image(systemName: "photo.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .padding(.leading, 8)
                                .opacity(selectedImage != nil ? 0 : 0.8)
                        }
                }
                .frame(width: 240, height: 150)
                .shadow(color: .gray.opacity(0.5), radius: 0.4)
                .padding(.bottom, 8)
                .onTapGesture {
                    selectedPicture()
                }
        }
    }
    
    private func selectedPicture() {
        if let file = selectFile(type: [.image]) {
            if let imageData = try? Data(contentsOf: file) {
                appSetter.customizePicture = imageData
                selectedImage = NSImage(data: appSetter.customizePicture)
            }
        }
    }
}

#Preview {
    CanvasBackGroudView()
        .environmentObject(AppSetter.shared)
}
