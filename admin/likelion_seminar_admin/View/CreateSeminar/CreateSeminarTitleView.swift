//
//  CreateSeminarTitleView.swift
//  likelion_seminar_admin
//
//  Created by 김동경 on 10/7/24.
//

import SwiftUI

struct CreateSeminarTitleView: View {
    
    @ObservedObject var viewModel: CreateSeminarViewModel
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("세미나 이름과 내용을\n입력해 주세요.")
                .bold()
                .font(.title)
                .padding(.bottom)
            
            
            HStack {
                Text("세미나 카테고리")
                    .font(.title3)
                    
                
                Spacer()
                
                Picker("", selection: $viewModel.seminarCategory) {
                    ForEach(SeminarCategory.allCases, id:\.self) { category in
                        Text(category.rawValue).tag(category)
                            .bold()
                            .font(.title3)
                    }
                }
                .tint(.basicbutton)
            }
            
            Text("세미나 이름")
                .foregroundStyle(.secondary)
                .font(.body)
                .padding(.vertical)
            
            TextField("세미나 이름을 입력해 주세요.", text: $viewModel.seminar.name)
                .textFieldStyle(.automatic)
                .overlay(alignment: .bottom) {
                    Divider()
                        .offset(y: 3)
                }
                .font(.title3)
                .padding(.bottom)
            
            Text("세미나 내용")
                .foregroundStyle(.secondary)
                .font(.body)
                .padding(.vertical)
            
            TextEditor(text: $viewModel.seminar.content)
                .frame(maxWidth: .infinity)
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray3), lineWidth: 1)
                    
                )
                .frame(height: 200)
                .overlay(alignment: .topLeading) {
                    if viewModel.seminar.content.isEmpty {
                        Text("세미나 내용을 입력해 주세요.")
                            .foregroundStyle(.secondary)
                            .offset(x: 5, y: 5)
                    }
                }
            
            
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        
    }
}

#Preview {
    CreateSeminarTitleView(viewModel: .init())
}
