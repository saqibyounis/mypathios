//
//  AttachmentView.swift
//  MyPath
//
//  Created by Saqib Younis on 09/12/2024.
//
import SwiftUI
import RxSwift
import PhotosUI

import Foundation
import UIKit

// MARK: - Models
struct AttachmentViewConfiguration {
    var showCamera: Bool = true
    var allowedTypes: [UTType] = [.image, .pdf, .text]
    var maxFileSize: Int64? = nil
}


