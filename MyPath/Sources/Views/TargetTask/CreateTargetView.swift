//
//  TargetView.swift
//  MyPath
//
//  Created by Saqib Younis on 28/11/2024.
//
import SwiftUI
import RxSwift
import RxCocoa

struct CreateTargetView: View {
    @ObservedObject var viewModel = CreateTargetViewModel() // Bind to ViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Enter your message")
                .font(.headline)
            
            // Input TextField
            TextField("Type here...", text: $viewModel.inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Recognized speech text preview (optional)
            if !viewModel.recognizedSpeechText.isEmpty {
                Text("Recognized Speech: \(viewModel.recognizedSpeechText)")
                    .foregroundColor(.gray)
                    .italic()
            }
            
            // Action buttons
            HStack {
                Button(action: {
                    viewModel.startSpeechToText() // Trigger speech-to-text
                }) {
                    Label("Speak", systemImage: "mic.fill")
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    viewModel.sendInput() // Trigger sending input
                }) {
                    Label("Send", systemImage: "paperplane.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.inputText.isEmpty) // Disable if no input
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Input Sent"), message: Text(viewModel.sentMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTargetView()
    }
}
