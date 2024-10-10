//
//  SettingView.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/7/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var isShowingDeleteAcountAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            // 회원 정보
            HStack {
                Image(.likeLion)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                VStack(alignment: .leading) {
                    Text(authStore.authenticationState != .tempAuthenticated ? authStore.name : "비회원")
                        .font(.headline)
                    
                    Text(authStore.email)
                        .foregroundStyle(.secondary)
                    
                    Text(authStore.phone.formattedPhoneNumber())
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .strokeBorder(.accent, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            
            List {
                NavigationLink("FAQ") {
                    FaqView()
                }
                
                NavigationLink("Developers") {
                    DevelopersListView()
                }
                
                Section("계정") {
                    Button("로그아웃") {
                        authStore.logout()
                    }
                    
                    if authStore.authenticationState != .tempAuthenticated {
                        Button("계정 탈퇴") {
                            isShowingDeleteAcountAlert.toggle()
                        }
                        .foregroundStyle(.red)
                    }
                }
                .navigationTitle("설정")
            }
            .listStyle(.plain)
        }
        .customAlert(
            isPresented: $isShowingDeleteAcountAlert,
            transition: .scale.combined(with: .opacity),
            title: "계정을 탈퇴합니다",
            message: "탈퇴 후 삭제되는 모든 정보는 복구할 수 없습니다.",
            primaryButtonTitle: "탈퇴") {
                Task {
                    await authStore.deleteAccount()
                }
            }
        .task {
            if authStore.authenticationState == .authenticated {
                let (name, email, phone) = await authStore.getUserInfo()
                authStore.name = name
                authStore.email = email
                authStore.phone = phone
            }
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(AuthStore())
}
