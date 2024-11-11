//
//  OnboardingGalleryView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct GalleryPhoto: Identifiable {
    let id = UUID()
    let index: Int
    var photo: Image?
}

struct OnboardingGalleryView: View {
    
    @Binding var viewModel: OnboardingViewModel
    
    @State private var photos: [GalleryPhoto] = [.init(index: 0), .init(index: 1), .init(index: 2), .init(index: 3), .init(index: 4), .init(index: 5)]
    @State private var draggingPhoto: Image?
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    @State private var isPhotoPickerPresented = false
    @State private var selectedIndex: Int?
    
    var body: some View {
        
        VStack {
            
            Text("Tap to add, drag & drop to change the order.")
                .font(.avenir(style: .regular, size: 12))
                .hSpacing(.leading)
                .padding(.leading, 32)
            
            let columns = Array(repeating: GridItem(spacing: 34), count: 2)
            
            LazyVGrid(columns: columns, spacing: 34) {
                ForEach(photos, id: \.id) { photo in
                    
                    GeometryReader {
                        let size = $0.size
                        
                        if let image = photo.photo {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)
                                .clipped()
                                .draggable(photo.photo!) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.ultraThinMaterial)
                                        .frame(width: 100, height: 100)
                                        .onAppear {
                                            draggingPhoto = photo.photo
                                        }
                                }
                                .dropDestination(for: Image.self) { items, location in
                                    draggingPhoto = nil
                                    return false
                                } isTargeted: { status in
                                    if let draggingPhoto, status, draggingPhoto != photo.photo {
                                        if let sourceIndex = photos.firstIndex(where: {$0.photo == draggingPhoto}),
                                           let destinationIndex = photos.firstIndex(where: {$0.photo == photo.photo}) {
                                            withAnimation(.bouncy) {
                                                let sourceItem = photos.remove(at: sourceIndex)
                                                photos.insert(sourceItem, at: destinationIndex)
                                            }
                                        }
                                    }
                                }
                                .onTapGesture {
                                    selectedIndex = photos.firstIndex(where: {$0.id == photo.id})
                                    isPhotoPickerPresented = true
                                }
                            
                            
                        } else {
                            
                            ZStack(alignment: .topLeading) {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: size.width, height: size.height)
                                
                                Text("\(photo.index + 1)")
                                    .font(.avenir(style: .medium, size: 15))
                                    .foregroundStyle(.white)
                                    .padding(12)
                                    
                            }
                            .onTapGesture {
                                selectedIndex = photos.firstIndex(where: {$0.photo == nil})
                                isPhotoPickerPresented = true
                            }
                        }
                    }
                    .frame(height: 140)
                }
            }
            .padding(.top)
            .padding(.horizontal, 52)
            
            Spacer()
            
            OnboardingActionButton() {
                viewModel.step = .locationPermission
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
            .padding(.bottom, 32)
        }
        .onboardingTemplate(title: "COMPLETE YOUR PROFILE", progress: 1.0)
        .sheet(isPresented: $isPhotoPickerPresented) {
            
            let photosLimit = 6
            PhotoPickerView(selectionLimit: photosLimit - (selectedIndex ?? 0)) { selectedPhotos in
                
                guard var index = photos.first(where: {$0.photo == nil})?.index else {
                    return
                }
                
                selectedPhotos.forEach { photo in
                    photos[index].photo = Image(uiImage: photo)
                    index += 1
                }
                
            }
            
        }
        
    }
    
}

#Preview {
    OnboardingGalleryView(viewModel: .constant(.init()))
}


struct PhotoPickerView: UIViewControllerRepresentable {
    
    var selectionLimit: Int
    
    var onImagesSelected: ([UIImage]) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = selectionLimit
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onImagesSelected: onImagesSelected)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var onImagesSelected: ([UIImage]) -> Void
        
        init(onImagesSelected: @escaping ([UIImage]) -> Void) {
            self.onImagesSelected = onImagesSelected
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            var selectedImages: [UIImage] = []
            let dispatchGroup = DispatchGroup()
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    dispatchGroup.enter()
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                        if let uiImage = image as? UIImage {
                            selectedImages.append(uiImage)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.onImagesSelected(selectedImages)
            }
        }
    }
}

