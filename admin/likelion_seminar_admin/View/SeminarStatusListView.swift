//
//  SeminarStatusListView.swift
//  likelion_seminar_admin
//
//  Created by Hwang_Inyoung on 10/7/24.

import SwiftUI

struct SeminarStatusListView: View {
    @StateObject var seminarUserStore = SeminarUserStore()
    let seminar: Seminar

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 세미나 정보
                VStack(alignment: .leading, spacing: 10) {
                    Text(seminar.name)
                        .font(.title)
                        .fontWeight(.bold)
                    VStack(alignment: .leading) {
                        Text("일시: \(seminar.startDateForSeminar)")
                        Text("장소: \(seminar.location)")
                        Text("모집기한: \(seminar.startDateForApply)")
                        Text("모집인원: \(seminar.endDateForApply)명")
                    }
                    .font(.subheadline)
                    Text("세미나 내용:")
                        .font(.headline)
                    Text(seminar.content)
                        .font(.body)
                        .padding(.top, 5)
                }
                .padding()
                
                // 참가자 목록
                    Section(header: HStack {
                        Text("이름").frame(width: 100, alignment: .leading)
                        Text("전화번호").frame(width: 150, alignment: .leading)
                        Text("이메일")
                    }) {
                        ForEach(seminarUserStore.participants, id: \.id) { participant in
                            HStack {
                                
                                Text(participant.name).frame(width: 100, alignment: .leading)
                                Text(participant.phone).frame(width: 150, alignment: .leading)
                                Text(participant.email)
                            }
                        }
                    }
                .listStyle(.inset)
                
                // 총 참가자 수
                Text("총 참가 인원: \(seminarUserStore.participants.count)명")
                    .font(.headline)
                    .padding()
                
                Spacer()
            }
            .task {
                await seminarUserStore.fetchParticipants(seminar.id)
            }
        }
        .padding()
    }
}

#Preview {
    SeminarStatusListView(seminar: Seminar(name: "Sample Seminar", startDateForSeminar: Date(), endDateForSeminar: Date(), startDateForApply: Date(), endDateForApply: Date(), content: "Sample Content", location: "Seoul", capacity: 100, participants: 90, image: "Seminar1", category: "Development"))
}
