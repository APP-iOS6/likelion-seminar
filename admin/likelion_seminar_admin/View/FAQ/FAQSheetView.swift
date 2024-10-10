//
//  FAQSheetView.swift
//  likelion_seminar_admin
//
//  Created by 김동경 on 10/8/24.
//

import SwiftUI

struct FAQSheetView: View {
    
    @ObservedObject var store: FAQStore
    
    @Binding var selectedFAQ: FAQ? // @State에서 일반 속성으로 변경
    @State private var question: String = ""
    @State private var answer: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("질문") {
                TextEditor(text: $question)
                    .overlay(alignment: .leading) {
                        if question.isEmpty {
                            Text("질문 입력해 주세요.")
                                .offset(x: 3, y: 2)
                                .foregroundStyle(.secondary)
                        }
                    }
            }
            
            Section("답변") {
                TextEditor(text: $answer)
                    .overlay(alignment: .leading) {
                        if answer.isEmpty {
                            Text("답변을 입력해 주세요.")
                                .offset(x: 3, y: 2)
                                .foregroundStyle(.secondary)
                        }
                    }
            }
            Button {
                saveFAQ()
            } label: {
                Text("완료")
                    .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .disabled(store.loadState == .loading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear {
            if let faq = selectedFAQ {
                print("\(faq)")
                question = faq.question
                answer = faq.answer
            }
        }
        .overlay {
            if store.loadState == .loading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .onChange(of: store.loadState) { oldValue, newValue in
            if newValue == UploadState.complete {
                store.loadFAQ()
                dismiss()
            }
        }
    }
    
    private func saveFAQ() {
        if let faq = selectedFAQ {
            store.updateFAQ(faq, question: question, answer: answer)
        } else {
            // 추가 모드T
            store.uploadFAQ(question, answer: answer)
        }
    }
}

#Preview {
    FAQSheetView(store: .init(), selectedFAQ: .constant(nil))
}
