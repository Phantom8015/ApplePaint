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

    // MARK: Body
    var body: some View {
        VStack {
            Picker("", selection: $appSetter.canvasBackground) {
                Text(
                    NSLocalizedString(
                        "visualEffectBlur", comment: "视觉效果模糊")
                ).tag(CanvasBackground.VisualEffectBlur).padding(.vertical)
                Text(
                    NSLocalizedString("colorful", comment: "颜色")
                ).tag(CanvasBackground.Colorful)
                Text(
                    NSLocalizedString(
                        "picture", comment: "照片")
                ).tag(CanvasBackground.Picture)
                Text(
                    NSLocalizedString(
                        "customize", comment: "自定义照片")
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
    // MARK: 返回颜色视图
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
    // Mark: 选择颜色
    private func chooseColor(color: Color) {
        appSetter.colorBackgourd = color.toHex()
    }
    // MARK: 返回图片视图
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

    // MARK: 选择 app 内置图片
    private func choosePicture(picture: String) {
        appSetter.pictureBackgroud = picture
    }
    // MARK: 返回自定义图片视图
    private func returnCustomize() -> some View {
        return VStack {
            Toggles(
                label: NSLocalizedString(
                    "Scaled to Fill", comment: "缩放至填充"),
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
    // MARK: 选择并保存图片
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
