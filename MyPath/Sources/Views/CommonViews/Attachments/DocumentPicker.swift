//
//  DocumentPicker.swift
//  MyPath
//
//  Created by Saqib Younis on 11/12/2024.
//
import SwiftUI
import RxSwift
import PhotosUI

import Foundation
import UIKit

// MARK: - Helper Views
struct DocumentPicker: UIViewControllerRepresentable {
    let callback: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image, .pdf, .text])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(callback: callback)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let callback: (URL) -> Void
        
        init(callback: @escaping (URL) -> Void) {
            self.callback = callback
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            callback(url)
        }
    }
}

