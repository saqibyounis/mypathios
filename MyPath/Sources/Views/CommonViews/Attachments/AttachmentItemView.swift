//
//  AttachmentItemView.swift
//  MyPath
//
//  Created by Saqib Younis on 11/12/2024.
//

import SwiftUI
import RxSwift
import PhotosUI
import UIKit

import Foundation

struct EmptyAttachmentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("No Attachments")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Add files or take photos")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}



struct AttachmentItemView: View {
    let attachment: AttachmentEntity
    let onDelete: () -> Void
    let onTap: () -> Void
    @State private var showDeleteAlert = false
    @State private var thumbnail: UIImage?

    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Thumbnail
                if let thumbnail = thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: iconName)
                        .font(.system(size: 24))
                        .foregroundColor(.accentColor)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                // File Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(attachment.name)
                        .font(.system(.body, design: .rounded))
                        .lineLimit(1)
                    
                    Text(formattedSize)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Delete Button
                Button(action: { showDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(8)
                }
            }
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Delete Attachment", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive, action: onDelete)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this attachment?")
        }.task {
            await loadThumbnail()
        }
        
        
        
    }
    
    private var iconName: String {
        switch attachment.type {
        case .image: return "photo.fill"
        case .pdf: return "doc.text.fill"
        case .other: return "doc.fill"
        }
    }
    
    private var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: attachment.size)
    }
    
    
    private func loadThumbnail() async {
        guard let thumbnailUrl = attachment.thumbnailUrl else { return }
        
        do {
            let data = try Data(contentsOf: thumbnailUrl)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.thumbnail = image
                }
            }
        } catch {
            print("Failed to load thumbnail: \(error)")
        }
    }
}
