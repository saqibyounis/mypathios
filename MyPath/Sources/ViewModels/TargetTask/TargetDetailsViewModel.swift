//
//  File.swift
//  MyPath
//
//  Created by Saqib Younis on 02/12/2024.
//

import Foundation


class TargetDetailsViewModel: ObservableObject {
    @Published var target: TargetEntity

    init(target: TargetEntity) {
        self.target = target
    }
}
