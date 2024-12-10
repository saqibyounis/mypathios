//
//  Pr.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import SwiftUI

enum Priority: Int, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
    
    var title: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

struct PrioritySelectionView: View {
    @Binding var selectedPriority: Priority
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(Priority.allCases, id: \.self) { priority in
                Button {
                     print(selectedPriority)
                    selectedPriority = priority
                } label: {
                    HStack {
                        Circle()
                            .fill(priority.color.opacity(selectedPriority == priority ? 1 : 0.3))
                            .frame(width: 12, height: 12)
                        Text(priority.title)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(selectedPriority == priority ? Color.gray.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
                }
                .foregroundColor(selectedPriority == priority ? .primary : .secondary)
            }
        }
        .padding()
    }
}
