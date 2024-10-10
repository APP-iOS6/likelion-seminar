//
//  SeminarUser.swift
//  likelion_seminar_admin
//
//  Created by Hwang_Inyoung on 10/7/24.
//

import Foundation

struct SeminarUser: Codable {
    var id: String
    let name: String
    let phone: String
    let email: String
    let ticketCount: Int
}
