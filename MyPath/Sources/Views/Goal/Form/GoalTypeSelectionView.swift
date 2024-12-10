//
//  GoalTypeSelectionVIew.swift
//  MyPath
//
//  Created by Saqib Younis on 08/12/2024.
//

import SwiftUI


struct GoalTypeSelectionView: View {
    @Binding var selectedType: GoalType
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(GoalType.allCases, id: \.self) { type in
                    Button(action: {
                        selectedType = type
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: type.icon)
                            Text(type.rawValue)
                                .font(.callout)
                        }
                        .frame(minWidth: 100)
                        .padding(.vertical, 12)
                        .background(selectedType == type ? Color.gray.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                    }
                    .foregroundColor(selectedType == type ? .primary : .secondary)
                }
            }
            .padding(.horizontal)
        }
    }
}
