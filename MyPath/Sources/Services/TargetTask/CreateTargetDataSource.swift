//
//  TargetDataSource.swift
//  MyPath
//
//  Created by Saqib Younis on 28/11/2024.
//

import Foundation
import RxSwift

class CreateTargetDataSource {
    func fetchMockData() -> Observable<String> {
        return Observable.just("Mock Data")
    }
}
