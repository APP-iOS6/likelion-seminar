//
//  MyEventView.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/7/24.
//

import SwiftUI
import FirebaseAuth

struct MyEventView: View {
    var connectFirebase: ConnectFirebase = ConnectFirebase()
    var sampleData = SampleData().createSampleData()
    @State private var selectedTab: Tab = .seminars
    @State var isSignIn: Bool = false
    @State var isCheckApplication: Bool = false
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var seminars: [Seminar] = []
    
    enum Tab {
        case seminars
        case favorites
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                // 상단 '신청한 세미나', '관심' 탭버튼 뷰
                HStack {
                    // 신청한 세미나 탭 버튼
                    Button {
                        selectedTab = .seminars
                    } label: {
                        VStack {
                            Text("신청한 세미나")
                                .foregroundColor(selectedTab == .seminars ? .black : .gray)
                            Rectangle()
                                .fill(selectedTab == .seminars ? Color.red : Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .disabled(selectedTab == .seminars)
                    .frame(maxWidth: .infinity)
                    
                    // 관심 탭 버튼
                    Button {
                        selectedTab = .favorites
                    } label: {
                        VStack {
                            HStack{
                                Text("관심")
                                    .foregroundColor(selectedTab == .favorites ? .black : .gray)
                                Image(.heartFill)
                            }
                            Rectangle()
                                .fill(selectedTab == .favorites ? Color.red : Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .disabled(selectedTab == .favorites)
                    .frame(maxWidth: .infinity)
                }
                // 여기서 FavolritesView에서 세미나목록을 불러오고 있는데 여기서 세미나 0개일 때 뷰를 안띄워줘 버려서 안뜨고 있었음
                //if seminars.count != 0 {
                    if selectedTab == .seminars {
                        // '신청한 세미나' 뷰
                        AppliedSeminarView(seminars: seminars)
                    } else {
                        // '관심' 뷰
                        FavoritesView()
                    }
                //} else {
                    Spacer()
                //}
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: HStack {
                Image("LikeLionLogo") // 이미지 설정
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22) // 이미지 크기 조정
                    .padding(.leading, 10) // 왼쪽 여백 추가
                Spacer() // 왼쪽 정렬을 위해 Spacer 추가
            })
            
            if !isSignIn {
                Button {
                    isCheckApplication.toggle()
                } label: {
                    Text("비회원 신청 조회하기")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 15, weight: .bold))
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $isCheckApplication) {
                    VStack {
                        InputUserInformation(name: $name, email: $email)
                            .presentationDetents([.medium])
                        Button {
                            Task {
                                self.seminars = try await connectFirebase.getUserSeminars(User(name: name, email: email, phone: "", ticketCount: 0))
                            }
                            isCheckApplication.toggle()
                        } label: {
                            Text("신청 내용 조회하기")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 15, weight: .bold))
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .task() {
            isSignIn = AuthStore().checkLoginState()
            if isSignIn {
                let name = await AuthStore().getUserInfo().name
                let uid = Auth.auth().currentUser?.uid ?? ""
                
                Task {
                    self.seminars = try await connectFirebase.getAuthSeminars(uid)
                }
            }
        }
        .animation(.smooth, value: selectedTab)
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

#Preview {
    MyEventView()
}
