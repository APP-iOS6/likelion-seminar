//
//  AppliedSeminarView.swift
//  SeminarConsumer
//
//  Created by 최승호 on 10/7/24.
//

import SwiftUI

struct AppliedSeminarView: View {
    var seminars: [Seminar]
    let columns = [
        GridItem(.flexible()), // 첫 번째 열
        GridItem(.flexible())  // 두 번째 열
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) { // 두 개의 열로 구성된 그리드
                ForEach(seminars) { seminar in
                    SeminarCardView(seminar: seminar)
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    AppliedSeminarView(seminars: SampleData().createSampleData())
}
