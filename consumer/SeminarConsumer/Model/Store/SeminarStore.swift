//
//  SeminarStore.swift
//  SeminarConsumer
//
//  Created by 최승호 on 10/8/24.
//

import Foundation

class SeminarStore {
    var seminar: Seminar?
    
    init(seminar: Seminar? = nil) {
        self.seminar = seminar
    }
    
    func getContent(from text: String) -> String {
        var resultText = ""
        var result = text.components(separatedBy: "\\n")
        
        result = result.map{
            "\($0)\n\n"
        }
        
        for txt in result {
            resultText += txt
        }
        return resultText
    }
}
