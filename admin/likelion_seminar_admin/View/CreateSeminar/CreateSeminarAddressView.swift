//
//  CreateSeminarAddressView.swift
//  likelion_seminar_admin
//
//  Created by 김동경 on 10/7/24.
//

import SwiftUI
import PhotosUI

struct CreateSeminarAddressView: View {
    
    @ObservedObject var viewModel: CreateSeminarViewModel
    @State private var memberCount: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("세미나 장소와 수용인원을\n입력해 주세요.")
                .bold()
                .font(.title)
                .padding(.bottom)
            
            Text("장소")
                .foregroundStyle(.secondary)
                .font(.body)
                .padding(.vertical)
            
            TextField("세미나 장소를 입력해 주세요.", text: $viewModel.seminar.location)
                .textFieldStyle(.automatic)
                .overlay(alignment: .bottom) {
                    Divider()
                        .offset(y: 3)
                }
                .font(.title3)
                .padding(.bottom)
            
            Text("세미나 수용인원")
                .foregroundStyle(.secondary)
                .font(.body)
                .padding(.vertical)
            
            HStack(alignment: .center) {
                Text("최대")
                    .font(.title3)
                Spacer()
                TextField("최대 수용 인원", text: $memberCount)
                    .keyboardType(.numberPad)
                    .onChange(of: memberCount) { oldValue, newValue in
                        let filtered = newValue.filter {
                            "0123456789".contains($0)
                        }
                        
                        if filtered != newValue {
                            memberCount = filtered
                        }
                        if let number = Int(filtered) {
                            memberCount = formatNumber(number)
                            viewModel.seminar.capacity = number
                        }
                    }
            }
            Text("세미나 대표 이미지")
                .foregroundStyle(.secondary)
                .font(.body)
                .padding(.vertical)
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(.rect(cornerRadius: 12))
                } else {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 200)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .stroke(.secondary, lineWidth: 1))
                        .tint(.black)
                }
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                viewModel.convertPickerItemToImage(newValue)
            }
        }
    }
    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }

}

#Preview {
    CreateSeminarAddressView(viewModel: .init())
}
