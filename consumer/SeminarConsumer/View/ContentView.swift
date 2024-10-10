//
//  ContentView.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/7/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        switch authStore.authenticationState {
        // 미로그인, 로그인 중일 때
        case .unauthenticated, .authenticating:
            if authStore.flow == .login {
                LoginView()
            } else {
                SignUpView()
            }
        
        // 로그인된 상태
        case .authenticated, .tempAuthenticated:
            TabView {
                //이벤트 목록
                EventListView()
                    .tabItem{
                        Image(systemName: "list.bullet")
                        Text("이벤트목록")
                    }
                
                //나의 이벤트
                MyEventView()
                    .tabItem{
                        Image(systemName: "person.crop.circle")
                        Text("나의이벤트")
                    }
                //설정
                SettingView()
                    .tabItem{
                        Image(systemName: "gear")
                        Text("설정")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthStore())
}
