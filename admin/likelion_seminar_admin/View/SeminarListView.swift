import SwiftUI

struct SeminarListView: View {
    @StateObject private var seminarStore = SeminarStore()
    @State private var selectedCategory: String = "All"
    let categories: [String] = ["All"] + SeminarCategory.allCases.map { $0.rawValue }
    
    var body: some View {
        NavigationStack {
            VStack {
                // 카테고리 선택 Picker
                Picker("카테고리 선택", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // 그리드 구성
                GeometryReader { geometry in
                    let isPortrait = geometry.size.width < geometry.size.height
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: isPortrait ? 2 : 4)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(seminarStore.filteredSeminars(for: selectedCategory)) { seminar in
                                NavigationLink(destination: SeminarDetailView(seminar: seminar, seminarStore: seminarStore)) {
                                    
                                    VStack(alignment: .leading) {
                                        SeminarImageView(imageURL: seminar.image, geometry: geometry, isPortrait: isPortrait)
                                        
                                        // 세미나 정보
                                        Text(seminar.name)
                                            .font(.headline)
                                            .padding(.top, 5)
                                        
                                        if let startDate = formattedDate(seminar.startDateForSeminar)
                                        {
                                            Text("날짜: \(startDate)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            Text("시간: \(formattedTime(seminar.startDateForSeminar)) ~ \(formattedTime(seminar.endDateForSeminar))")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("LikeLionLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 260, height: 50)  // 적절한 크기로 조정
                }
                
                ToolbarItem {
                    NavigationLink {
                        CreateSeminarContainerView() {
                            Task {
                                await seminarStore.fetchSeminars()
                            }
                        }
                    } label: {
                        HStack {
                            Text("세미나 등록")
                                .foregroundStyle(.basicbutton)
                            Image(systemName: "plus")
                                .tint(.basicbutton)
                        }
                        .font(.title3)
                    }
                }
                ToolbarItem {
                    NavigationLink {
                        FAQListView()
                    } label: {
                        Text("FAQ")
                            .bold()
                            .foregroundStyle(.basicbutton)
                    }
                }
            }
            .padding(.top)
        }
    }
    
    // 날짜 및 시간 포맷 함수들
    func formattedDate(_ date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    SeminarListView()
}
