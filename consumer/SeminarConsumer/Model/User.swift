//
//  User.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/7/24.
//

import Foundation
// 이름, 이메일, 전화번호
// 회원 비회원 통합
struct User: Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
    var email: String
    var phone: String
    var ticketCount: Int
}
