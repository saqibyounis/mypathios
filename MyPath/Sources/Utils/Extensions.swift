//
//  Extensions.swift
//  MyPath
//
//  Created by Saqib Younis on 03/12/2024.
//

import Foundation
import SwiftUI

extension Binding {
    func unwrap(defaultValue: Value) -> Binding<Value> {
        Binding<Value>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
