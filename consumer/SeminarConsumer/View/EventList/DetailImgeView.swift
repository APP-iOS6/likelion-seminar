//
//  DetailImgeView.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/7/24.
//

import SwiftUI

struct DetailImgeView: View {
    @AppStorage("favoritesID") private var favoritesID: [String] = []
    var seminar: Seminar
    let authStore: AuthStore = AuthStore()
    @State var isShowingAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 25) {
            //세미나 이미지
            AsyncImage(url: URL(string: seminar.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 230)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 350, height: 200)
            
            // 세미나 정보 박스
            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack{
                        Text(seminar.name)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true) //줄바꾸
                        Spacer()
                        Button{
                            if !favoritesID.contains(seminar.id) {
                                favoritesID.append(seminar.id)
                            } else {
                                let index = favoritesID.firstIndex(of: seminar.id)!
                                favoritesID.remove(at: index)
                            }
                        } label: {
                            Image(systemName: favoritesID.contains(seminar.id) ? "heart.fill" : "heart")
                                .foregroundStyle(.accent)
                                .font(.system(size: 24))
                        }
                    }
                    // TODO: 모집기간이 지난 세미나의 경우 "모집완료"로 변경
                    if seminar.endDateForApply < Date() || seminar.participants <= seminar.capacity {
                        Text("모집중")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: 0xD4D4D4), lineWidth: 1)
                                    .frame(width: 50, height: 20)
                            )
                            .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬 유지
                    } else {
                        Text("모집완료")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: 0xD4D4D4))
                                    .stroke(Color(hex: 0xD4D4D4), lineWidth: 1)
                                    .frame(width: 50, height: 20)
                            )
                            .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬 유지
                    }

                    
                    // 세미나 정보(일시,신청,,)
                    VStack(spacing: 7) {
                        HStack {
                            Text("일시")
                                .fontWeight(.bold)
                                .foregroundStyle(.gray)
                                .frame(width: 25, alignment: .leading)

                            
                            Text("\(formattedDateRange(start: seminar.startDateForSeminar, end: seminar.endDateForSeminar))")
                                .frame(maxWidth: .infinity, alignment: .bottomLeading)
                        }
                        
                        HStack {
                            Text("신청")
                                .fontWeight(.bold)
                                .foregroundStyle(.gray)
                                .frame(width: 25, alignment: .leading)

                            
                            Text("\(formattedDateRange(start: seminar.startDateForApply, end: seminar.endDateForApply))")
                                .frame(maxWidth: .infinity, alignment: .bottomLeading)
                        }
                        
                        HStack {
                            Text("인원")
                                .fontWeight(.bold)
                                .foregroundStyle(.gray)
                                .frame(width: 25, alignment: .leading)

                            
                            Text("\(seminar.participants) 명")
                                .frame(maxWidth: .infinity, alignment: .bottomLeading)
                        }
                        
                        HStack {
                            Text("장소")
                                .fontWeight(.bold)
                                .foregroundStyle(.gray)
                                .frame(width: 25, alignment: .leading)

                            
                            Text("\(seminar.location)")
                                .frame(maxWidth: .infinity, alignment: .bottomLeading)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 14))
                    
                }
            }
            .padding() // 전체 패딩
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .frame(width: 350)
        }
        .frame(width: 350)
    }
}

private func formattedDateRange(start: Date, end: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd(E) HH:mm"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    return "\(dateFormatter.string(from: start)) ~ \(dateFormatter.string(from: end))"
}

struct DetailImgeView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = SampleData()
        let seminars = sampleData.createSampleData()
        
       
        DetailImgeView(seminar: seminars[0])
    }
}

