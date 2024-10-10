//
//  SeminarStore.swift
//  likelion_seminar_admin
//
//  Created by Hwang_Inyoung on 10/8/24.
//

import FirebaseFirestore
import SwiftUI

class SeminarStore: ObservableObject {
    @Published var seminars: [Seminar] = []
    @Published var participants: [SeminarUser] = []
    
    private var db = Firestore.firestore()
    
    init() {
        Task {
            await fetchSeminars()
        }
    }
    
    // Firestore에서 세미나 데이터를 가져오는 비동기 함수
    func fetchSeminars() async {
        do {
            let documents = try await db.collection("Seminar")
                .order(by: "startDateForSeminar", descending: true) // 최신 순서로 정렬
                .getDocuments()
            
            // Firestore에서 데이터를 Seminar 모델로 변환
            let fetchedSeminars = try documents.documents.compactMap { document in
                try document.data(as: Seminar.self)
            }
            
            // UI 업데이트 보장
            DispatchQueue.main.async {
                self.seminars = fetchedSeminars
            }
            
            print("Fetched seminars: \(self.seminars)")
        } catch {
            print("세미나 못가졈옴 ㅋ")
            print("Error fetching seminars: \(error)")
        }
    }
    
    // Firestore에서 세미나 데이터를 업데이트하는 함수 (updateData 사용)
        func updateSeminar(_ seminar: Seminar) async {
            do {
                try await db.collection("Seminar").document(seminar.id).updateData([
                    "id": seminar.id,  // id 필드도 포함
                    "name": seminar.name,
                    "startDateForSeminar": seminar.startDateForSeminar,
                    "endDateForSeminar": seminar.endDateForSeminar,
                    "startDateForApply": seminar.startDateForApply,
                    "endDateForApply": seminar.endDateForApply,
                    "location": seminar.location,
                    "capacity": seminar.capacity,
                    "participants": seminar.participants,
                    "content": seminar.content,
                    "image": seminar.image,
                    "category": seminar.category
                ])
                
                // 세미나 업데이트 후, 데이터 다시 가져오기
                await fetchSeminars()
            } catch {
                print("Error updating seminar: \(error)")
            }
        }
    
    func filteredSeminars(for category: String) -> [Seminar] {
        let filtered = seminars.filter { seminar in
            category == "All" || seminar.category == category
        }
        return filtered.sorted { $0.startDateForSeminar > $1.startDateForSeminar }
    }
    
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
}
