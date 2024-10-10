//
//  LoginView.swift
//  SeminarConsumer
//
//  Created by JunoLee on 10/8/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    // 알림 상태
    @State private var alertMessage: String?
    
    // 회원가입 상태
    @State private var isRegistered: Bool = false
    
    @EnvironmentObject var authStore: AuthStore
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showTermsOfService = false
    @State private var showPrivacyPolicy = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
                Text("SignUp")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 30)
                
                // 입력 필드
                VStack(spacing: 24) {
                    // 이메일 입력
                    VStack(alignment: .leading) {
                        CustomTextField(sfIcon: "at",
                                        hint: "이메일을 입력하세요.",
                                        value: $authStore.email,
                                        isError: alertMessage?.contains("이메일") ?? false)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                            .onChange(of: authStore.email) {
                                if isValidEmail(authStore.email) {
                                    alertMessage = nil
                                }
                            }
                        
                        if let message = alertMessage, message.contains("이메일") {
                            Text(message)
                                .foregroundStyle(.red)
                                .font(.footnote)
                                .padding(.leading, 40)
                        }
                    }
                    
                    // 비밀번호 입력
                    VStack(alignment: .leading) {
                        CustomTextField(sfIcon: "lock",
                                        hint: "비밀번호를 입력하세요.",
                                        isPassword: true,
                                        value: $authStore.password,
                                        isError: alertMessage?.contains("비밀번호") ?? false)

                        if let message = alertMessage, message.contains("비밀번호") {
                            Text(message)
                                .foregroundStyle(.red)
                                .font(.footnote)
                                .padding(.leading, 40)
                        }
                    }
                    
                    // 이름 입력
                    VStack(alignment: .leading) {
                        CustomTextField(sfIcon: "person",
                                        hint: "이름을 입력하세요.",
                                        value: $authStore.name,
                                        isError: alertMessage?.contains("이름") ?? false)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        if let message = alertMessage, message.contains("이름") {
                            Text(message)
                                .foregroundStyle(.red)
                                .font(.footnote)
                                .padding(.leading, 40)
                        }
                    }
                    
                    // 전화번호 입력
                    VStack(alignment: .leading) {
                        CustomTextField(sfIcon: "phone",
                                        hint: "전화번호를 입력하세요.",
                                        value: $authStore.phone,
                                        isError: alertMessage?.contains("전화번호") ?? false)
                            .autocapitalization(.none)
                            .keyboardType(.numberPad)
                            .onChange(of: authStore.phone) { newValue, _ in
                                // 숫자만 허용
                                authStore.phone = newValue.filter { "0123456789".contains($0) }
                            }
                        
                        if let message = alertMessage, message.contains("전화번호") {
                            Text(message)
                                .foregroundStyle(.red)
                                .font(.footnote)
                                .padding(.leading, 40)
                        }
                    }
                }
                    
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 0) {
                        Text("서비스 이용 시, 멋쟁이사자처럼 ")
                        
                        Text("서비스 이용 약관")
                            .foregroundStyle(.accent)
                            .underline()
                            .onTapGesture {
                                showTermsOfService.toggle()
                            }
                            .sheet(isPresented: $showTermsOfService) {
                                SafariView(url: URL(string: "https://likelion.notion.site/89ba1354b98d4825af14109aebdd3af9")!)
                            }
                        
                        Text(" 및 ")
                    }
                    
                    HStack(spacing: 0) {
                        Text("개인 정보 처리 방침")
                            .foregroundStyle(.accent)
                            .underline()
                            .onTapGesture {
                                showPrivacyPolicy.toggle()
                            }
                            .sheet(isPresented: $showPrivacyPolicy) {
                                SafariView(url: URL(string: "https://likelion.notion.site/4d3c7ce22a724b3c99950e853dc7589b")!)
                            }
                        
                        Text("에 동의하게 되니 참고해 주시기 바랍니다.")
                    }
                }
                .font(.caption)
                .foregroundColor(.gray)
                .lineSpacing(6)
                .padding(.horizontal, 6)
                
                // 회원가입 버튼
                Button(action: {
                    registerUser()
                }) {
                    if authStore.authenticationState != .authenticating {
                        Text("회원가입 후 입장하기")
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
                .padding(.top, 20)
                
                Spacer()
                
                HStack {
                    Text("이미 가입하셨나요?")
                        .foregroundStyle(.gray)
                    
                    Button("로그인 하러 가기") {
                        authStore.switchFlow()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 22)
    }
    
    private func registerUser() {
        alertMessage = nil // 오류 메시지 초기화
        
        guard validateInputs() else { return }
        
        Task {
            do {
                try await authStore.signup()
                
                // 입력 필드 초기화
                authStore.email = ""
                authStore.password = ""
                authStore.name = ""
                authStore.phone = ""
                
                // 회원가입 완료 상태 변경
                isRegistered = true
                
                dismiss()
            } catch let error as NSError {
                // Firebase AuthErrorCode에 따른 오류 메시지 처리
                handleAuthError(error)
            }
        }
    }
    
    private func validateInputs() -> Bool {
        guard !authStore.email.isEmpty else {
            alertMessage = "이메일을 입력해주세요."
            return false
        }
        
        guard isValidEmail(authStore.email) else {
            alertMessage = "유효한 이메일 주소를 입력해주세요."
            return false
        }
        
        guard !authStore.password.isEmpty else {
            alertMessage = "비밀번호를 입력해주세요."
            return false
        }
        
        guard !authStore.name.isEmpty else {
            alertMessage = "이름을 입력해주세요."
            return false
        }
        
        guard !authStore.phone.isEmpty else {
            alertMessage = "전화번호를 입력해주세요."
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // 이메일 정규 표현식 검사
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    // 파이어베이스 AuthError
    private func handleAuthError(_ error: NSError) {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            alertMessage = "알 수 없는 오류가 발생했습니다."
            return
        }
        
        switch errorCode {
        case .emailAlreadyInUse:
            alertMessage = "이메일이 이미 사용 중입니다."
        case .invalidEmail:
            alertMessage = "유효하지 않은 이메일입니다."
        case .weakPassword:
            alertMessage = "비밀번호는 최소 6자 이상이어야 합니다."
        default:
            alertMessage = "회원가입 중 오류가 발생했습니다."
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthStore())
}
