//
//  FAQ.swift
//  likelion_seminar_admin
//
//  Created by 김동경 on 10/8/24.
//

import Foundation
import FirebaseFirestore

struct FAQ: Codable {
    @DocumentID var id: String?
    var question: String
    var answer: String
}
