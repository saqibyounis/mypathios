//
//  DateUtils.swift
//  MyPath
//
//  Created by Saqib Younis on 02/12/2024.
//

import Foundation

struct DateUtils {
    static func timestampToDate(_ timestamp: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
    }
}
