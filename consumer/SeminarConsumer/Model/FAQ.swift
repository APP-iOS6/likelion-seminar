//
//  FAQ.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/8/24.
//
import Foundation
import FirebaseFirestore


struct FAQ: Identifiable {
    var id: String { documentId }
    let documentId: String
    let question: String
    let answer: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.question = data["question"] as? String ?? "질문 데이터가 존재하지 않습니다"
        self.answer = data["answer"] as? String ?? "답변 데이터가 존재하지 않습니다."
    }
}



