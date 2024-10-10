//
//  Seminar.swift
//  likelion_seminar_admin
//
//  Created by 김동경 on 10/7/24.
//

import Foundation


struct Seminar: Identifiable, Codable {

    var id: String = UUID().uuidString
    var name: String = ""
    //행사기간
    var startDateForSeminar: Date = Date()
    var endDateForSeminar: Date = Date()
    //모집기간
    var startDateForApply: Date = Date()
    var endDateForApply: Date = Date()
    //내용
    var content: String = ""
    //장소
    var location: String = ""
    //수용인원
    var capacity: Int = 0
    //참가자수
    var participants: Int = 0
    var image: String = ""
    var category: String = SeminarCategory.FE.rawValue
}
