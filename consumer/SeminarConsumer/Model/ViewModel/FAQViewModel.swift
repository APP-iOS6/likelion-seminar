//
//  FAQViewModel.swift
//  SeminarConsumer
//
//  Created by 권희철 on 10/8/24.
//

import Observation
import FirebaseFirestore

@Observable
class FAQViewModel {
    var faqs: [FAQ] = []
    private var db = Firestore.firestore()
    
    func fetchFAQs() async {
        do {
            let querySnapshot = try await db.collection("FAQ").getDocuments()

            self.faqs = querySnapshot.documents.map { document in
                FAQ(documentId: document.documentID, data: document.data())
            }
        } catch {
            print("Error getting documents: \(error)")
            
        }
    }
}
