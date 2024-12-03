//
//  TargetModelView.swift
//  MyPath
//
//  Created by Saqib Younis on 28/11/2024.
//

import Foundation
import Foundation
import Speech
import RxSwift
import RxCocoa

class CreateTargetViewModel: ObservableObject {
    // Published properties for SwiftUI binding
    @Published var inputText: String = ""               // User input
    @Published var recognizedSpeechText: String = ""    // Speech-to-text result
    @Published var showAlert: Bool = false              // Alert visibility
    @Published var sentMessage: String = ""             // Sent message text
    
    private let datasource = CreateTargetDataSource()          // Datasource for external calls
    
    // RxSwift properties
    private let disposeBag = DisposeBag()
    private let inputSubject = BehaviorSubject<String>(value: "")
    private let sendTrigger = PublishSubject<Void>()

    init() {
        setupBindings()
    }

    // MARK: - Setup Rx Bindings
    private func setupBindings() {
        // Monitor text input
        inputSubject
            .map { !$0.isEmpty } // Map input to boolean for button state
            .distinctUntilChanged()
            .subscribe(onNext: { isEnabled in
                print("Send Button Enabled: \(isEnabled)")
            })
            .disposed(by: disposeBag)
        
        // Send input handling
        sendTrigger
            .withLatestFrom(inputSubject)
            .subscribe(onNext: { [weak self] input in
                self?.processInput(input)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Public Actions
    func startSpeechToText() {
        recognizedSpeechText = "Example Speech-to-Text result"
        inputText = recognizedSpeechText
    }

    func sendInput() {
        inputSubject.onNext(inputText)
        sendTrigger.onNext(())
    }

    // MARK: - Private Functions
    private func processInput(_ input: String) {
        // Simulate sending input
        sentMessage = "You sent: \(input)"
        inputText = "" // Clear input
        recognizedSpeechText = ""
        showAlert = true
    }
}
