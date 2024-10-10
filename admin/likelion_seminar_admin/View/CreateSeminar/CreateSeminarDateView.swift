//
//  CreateSeminarDateView.swift
//  likelion_seminar_admin
//
//  Created by 김동경 on 10/7/24.
//

import SwiftUI

struct CreateSeminarDateView: View {
    
    @ObservedObject var viewModel: CreateSeminarViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("세미나 날짜와 모집기한을\n입력해 주세요.")
                .bold()
                .font(.title)
                .padding(.bottom)
            
            
            Text("세미나 시작 및 종료 시간")
                .foregroundStyle(.secondary)
                .font(.body)
                .padding(.vertical)
            
            HStack() {
                Text("시작")
                    .font(.title3)
                    .padding(.leading)
                
                DatePicker("",selection: $viewModel.seminar.startDateForSeminar)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .font(.title3)
                    .tint(.basicbutton)
                
                Spacer()
                
                Text("종료")
                    .padding(.leading)
                    .font(.title3)

                DatePicker("",selection: $viewModel.seminar.endDateForSeminar)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .font(.title3)
                    .tint(.basicbutton)

                
                Spacer()
            }
            .padding(.vertical)
            
            Text("모집기한")
                .foregroundStyle(.secondary)
                .font(.body)
                .padding(.vertical)
            
            HStack() {
                Text("시작")
                    .font(.title3)
                    .padding(.leading)
                
                DatePicker("",selection: $viewModel.seminar.startDateForApply,
                           displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .font(.title3)
                    .tint(.basicbutton)
                
                Spacer()
                
                Text("종료")
                    .padding(.leading)
                    .font(.title3)

                DatePicker("",selection: $viewModel.seminar.endDateForApply,
                           displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .font(.title3)
                    .tint(.basicbutton)

                
                Spacer()
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    CreateSeminarDateView(viewModel: .init())
}
