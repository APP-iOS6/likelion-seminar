//
//  EventDetailView.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/7/24.
//

import SwiftUI

struct EventDetailView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var authStore: AuthStore
    
    let seminar: Seminar
    @State private var content: String = ""
    var seminarStore = SeminarStore()
    @State private var isPresented: Bool = false
    @State private var toast: FancyToast? = nil
    //@State private var imageResource: ImageResource = .applyButton
    @State private var showToast: FancyToast? = nil
    
    @State private var isApplied: Bool = false
    @State private var isShowQRSheet: Bool = false
    @State private var isShowCancleAlert: Bool = false
    @State private var userInfo: (String, String, String) = ("name", "email", "phone")
    var ApplyingButton: ImageResource{
        isApplied ? .applyDisableButton : .applyButton
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {   // 왼쪽 정렬
                    DetailImgeView(seminar: seminar)
                        .padding(.top) // 상단 여백 추가
                    
                        Text(content)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(7) // 행 간격 추가
                            .padding(.top) // 상단 여백 추가
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            .toolbar {
                if isApplied {
                    Button{
                        isShowQRSheet.toggle()
                    } label: {
                        Text("입장 코드")
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowQRSheet) {
                QRCodeSheetView(text: "https://www.instagram.com/dk_dk0422/", isPresented: $isShowQRSheet, seminar: seminar, userName: userInfo.0)
                    .background(Color.black.opacity(0.6))
            }
            
            .toolbar {
                if isApplied {
                    Button{
                        isShowCancleAlert.toggle()
                    } label: {
                        Text("신청 취소")
                    }
                }
            }
            .alert(isPresented: $isShowCancleAlert) {
                Alert(
                    title: Text("관리자 문의 필요"),
                    message: Text("세미나 신청 취소는 관리자에게 문의해 주시기 바랍니다.\nhttps://likelion.net/my/courses")
                )
                
            }
            
            Button(action: {
                isPresented.toggle()
            }, label: {
                if isApplied{
                    Image(.completeButton)
                } else {
                    Image(.applyButton)
                }
            })
            .sheet(isPresented: $isPresented){
                ApplicationFormView(selectedSeminar: seminar,
                                    toast: $toast,
                                    isComplete: $isPresented,
                                    isApplied: $isApplied
                )
            }.disabled(isApplied)
        }
        .toastView(toast: $toast)
        .task {
            seminarStore.seminar = seminar
            self.content = seminarStore.getContent(from: seminar.content)
            do{
                print(isApplied)
                isApplied = try await authStore.getIsApplied(id: seminar.id)
                print(isApplied)
            }catch{
                print(error)
            }
            userInfo = await authStore.getUserInfo()
        }
    }
}

#Preview {
    EventDetailView(seminar: SampleData().createSampleData()[0])
        .environmentObject(AuthStore())
}
