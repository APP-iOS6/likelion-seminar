//
//  CustomTextField.swift
//  SeminarConsumer
//
//  Created by Hyojeong on 10/9/24.
//

import SwiftUI

struct CustomTextField: View {
    var sfIcon: String
    var iconTint: Color = .gray
    var hint: String
    
    var isPassword: Bool = false
    @Binding var value: String // 뷰 프로퍼티
    
    @State private var showPassword: Bool = false
    
    var isError: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: sfIcon)
                .foregroundStyle(iconTint)
                .frame(width: 30)
                .offset(y: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                if isPassword {
                    // 비밀번호일 때!
                    if showPassword {
                        HStack {
                            TextField(hint, text: $value)
                        }
                    } else {
                        SecureField(hint, text: $value)
                    }
                } else {
                    // 이메일일 때!
                    TextField(hint, text: $value)
                }
                
                Divider()
                    .background(isError ? .red : .clear)
                
            }
            .overlay(alignment: .trailing) {
                // 눈동자 버튼(SecureField -> TextField 전환)
                if isPassword {
                    Button {
                        withAnimation {
                            showPassword.toggle()
                        }
                    } label: {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .foregroundStyle(.gray)
                            .padding(10)
                    }
                }
            }
        }
    }
}
