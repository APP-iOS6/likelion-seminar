//
//  HomeView.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/7/24.
//

import SwiftUI

struct EventListView: View {
    @State private var searchText: String = ""
    @State private var seminars: [Seminar] = []
    var seminarCategories = SeminarCategory.allCases
    var connectFirebase: ConnectFirebase = ConnectFirebase()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 검색창 추가
                    SearchBar(search: $searchText)
                    
                    EventSectionView(title: "프론트-엔드 세미나 모음", seminars: filteredSeminars(in: SeminarCategory.fe))
                    EventSectionView(title: "백-엔드 세미나 모음", seminars: filteredSeminars(in: SeminarCategory.be))
                    EventSectionView(title: "앱개발 세미나 모음", seminars: filteredSeminars(in: SeminarCategory.mobile))
                    EventSectionView(title: "UI/UX 세미나 모음", seminars: filteredSeminars(in: SeminarCategory.uxui))
                    EventSectionView(title: "Ai 세미나 모음", seminars: filteredSeminars(in: SeminarCategory.ai))
                }
                .padding(.horizontal, 3) // 모든 VStack에 동일한 좌우 여백 추가
            }
            .refreshable{
                Task {
                    seminars = try await connectFirebase.getSeminars()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: HStack {
                Image("LikeLionLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
                    .padding(.leading, 10)
                Spacer()
            })
        }
        .onAppear {
            Task {
                seminars = try await connectFirebase.getSeminars()
            }
        }// 키보드 내리는 제스처
        .gesture(
            TapGesture()
                .onEnded { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
    }
    
    
    private func filteredSeminars(in category: SeminarCategory) -> [Seminar] {
        let seminars = self.seminars.filter{ $0.category == category.rawValue }
        
        if searchText.isEmpty {
            return seminars // 검색어가 비어있으면 모든 세미나 반환
        } else {
            return seminars.filter { seminar in
                seminar.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var search: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("원하는 이벤트를 검색해보세요.", text: $search)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
                .focused($isFocused)
            
            if !search.isEmpty {
                Button(action: {
                    withAnimation {
                        search = ""
                    }
                }) {
                    Text("Cancel")
                        .foregroundColor(.orange)
                        .padding(.trailing, 10)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct EventSectionView: View {
    let title: String
    let seminars: [Seminar]
    
    var body: some View {
        if !seminars.isEmpty {  // 검색결과가 없을 경우에는 뷰가 안 나타남
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.leading) // 제목도 여백 일치

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(seminars) { seminar in
                            NavigationLink(destination: EventDetailView(seminar: seminar)) {
                                EventCard(seminar: seminar)
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                    .padding([.bottom, .leading]) // 콘텐츠 좌우 여백 유지
                }
            }
            .padding(.horizontal, 3) // 섹션의 좌우 여백을 일관성 있게 추가
        }
    }
}

struct EventCard: View {
    var seminar: Seminar
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: seminar.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 100)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 100)
            
            Text(seminar.name)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.top, 5)
            
            Text(formatDate(seminar.startDateForSeminar, endDate: seminar.endDateForSeminar))
                .lineLimit(2)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(width: 200, alignment: .leading)
        .cornerRadius(12)
    }
    
    // 날짜 포맷터
    private func formatDate(_ startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M/d(E) H:mm"
        let startDate = dateFormatter.string(from: startDate)
        
        dateFormatter.dateFormat = "H:mm"
        let endDate = dateFormatter.string(from: endDate)
        return "\(startDate) ~ \(endDate)"
    }
}

struct SeminarDetailView: View {
    var seminar: Seminar
    
    var body: some View {
        VStack {
            Text(seminar.name)
                .font(.system(size: 16, weight: .bold))
                .padding()
            Text(seminar.content)
                .font(.system(size: 12, weight: .regular))
                .padding()
            Spacer()
        }
        .navigationTitle("세미나 상세")
    }
}

#Preview {
    EventListView()
}
