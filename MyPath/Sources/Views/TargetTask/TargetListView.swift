//
//  TargetTaskView.swift
//  MyPath
//
//  Created by Saqib Younis on 02/12/2024.
//

import SwiftUI

struct TargetListView: View {
    @StateObject private var viewModel = TargetListViewModel()
    @State private var selectedTarget: TargetEntity?

    var body: some View {
        NavigationView {
            List(viewModel.targets, id: \.id) { target in
                Button {
                    selectedTarget = target
                } label: {
                    VStack(alignment: .leading) {
                        Text(target.name)
                            .font(.headline)
                        Text(target.descriptionText ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Targets")
            .sheet(item: $selectedTarget) { target in
                TargetDetailsView(target: target)
            }
        }
    }
}
