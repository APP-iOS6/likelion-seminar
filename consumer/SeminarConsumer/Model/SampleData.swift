//
//  SampleData.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/7/24.
//

import Foundation

class SampleData {
    func createSampleData() -> [Seminar] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //dateFormatter.dateFormat = "yyyy/MM/dd"
        
        // 샘플 세미나 1
        let seminar1 = Seminar(
            name: "iOS 앱 개발 워크샵",
            startDateForSeminar: dateFormatter.date(from: "2024/10/15")!,
            endDateForSeminar: dateFormatter.date(from: "2024/10/17")!,
            startDateForApply: dateFormatter.date(from: "2024/10/01")!,
            endDateForApply: dateFormatter.date(from: "2024/10/10")!,
            content: "Swift와 SwiftUI를 사용하여 iOS 애플리케이션 개발에 대해 배웁니다.",
            location: "서울 멋사 사무실",
            capacity: 50,
            participants: 30,
            image: "https://likelion.net/_next/image?url=https%3A%2F%2Fd35ai18pny966l.cloudfront.net%2Fcourse%2Fkdt%2Fdesign%2F3rd%2Fthumbnail_design_3rd.png&w=640&q=75",
            category: SeminarCategory.fe.rawValue
        )
        
        // 샘플 세미나 2
        let seminar2 = Seminar(
            name: "AI와 머신러닝 기초 세미나",
            startDateForSeminar: dateFormatter.date(from: "2024/11/10")!,
            endDateForSeminar: dateFormatter.date(from: "2024/11/12")!,
            startDateForApply: dateFormatter.date(from: "2024/10/25")!,
            endDateForApply: dateFormatter.date(from: "2024/11/05")!,
            content: "머신러닝의 기초 개념과 실습을 통해 AI를 이해하는 세미나입니다.",
            location: "부산 멋사 지점",
            capacity: 100,
            participants: 75,
            image: "test_card_image",
            category: SeminarCategory.fe.rawValue
        )
        
        // 샘플 세미나 3
        let seminar3 = Seminar(
            name: "웹 개발 풀스택 과정",
            startDateForSeminar: dateFormatter.date(from: "2024/12/01")!,
            endDateForSeminar: dateFormatter.date(from: "2024/12/03")!,
            startDateForApply: dateFormatter.date(from: "2024/11/10")!,
            endDateForApply: dateFormatter.date(from: "2024/11/20")!,
            content: "HTML, CSS, JavaScript와 같은 기술을 활용한 풀스택 웹 개발 과정입니다.",
            location: "대전 멋사 센터",
            capacity: 70,
            participants: 60,
            image: "web_fullstack_image",
            category: SeminarCategory.fe.rawValue
        )
        
        return [seminar1, seminar2, seminar3]
    }
    
    func createUserSampleData() -> [User] {
        return [
            User(name: "대동경", email: "dongdong@example.com", phone: "010-1234-5678", ticketCount: 1),
            User(name: "김철수", email: "chulsoo@example.com", phone: "010-2345-6789", ticketCount: 2),
            User(name: "박영희", email: "younghee@example.com", phone: "010-3456-7890", ticketCount: 1)
        ]
    }
    
}
