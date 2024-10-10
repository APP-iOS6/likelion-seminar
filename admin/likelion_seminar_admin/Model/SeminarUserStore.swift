//
//  SeminarUserStore.swift
//  likelion_seminar_admin
//
//  Created by Hwang_Inyoung on 10/7/24.
//

import FirebaseFirestore
import SwiftUI

class SeminarUserStore: ObservableObject {
    @Published var participants: [SeminarUser] = []
    
    private var db = Firestore.firestore()
    
    func fetchParticipants(_ postId: String) async {
        do {
            let documents = try await db.collection("Seminar")
                .document(postId)
                .collection("Participant")
                .getDocuments()
            
            let fetchedParticipants = try documents.documents.compactMap { document in
                try document.data(as: SeminarUser.self)
            }
            
            // UI 업데이트 보장
            DispatchQueue.main.async {
                self.participants = fetchedParticipants
            }
            
            print("Fetched participants: \(self.participants)")
        } catch {
            print("Error fetching participants: \(error)")
        }
    }
    /*
    func fetchParticipants() async throws {
        let documents = try await db.collection("Seminar")
            .document("75E886CA-D290-4AFD-9DC6-7751AD612823")
            .collection("Participant")
            .getDocuments()
            .documents
        let participants = try documents.compactMap { snapshot in
            try snapshot.data(as: SeminarUser.self)
        }
        self.participants = participants
    }
    */
}
