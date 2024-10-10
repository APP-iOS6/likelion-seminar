//
//  FavoritesView.swift
//  SeminarConsumer
//
//  Created by 최승호 on 10/7/24.
//

import SwiftUI

struct FavoritesView: View {
    @AppStorage("favoritesID") private var favoritesID: [String] = []
    @State var seminars: [Seminar] = []
    let columns = [
        GridItem(.flexible()), // 첫 번째 열
        GridItem(.flexible())  // 두 번째 열
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) { // 두 개의 열로 구성된 그리드
                ForEach(seminars) { seminar in // 예시로 20개의 뷰를 표시
                    SeminarCardView(seminar: seminar)
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .task {
            // TODO: 파베에서 불러온 세미나들 중에서 favoritesID와 같은 id세미나만 seminars변수에 담기
            // MyEvent에서 수정 해서 해결함
            do {
                let seminars = try await ConnectFirebase().getSeminars()
                for seminar in seminars {
                    if self.favoritesID.contains(seminar.id) {
                        self.seminars.append(seminar)
                    }
                }
            } catch {
                print("failed to get seminars: \(error.localizedDescription)")
            }
            
        }
    }
    
    // sampleData에서 사용자가 등록한 favorite 세미나의 id값 배열과 일치하는 세미나들을 뽑아옴.
    private func getFavoriteSeminars() {
        seminars = SampleData().createSampleData().filter {
            return favoritesID.contains($0.id)
        }
    }
}

#Preview {
    FavoritesView()
}
