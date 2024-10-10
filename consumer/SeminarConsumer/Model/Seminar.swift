//
//  Seminar.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/7/24.
//

import Foundation
// 이름, 신청기간, 날짜, 내용 , 장소 , 수용인원, 참가자수 , 이미지주소
//startDate endDate

struct Seminar: Identifiable, Codable {
    var id = UUID().uuidString
    let name: String
    //행사기간
    let startDateForSeminar: Date
    let endDateForSeminar: Date
    //모집기간
    let startDateForApply: Date
    let endDateForApply: Date
    //내용
    let content: String
    //장소
    let location: String
    //수용인원
    let capacity: Int
    //참가자수
    var participants: Int
    let image: String
    //카테고리
    let category: String
}

enum SeminarCategory: String, CaseIterable {
    case fe = "FE"
    case be = "BE"
    case mobile = "Mobile"
    case uxui = "UX/UI"
    case ai = "AI"
}
