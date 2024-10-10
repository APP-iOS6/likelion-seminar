//
//  EditSeminarView.swift
//  likelion_seminar_admin
//
//  Created by 박범규 on 10/8/24.
//

import SwiftUI

struct EditSeminarView: View {
    @State var seminar: Seminar  // 수정할 세미나 정보
    @Environment(\.presentationMode) var presentationMode  // 뷰를 닫기 위한 환경 변수
    @ObservedObject var seminarStore: SeminarStore  // SeminarStore 객체
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("세미나 이름")) {
                    TextField("세미나 이름", text: $seminar.name)
                }
                Section(header: Text("세미나 장소")) {
                    TextField("장소", text: $seminar.location)
                }
                Section(header: Text("날짜 정보")){
                    DatePicker("세미나 시작 날짜", selection: $seminar.startDateForSeminar, displayedComponents: .date)
                    
                    DatePicker("세미나 종료 날짜", selection: $seminar.endDateForSeminar, displayedComponents: .date)
                    
                    DatePicker("모집 시작 날짜", selection: $seminar.startDateForApply, displayedComponents: .date)
                    
                    DatePicker("모집 종료 날짜", selection: $seminar.endDateForApply, displayedComponents: .date)
                }
                Section(header: Text("참가자 수")) {
                    TextField("참가자 수", value: $seminar.participants, formatter: NumberFormatter())
                }
                Section(header: Text("수용 인원")) {
                    TextField("수용 인원", value: $seminar.capacity, formatter: NumberFormatter())
                }
                
                Section(header: Text("세미나 내용")) {
                    TextEditor(text: $seminar.content)
                        .frame(height: 150)
                }
            }
            .navigationTitle("세미나 수정")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()  // 뷰 닫기
                    }
                    .foregroundStyle(Color.basicbutton)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        // 수정된 데이터를 Firestore에 저장하고, 데이터 다시 불러오기
                        Task {
                            await seminarStore.updateSeminar(seminar)
                            presentationMode.wrappedValue.dismiss()  // 저장 후 뷰 닫기
                        }
                    }
                    .foregroundStyle(Color.basicbutton)
                }
            }
        }
    }
}

//struct EditSeminarView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditSeminarView(seminar: Seminar(name: "Sample Seminar", startDateForSeminar: Date(), endDateForSeminar: Date(), startDateForApply: Date(), endDateForApply: Date(), content: "Sample Content", location: "Seoul", capacity: 100, participants: 90, image: "Seminar1", category: "Development"))
//    }
//}
