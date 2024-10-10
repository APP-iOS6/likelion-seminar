//
//  SeminarCardView.swift
//  SeminarConsumer
//
//  Created by 최승호 on 10/7/24.
//

import SwiftUI

struct SeminarCardView: View {
    var seminar: Seminar
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                NavigationLink(destination: EventDetailView(seminar: seminar)) {
                    EventCard(seminar: seminar)
                }
                
                HStack{
                    Spacer()
                    VStack(alignment: .trailing){
                        // TODO: AppStorage에 저장된 즐겨찾기 세미나의 경우에만 heart.fill으로
                        Image(.heartFill)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .padding(8)
                        
                        Spacer()
                        
                        // TODO: endDateForApply가 지난경우 Image(.completed)로 변경
                        Image(.recruiting)
                            .aspectRatio(contentMode: .fit)
                            .padding(8)
                            .offset(x: 3, y: -52)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .cornerRadius(10)
    }
}

#Preview {
    SeminarCardView(seminar: SampleData().createSampleData()[1])
}
