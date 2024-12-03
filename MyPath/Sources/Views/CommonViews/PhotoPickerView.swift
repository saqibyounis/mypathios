//
//  IconPickerView.swift
//  MyPath
//
//  Created by Saqib Younis on 30/11/2024.
//

import SwiftUI
import PhotosUI
import Photos

struct PhotoPickerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var filePath: String?

    var body: some View {
        VStack {
            if let filePath {
                Text("File Path: \(filePath)")
                    .padding()
                    .multilineTextAlignment(.center)
            } else {
                Text("No file selected")
            }

            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Choose Photo", systemImage: "photo.fill")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: selectedItem) { newItem in
                if let newItem {
                    Task {
                        await fetchFilePath(from: newItem)
                    }
                }
            }
        }
        .padding()
    }

    func fetchFilePath(from pickerItem: PhotosPickerItem) async {
        do {
            if let data = try await pickerItem.loadTransferable(type: Data.self),
               let tempURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(UUID().uuidString + ".jpg") {
                // Save data to a temporary location
                try data.write(to: tempURL)
                self.filePath = tempURL.path // Store the file path
            }
        } catch {
            print("Error loading photo: \(error)")
        }
    }
}
