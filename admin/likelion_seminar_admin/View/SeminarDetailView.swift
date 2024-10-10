//
//  DetailView.swift
//  likelion_seminar_admin
//
//  Created by 강희창 on 10/8/24.
//

import SwiftUI

struct SeminarDetailView: View {
    @State private var isEditPresented = false
    let seminar: Seminar  // 세미나 정보를 받는 변수
    @ObservedObject var seminarStore: SeminarStore  // SeminarStore 객체를 추가
    
    var body: some View {
        ScrollView {
            // 이미지와 세부 정보를 나란히 배치하는 HStack
            HStack(alignment: .top, spacing: 10) {
                // 이미지 크기 조정
                AsyncImage(url: URL(string: seminar.image)) {
                    image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .frame(maxWidth: 500, maxHeight: 300)
                } placeholder: {
                    ProgressView()
                }
                //                .frame(width:300)
                .padding(.leading, 30)
                .padding(.trailing,30)
                VStack(alignment: .leading, spacing: 10) {
                    Text(seminar.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    Text("장소: \(seminar.location)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("수용인원: \(seminar.capacity)")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("참여인원: \(seminar.participants)")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    
                    Text("세미나 기간: \(formattedDate(seminar.startDateForSeminar)) - \(formattedDate(seminar.endDateForSeminar))")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
    
                    Text("모집 기간: \(formattedDate(seminar.startDateForApply)) - \(formattedDate(seminar.endDateForApply))")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.subheadline)
                .padding(10)  // 텍스트 섹션을 감싸는 패딩 추가
                .frame(width: 400, height: 280)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6)))
                .frame(maxWidth: 500)  // 텍스트 섹션의 최대 너비를 제한
                .padding(.trailing, 30)  // 오른쪽 끝에서 30포인트 떨어지게 설정
            }
            .padding(.horizontal, 30)  // 전체 HStack을 양쪽 끝에서 30만큼 떨어지게 설정
            .padding(.vertical, 30)    // 세로 간격 조정
            
            // 콘텐츠 내용
            VStack(alignment: .leading) {
                Text("세미나 내용")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.vertical, 5)
                
                Text(seminar.content)
                    .font(.body)
                    .padding(.vertical)
                
                // 참가자 목록
                Section(header: HStack {
                    Text("이름").frame(width: 100, alignment: .leading)
                    Text("전화번호").frame(width: 150, alignment: .leading)
                    Text("이메일")
                }) {
                    ForEach(seminarStore.participants, id: \.id) { participant in
                        HStack {
                            
                            Text(participant.name).frame(width: 100, alignment: .leading)
                            Text(participant.phone).frame(width: 150, alignment: .leading)
                            Text(participant.email)
                        }
                    }
                }
                .listStyle(.inset)
                
                // 총 참가자 수
                Text("총 참가 인원: \(seminarStore.participants.count)명")
                    .font(.headline)
                    .padding()
                
            }
            .padding(.horizontal, 40)  // 콘텐츠 섹션도 화면 끝에서 떨어지도록 설정
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6)))
            .padding(.horizontal)
        }
        .task {
            await seminarStore.fetchParticipants(seminar.id)
        }
        .navigationTitle(seminar.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        isEditPresented = true
                    }) {
                        Text("수정")
                            .foregroundStyle(Color.basicbutton)
                    }
                    .sheet(isPresented: $isEditPresented) {
                        EditSeminarView(seminar: seminar, seminarStore: seminarStore)
                    }
                }
            }
        }
    }
    
    // 날짜 포맷 함수
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}



