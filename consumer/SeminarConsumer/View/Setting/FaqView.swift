//
//  FaqView.swift
//  SeminarConsumer
//
//  Created by wonhoKim on 10/8/24.
//

import SwiftUI

struct FaqView: View {
    private var viewModel = FAQViewModel()
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            ForEach(viewModel.faqs) { faq in
                LazyVStack(alignment: .leading) {
                    DisclosureGroup {
                        Text(transMarkdown(faq.answer))
                            .padding(.all,10)
                            .frame(width: 360)
                            .background(Color.gray.opacity(0.1))
                    } label: {
                        Text(faq.question)
                            .padding(.bottom, 10)
                            .font(.title3)
                    }
                    .padding(.vertical, 5)
                    .foregroundColor(Color.black)
                    Spacer()
                }
            }
            .navigationTitle("자주 묻는 질문 (FAQ)")
            .navigationBarTitleDisplayMode(.large)
            .padding()
        }
        .task {
            await viewModel.fetchFAQs()
        }
    }
    func transMarkdown(_ text: String) -> LocalizedStringKey{
        return LocalizedStringKey(text)
    }
}

#Preview {
    FaqView()
}
