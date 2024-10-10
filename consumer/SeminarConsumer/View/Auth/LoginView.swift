//
//  LoginView.swift
//  SeminarConsumer
//
//  Created by Hyojeong on 10/8/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @State private var isLoginSuccess: Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var loginErrortoast: FancyToast?
    
    // 이메일과 비밀번호 비었을 때 오류 텍스트
    @State private var emailError: String?
    @State private var passwordError: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Image(.likeLionLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
                Text("Login")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                CustomTextField(sfIcon: "at",
                                hint: "Email",
                                value: $authStore.email,
                                isError: authStore.errorMessage == "올바르지 않은 이메일 형식" || emailError != nil)
                .textInputAutocapitalization(.never) // 첫글자 자동 대문자 X
                .disableAutocorrection(true) // 자동 교정 비활성화
                .keyboardType(.emailAddress)
                
                // 이메일 형식 오류 텍스트 표시
                errorTextView(message: emailError ?? (authStore.errorMessage == "올바르지 않은 이메일 형식" ? authStore.errorMessage : nil))
                                    .padding(.top, -15)
                                    .padding(.leading, 40)
                
                CustomTextField(sfIcon: "lock",
                                hint: "Password",
                                isPassword: true,
                                value: $authStore.password,
                                isError: authStore.errorMessage == "비밀번호 오류" || passwordError != nil)
                .textInputAutocapitalization(.never) // 첫글자 자동 대문자 X
                .disableAutocorrection(true) // 자동 교정 비활성화
                .padding(.top, -15)
                
                // 비밀번호 오류 텍스트 표시
                errorTextView(message: passwordError ?? (authStore.errorMessage == "비밀번호 오류" ? authStore.errorMessage : nil))
                    .padding(.top, -15)
                    .padding(.leading, 40)
                
                // 로그인 버튼
                Button {
                    handleLogin()
                } label: {
                    if authStore.authenticationState != .authenticating {
                        Text("로그인")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.button)
                            .foregroundStyle(.white)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.button)
                            .tint(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } 
                }
                .padding(.top, 10)
                
                // 비회원 로그인 버튼
                Button {
                    authStore.loginWithOutAuth()
                } label: {
                    Text("비회원으로 로그인")
                        .underline()
                }
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    Text("계정이 없으신가요?")
                        .foregroundStyle(.gray)
                    
                    Button("회원가입하러 가기") {
                        authStore.switchFlow()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            .toastView(toast: $loginErrortoast)
        }
    }
    
    // MARK: - 오류 메시지 ViewBuilder
    @ViewBuilder
    private func errorTextView(message: String?) -> some View {
        if let message = message {
            Text(message)
                .foregroundStyle(.red)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 5) // 고정된 높이 추가
        } else {
            Spacer()
                .frame(height: 5) // 고정된 높이 유지
        }
    }
    
    // MARK: - 로그인 처리 함수
    private func handleLogin() {
        // 이메일과 비밀번호가 비어있을 때 오류 메시지 설정
        if authStore.email.isEmpty {
            emailError = "이메일을 입력해 주세요"
        } else {
            emailError = nil
        }
        
        if authStore.password.isEmpty {
            passwordError = "비밀번호를 입력해 주세요"
        } else {
            passwordError = nil
        }
        
        // 이메일과 비밀번호가 모두 입력된 경우에만 로그인 시도
        if !authStore.email.isEmpty && !authStore.password.isEmpty {
            Task {
                let success = await authStore.login()
                if success {
                    isLoginSuccess = true
                } else {
                    if authStore.errorMessage == "계정을 찾을 수 없음" {
                        loginErrortoast = FancyToast(type: .error,
                                                     title: authStore.errorMessage,
                                                     message: "\(authStore.email)에 연결된 계정을 찾을 수 없습니다. 다른 이메일 주소를 사용해주세요.")
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthStore())
}
