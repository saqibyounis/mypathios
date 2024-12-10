//
//  TaskDetailsViewModel.swift
//  MyPath
//
//  Created by Saqib Younis on 09/12/2024.
//


import SwiftUI
import RxSwift
import PhotosUI

// MARK: - View Model
class TaskDetailsViewModel: ObservableObject {
    private let service: TaskServiceImpl
    private let disposeBag = DisposeBag()
    private let taskId: String
    
    @Published var task: TaskEntity?
    @Published var attachments: [Attachment] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var showingImagePicker = false
    @Published var showingCameraSheet = false
    @Published var isUploadingFile = false
    
    init(service: TaskServiceImpl, taskId: String) {
        self.service = service
        self.taskId = taskId
        loadTask()
        loadAttachments()
    }
    
    func loadTask() {
        isLoading = true
        
        service.getTask(id: taskId)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] task in
                    self?.task = task
                    self?.isLoading = false
                },
                onFailure: { [weak self] error in
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    func loadAttachments() {
//        service.getTaskAttachments(taskId: taskId)
//            .observe(on: MainScheduler.instance)
//            .subscribe(
//                onSuccess: { [weak self] attachments in
//                    self?.attachments = attachments
//                },
//                onError: { [weak self] error in
//                    self?.showError = true
//                    self?.errorMessage = error.localizedDescription
//                }
//            )
//            .disposed(by: disposeBag)
    }
    
    func addAttachment(attachment: AttachmentEntity) {
       
           isUploadingFile = true
        
        service.addAttachment(task!, atachment: attachment)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onCompleted: { [weak self] in
                    self?.isUploadingFile = false
                    self?.loadAttachments()
                },
                onError: { [weak self] error in
                    self?.isUploadingFile = false
                    self?.showError = true
                    self?.errorMessage = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
    
    func deleteAttachment(attachmentId: String) {
//        service.deleteAttachment(taskId: taskId, attachmentId: attachmentId)
//            .observe(on: MainScheduler.instance)
//            .subscribe(
//                onCompleted: { [weak self] in
//                    self?.loadAttachments()
//                },
//                onError: { [weak self] error in
//                    self?.showError = true
//                    self?.errorMessage = error.localizedDescription
//                }
//            )
//            .disposed(by: disposeBag)
    }
}
