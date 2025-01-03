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
    var uiPhoto: UIImage?
}

struct OnboardingGalleryView: View {
    
    @Bindable var viewModel: OnboardingViewModel
    
    @State private var draggingPhoto: Image?
    
    @State private var showAlert = false
    
    var body: some View {
        
        VStack {
            
            Text("Tap to add, drag & drop to change the order.")
                .font(.avenir(style: .regular, size: 12))
                .hSpacing(.leading)
                .padding(.leading, 32)
            
            let columns = Array(repeating: GridItem(spacing: 34), count: 2)
            
            LazyVGrid(columns: columns, spacing: 34) {
                ForEach(viewModel.photos, id: \.id) { photo in
                    
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
                                        if let sourceIndex = viewModel.photos.firstIndex(where: {$0.photo == draggingPhoto}),
                                           let destinationIndex = viewModel.photos.firstIndex(where: {$0.photo == photo.photo}) {
                                            withAnimation(.bouncy) {
                                                let sourceItem = viewModel.photos.remove(at: sourceIndex)
                                                viewModel.photos.insert(sourceItem, at: destinationIndex)
                                            }
                                        }
                                    }
                                }
                                .onTapGesture {
                                    viewModel.selectedPhotoIndex = photo.index
                                    viewModel.isPhotoPickerPresented = true
                                }
                            
                            
                        } else {
                            
                            ZStack(alignment: .topLeading) {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: size.width, height: size.height)
                                
                                VStack {
                                    
                                    Text("\(photo.index + 1)")
                                        .font(.avenir(style: .medium, size: 15))
                                        .foregroundStyle(.white)
//                                    
//                                    if viewModel.photos.firstIndex(where: {$0.photo == nil}) != nil {
//                                        Text("+")
//                                            .font(.avenir(style: .medium, size: 15))
//                                            .foregroundStyle(.white)
//                                            
//                                    }
                                    
                                }
                                .padding(12)
                                    
                            }
                            .onTapGesture {
                                viewModel.selectedPhotoIndex = photo.index
                                viewModel.isPhotoPickerPresented = true
                                
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
                
                if viewModel.photos.filter({ $0.photo != nil }).count < 2 {
                    showAlert = true
                } else {
                    // send all images 
                    viewModel.step = .locationPermission
                }
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
            .padding(.bottom, 32)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Minimum 2 photos required"),
                    message: Text(""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onboardingTemplate(title: "COMPLETE YOUR PROFILE", progress: 1.0)
        
    }
    
}

#Preview {
    OnboardingGalleryView(viewModel: .init())
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

