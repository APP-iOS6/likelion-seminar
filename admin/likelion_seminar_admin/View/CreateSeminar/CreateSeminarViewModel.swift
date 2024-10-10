//
//  CreateSeminarViewModel.swift
//  likelion_seminar_admin
//
//  Created by 김동경 on 10/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

//카테고리 enum
enum SeminarCategory: String, CaseIterable {
    case FE = "FE"
    case BE = "BE"
    case Mobile = "Mobile"
    case UXUI = "UX/UI"
    case AI = "AI"
}

//Progress를 위한 카테고리 스텝
enum CreateSeminarStep: Double {
    case title = 0.33
    case date = 0.66
    case address = 1.0
}

//이미지 업로드 중 에러
enum UploadImageError: Error {
    case noneImage
    case invalidImageData
    case uploadError
}

//업로드 상태
enum UploadState {
    case none
    case loading
    case complete
}
//세미나 생성 뷰모델
class CreateSeminarViewModel: ObservableObject {
    
    let db = Firestore.firestore() //파이어스토어
    let StorageRef = Storage.storage().reference() //파이어 스토리지
    
    @Published var step: CreateSeminarStep = .title //세미나 생성 스텝
    @Published var seminar: Seminar = Seminar() //세미나 데이터
    @Published var seminarCategory: SeminarCategory = .FE //카테고리
    @Published var image: UIImage? //이미지
    @Published var errorMessage: String?
    @Published var uploadState: UploadState = .none
    
    func uploadImage(_ image: UIImage) async throws -> String {
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            throw UploadImageError.invalidImageData
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        do {
            let ref = StorageRef.child("Seminar").child("\(seminar.id).jpeg")
            _ = try await ref.putDataAsync(imageData, metadata: metaData)
            return try await ref.downloadURL().absoluteString
        } catch {
            throw UploadImageError.uploadError
        }
    }
    
    
    @MainActor
    func uploadSeminar() async {
        seminar.category = seminarCategory.rawValue
        self.uploadState = .loading
        
        do {
            if let image = self.image {
                let uploadedImage = try await uploadImage(image)
                self.seminar.image = uploadedImage
            }
            let seminarEncode = try Firestore.Encoder().encode(seminar)
            try await db.collection("Seminar").document(seminar.id).setData(seminarEncode)
            
            self.uploadState = .complete
            
        } catch {
            self.uploadState = .none
            self.errorMessage = "업로드 실패"
            print(error.localizedDescription)
        }
    }
    
    
    @MainActor
    func convertPickerItemToImage(_ item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        Task {
            do {
                if let imageData = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: imageData) {
                    self.image = image
                } else {
                    self.errorMessage = "이미지를 불러오는 데 실패"
                }
            } catch {
                self.errorMessage = "이미지를 불러오는 중 오류발생"
            }
        }
    }
    
}
