//
//  TargetDetailsView.swift
//  MyPath
//
//  Created by Saqib Younis on 02/12/2024.
//

import SwiftUI
import Foundation

struct TargetDetailsView: View {
    @StateObject private var viewModel: TargetDetailsViewModel

    init(target: TargetEntity) {
        _viewModel = StateObject(wrappedValue: TargetDetailsViewModel(target: target))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Name: \(viewModel.target.name)")
                .font(.title2)
                .bold()

            Text("Description: \(viewModel.target.descriptionText)")
                .font(.body)

            Text("Start Date: \(DateUtils.timestampToDate(viewModel.target.startDate!), formatter: dateFormatter)")
                .font(.body)

            Text("Intended Completion Date: \(DateUtils.timestampToDate(viewModel.target.intendedCompletionDate!), formatter: dateFormatter)")
                .font(.body)

            Text("Status: \(viewModel.target.status.rawValue)")
                .font(.body)

            Text("Type: \(viewModel.target.targetType.rawValue)")
                .font(.body)

            Text("Priority: \(viewModel.target.priority.rawValue)")
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle("Target Details")
    }
}

// Date Formatter
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
