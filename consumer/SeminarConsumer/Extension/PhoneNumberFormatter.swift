//
//  PhoneNumberFormatter.swift
//  SeminarConsumer
//
//  Created by Hyojeong on 10/10/24.
//

import Foundation

// Setting View 회원 정보에서 전화번호를 형식에 맞춰 보여주기 위함
extension String {
    // 전화번호 형식으로 변환하는 함수
    func formattedPhoneNumber() -> String {
        let numbersOnly = self.filter { "0123456789".contains($0) } // 숫자만 남김
        let pattern = "(\\d{3})(\\d{4})(\\d+)" // 3자리, 4자리, 나머지
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: numbersOnly.count)
        
        if let match = regex?.firstMatch(in: numbersOnly, options: [], range: range) {
            let first = (numbersOnly as NSString).substring(with: match.range(at: 1))
            let second = (numbersOnly as NSString).substring(with: match.range(at: 2))
            let third = (numbersOnly as NSString).substring(with: match.range(at: 3))
            return "\(first)-\(second)-\(third)"
        }
        
        return self // 변환에 실패하면 원래 문자열을 반환
    }
}
