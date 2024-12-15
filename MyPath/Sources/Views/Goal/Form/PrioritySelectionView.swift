//
//  Pr.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//
import SwiftUI

struct PrioritySelectionView: View {
    @Binding var selectedPriority: Priority

    var body: some View {
        HStack(spacing: 16) {
            ForEach(Priority.allCases, id: \.self) { priority in
                VStack {
                    HStack {
                        Circle()
                            .fill(priority.color.opacity(selectedPriority == priority ? 1 : 0.3))
                            .frame(width: 12, height: 12)
                        Text(priority.title)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedPriority == priority ? Color.gray.opacity(0.2) : Color.clear)
                    )
                    .contentShape(Rectangle()) // Ensures only this area is tappable
                    .onTapGesture {
                        selectedPriority = priority
                    }
                }
            }
        }
        .padding()
    }
}
