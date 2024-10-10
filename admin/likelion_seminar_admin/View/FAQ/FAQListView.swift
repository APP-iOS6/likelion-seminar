//
//  FAQListView.swift
//  likelion_seminar_admin
//
//  Created by 김동경 on 10/8/24.
//

import SwiftUI

struct FAQListView: View {
    
    @StateObject private var store: FAQStore = .init()
    @State private var selectedFAQ: FAQ? = nil
    @State private var isSheetModal: Bool = false
    @State private var isShowDeleteAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(store.faqs, id: \.id) { faq in
                    VStack() {
                        DisclosureGroup {
                            // Markdown 사용하여 답변 표시
                            Text(faq.answer)
                                .padding(.all,10)
                                .padding(.bottom, 20)
                                .background(Color.gray.opacity(0.1))
                        } label: {
                            Text(faq.question)
                                .padding(.bottom, 10)
                            
                            // 편집 버튼
                            Button(action: {
                                selectedFAQ = faq
                                isSheetModal = true
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            // 삭제 버튼
                            Button(action: {
                                selectedFAQ = faq
                                isShowDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .accentColor(.black)
                    }
                    .padding()
                }
                
            }
        }
        .alert("정말로 삭제하시겠습니까?", isPresented: $isShowDeleteAlert) {
            Button("삭제", role: .destructive) {
                if let faq = selectedFAQ, let id = faq.id {
                    store.deleteFAQ(id)
                    store.loadFAQ()
                }
            }
            Button("취소", role: .cancel) { }
        }
        .sheet(isPresented: $isSheetModal) {
            FAQSheetView(store: store, selectedFAQ: $selectedFAQ)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem {
                Button {
                    selectedFAQ = nil
                    isSheetModal.toggle()
                } label: {
                    Image(systemName: "plus")
                        .bold()
                        .tint(.basicbutton)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                        .tint(.basicbutton)
                }
            }
        }
    }
}

#Preview {
    FAQListView()
}
