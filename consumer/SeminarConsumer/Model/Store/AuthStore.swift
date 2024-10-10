//
//  AuthStore.swift
//  SeminarConsumer
//
//  Created by Hyojeong on 10/8/24.
//

import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

// 인증 처리 상태(로그인 상태)
enum AuthenticationState {
    case unauthenticated // 인증 안 됨!
    case authenticating // 인증 진행 중!
    case authenticated // 인증 완료
    case tempAuthenticated // 비회원 인증
}

// 현재 보이는 인증 화면
enum AuthenticationFlow {
    case login // 로그인 화면
    case signup // 회원가입 화면
}

@MainActor
class AuthStore: ObservableObject {
    // 회원가입에 필요한 유저 정보 4개
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var phone: String = ""
    
    @Published var user: FirebaseAuth.User?
    @Published var flow: AuthenticationFlow = .login
    @Published var authenticationState: AuthenticationState = .unauthenticated
    private var authStateHandler: AuthStateDidChangeListenerHandle? // 로그인 상태 변경 감지
    
    @Published var errorMessage: String = ""
    
    private var connectFirebase = ConnectFirebase()
    
    init() {
        registerAuthStateHandler()
    }
    
    // 로그아웃 함수
    func logout() {
        if authenticationState == .tempAuthenticated {
            authenticationState = .unauthenticated
        }
        do {
            try Auth.auth().signOut()
            reset()
        } catch {
            print("Error logging out: \(error)")
            errorMessage = error.localizedDescription
        }
    }
    
    // 계정 탈퇴
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            reset()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    // 로그인 함수
    func login() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            return true
        } catch {
            let nsError = error as NSError
            print("Error signing in: \(nsError.code), \(nsError.localizedDescription)")
            authenticationState = .unauthenticated
            
            switch nsError.code {
            case AuthErrorCode.wrongPassword.rawValue:
                errorMessage = "비밀번호 오류"
                
            case AuthErrorCode.userNotFound.rawValue:
                errorMessage = "계정을 찾을 수 없음"
                
            case AuthErrorCode.invalidEmail.rawValue:
                errorMessage = "올바르지 않은 이메일 형식"
                
            default:
                errorMessage = "Unknown error"
            }
            return false
        }
    }
    
    // 비회원 로그인
    func loginWithOutAuth() -> (){
        authenticationState = .tempAuthenticated
    }
    
    // 회원가입 함수
    func signup() async throws {
        authenticationState = .authenticating
        do {
            let signupResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Firestore에 저장할 데이터 설정
            let newUser = User(id: signupResult.user.uid, name: name, email: email, phone: phone, ticketCount: 0)
            
            try await connectFirebase.uploadUser(newUser)
        } catch {
            print("Error signing up: \(error)")
            authenticationState = .unauthenticated
            throw error
        }
    }
    
    // 로그인 상태 확인 함수
    func checkLoginState() -> Bool {
        let user = Auth.auth().currentUser
        
        if user != nil {
            return true
        } else {
            return false
        }
    }
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = (user == nil) ? .unauthenticated : .authenticated
                //self.name = user?.uid ?? "" // 될라나?
            }
        }
    }
    
    func switchFlow() {
        flow = (flow == .login) ? .signup : .login
        errorMessage = ""
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        name = ""
        phone = ""
    }
    
    // 로그인 되어있다면 이름, 이메일을 가져오는 함수
    func getUserInfo() async -> (name: String, email: String, phoneNumber: String) {
        let db = Firestore.firestore()
        do{
            if let user = Auth.auth().currentUser{
                let userDocu = try await db.collection("User").document(user.uid).getDocument()
                let name = userDocu["name"] as? String ?? ""
                let email = userDocu["email"] as? String ?? ""
                let phoneNumber = userDocu["phone"] as? String ?? ""
                return (name, email, phoneNumber)
            }
        }catch{
            print(error)
        }
        return ("","","")
//        if let user = Auth.auth().currentUser {
//            return (user.uid, user.email ?? "", user.phoneNumber ?? "")
//        } else {
//            return ("","","")
//        }
    }
    //로그인한 유저가 선택된 세미나를 신청했는지 여부를 반환
    func getIsApplied(id: String) async throws -> Bool{
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else{
            return false
        }

        do {
            //print("dd\(userId)")
            return try await db.collection("Seminar").document(id).collection("Participant").document(userId).getDocument().exists
        }catch{
            return false
        }
        
        
//        do{ //해당 세미나의 참여자에 유저가 있으면 true 반환
//            return try await db.collection("Seminar").document(id).collection("Participants").document(userId).getDocument().exists
//            //return true
//        }catch{ //아니면 false
//            print(error)
//            return false
//        }
        
    }
}
