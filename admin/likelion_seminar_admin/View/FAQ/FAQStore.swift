//
//  FAQViewModel.swift
//  likelion_seminar_admin
//
//  Created by 김동경 on 10/8/24.
//

import FirebaseFirestore
import SwiftUI

class FAQStore: ObservableObject {
    
    @Published var faqs: [FAQ] = []
    @Published var loadState: UploadState = .none
    let db = Firestore.firestore() //파이어스토어
    
    
    init() {
        Task {
            await loadFAQ()
        }
    }
    
    @MainActor
    func loadFAQ() {
        Task {
            do {
                let documents = try await db.collection("FAQ").getDocuments().documents
                
                self.faqs = try documents.compactMap {
                    try $0.data(as: FAQ.self)
                }
            } catch {
                print("error")
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func saveFAQToFirestore(faq: FAQ) async throws {
        let faqEncode = try Firestore.Encoder().encode(faq)
        try await db.collection("FAQ").document(faq.id ?? UUID().uuidString).setData(faqEncode)
    }
    
    @MainActor
    func updateFAQ(_ faq: FAQ, question: String, answer: String) {
        var faq = faq
        self.loadState = .loading
        faq.question = question
        faq.answer = answer
        Task {
            do {
                try await saveFAQToFirestore(faq: faq)
                self.loadState = .complete
            } catch {
                self.loadState = .none
                print(error.localizedDescription)
            }
        }
    }
    
    
    @MainActor
    func uploadFAQ(_ question: String, answer: String) {
        self.loadState = .loading
        let faq = FAQ(question: question, answer: answer)
        Task {
            do {
                try await saveFAQToFirestore(faq: faq)
                self.loadState = .complete
            } catch {
                self.loadState = .none
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func deleteFAQ(_ documentId: String) {
        Task {
            do {
                try await db.collection("FAQ").document(documentId).delete()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
