//
//  AttachmentListView.swift
//  MyPath
//
//  Created by Saqib Younis on 11/12/2024.
//

import SwiftUI
import RxSwift
import PhotosUI

import Foundation
import UIKit


// MARK: - Attachment List View
struct AttachmentListView: View {
    let attachments: [AttachmentEntity]
    let onDeleteAttachment: ((AttachmentEntity) -> Void)?
    let onAttachmentTapped: ((AttachmentEntity) -> Void)?
    @State private var selectedAttachment: AttachmentEntity?
    
    init(
        attachments: [AttachmentEntity],
        onDeleteAttachment: ((AttachmentEntity) -> Void)? = nil,
        onAttachmentTapped: ((AttachmentEntity) -> Void)? = nil
    ) {
        self.attachments = attachments
        self.onDeleteAttachment = onDeleteAttachment
        self.onAttachmentTapped = onAttachmentTapped
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if attachments.isEmpty {
                EmptyAttachmentView()
            } else {
                ForEach(attachments, id: \.id) { attachment in
                    AttachmentItemView(
                        attachment: attachment,
                        onDelete: {
                            if let onTap = onDeleteAttachment{
                                onTap(attachment)
                            }
                        },
                        onTap: {
                            if let onTap = onAttachmentTapped {
                                onTap(attachment)
                            }
                        }
                    )
                }
            }
        }
        .padding(.horizontal)
    }
}
