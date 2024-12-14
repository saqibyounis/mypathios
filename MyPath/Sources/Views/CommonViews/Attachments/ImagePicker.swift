//
//  ImagePicker.swift
//  MyPath
//
//  Created by Saqib Younis on 11/12/2024.
//

import SwiftUI
import RxSwift
import PhotosUI

import Foundation
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    let callback: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(callback: callback)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let callback: (UIImage) -> Void
        
        init(callback: @escaping (UIImage) -> Void) {
            self.callback = callback
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                callback(image)
            }
            picker.dismiss(animated: true)
        }
    }
}
