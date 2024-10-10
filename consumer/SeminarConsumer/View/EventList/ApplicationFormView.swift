//
//  ApplicationFormView.swift
//  SeminarConsumer
//
//  Created by 이소영 on 10/7/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct ApplicationFormView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var ticketCount: Int = 1
    @State var isSureToApply: Bool = false
    var connectFirebase: ConnectFirebase = ConnectFirebase()
    @State var selectedSeminar: Seminar
    var authStore: AuthStore = AuthStore()
    
    @Binding var toast: FancyToast?
    @Binding var isComplete: Bool
    @Binding var isApplied: Bool
    
    @State private var user: User? = nil
    var body: some View {
        NavigationStack {
            ScrollView {
                DetailImgeView(seminar: selectedSeminar)
                    .padding()
                
                HStack {
                    Text("총 \(ticketCount)장")
                        .frame(height: 30)
                        .fontWeight(.bold)
                        .padding(4)
                    Spacer()
                    
                    Stepper("", value: $ticketCount, in: 1...10)
                        .labelsHidden() // 스탭퍼 텍스트 숨김
                }
                .font(.system(size: 16))
                .padding(10) // 내부 패딩 추가
                .background(Color(hex: 0xF2F4F5))
                .cornerRadius(12)
                .padding(.horizontal) // 외부 패딩
                
                InputUserInformation(name: $name, email: $email)
                TextFieldFormView(text: $phone, tag: "전화번호", isNeccessary: true)
                    .padding(.bottom, 160)
            }
            .padding()
            
            // TODO: currentUser가 이미 신청한 세미나인 경우 버튼 '신청완료'버튼으로 변경
            if true {   // 신청하기 버튼
                Button {
                    isSureToApply.toggle()
                    
                    if let id = Auth.auth().currentUser?.uid{
                        user = User(id: id, name: name, email: email, phone: phone, ticketCount: ticketCount)
                    }else{
                        user = User(name: name, email: email, phone: phone, ticketCount: ticketCount)
                    }
                    
                    Task {
                        if let user{
                            let isSucess = try await connectFirebase.applyForNewSeminar(selectedSeminar, user: user)
                            if isSucess {
                                let sucessToast = FancyToast(type: .success, title: "신청 완료!", message: "해당 세미나에 참가 신청이 완료되었습니다.")
                                toast = sucessToast
                                isApplied = true
                            }else{
                                let failToast = FancyToast(type: .error, title: "신청 실패", message: "errorMessage예정")
                                toast = failToast
                            }
                            dismiss()
                        }else{
                            print("error: user is nil")
                        }

                    }
                    //isComplete.toggle()
                } label: {
                    if name.isEmpty || email.isEmpty || phone.isEmpty {
                        Image(.applyDisableButton)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 16)
                            .padding(.top, -15)
                    } else {
                        Image(.applyButton)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 16)
                            .padding(.top, -15)
                    }
                }
                .disabled(name.isEmpty || email.isEmpty || phone.isEmpty)
                .task {
                    let (name, email, phone) = await authStore.getUserInfo()
                    self.name = name
                    self.email = email
                    self.phone = phone
                }
            } else {    // 신청완료 버튼
                Image(.completeButton)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 16)
                    .padding(.top, -15)
            }
        }
        .padding(.horizontal, 9)
    }
}

struct InputUserInformation: View {
    @Binding var name: String
    @Binding var email: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            Text("신청자 정보")
                .font(.system(size: 16, weight: .bold))
                .padding()
                .offset(y: 20)
            
            TextFieldFormView(text: $name, tag: "이름", isNeccessary: true)
            TextFieldFormView(text: $email, tag: "이메일", isNeccessary: true)
        }
        .offset(y: -19)
    }
}

struct TextFieldFormView: View {
    @Binding var text: String
    var tag: String
    var isNeccessary: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(tag).font(.system(size: 13)) + Text("*").font(.system(size: 10)).foregroundStyle(isNeccessary ? .red : .clear)
            }
            TextField("", text: $text)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    ApplicationFormView(selectedSeminar: SampleData().createSampleData().first!)
//}
