//
//  CreateSeminarContainerView.swift
//  likelion_seminar_admin
//
//  Created by 김동경 on 10/7/24.
//

import SwiftUI

struct CreateSeminarContainerView: View {
    
    @StateObject private var viewModel: CreateSeminarViewModel = .init()
    @Environment(\.dismiss) private var dismiss
    
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ProgressView(value: viewModel.step.rawValue, total: 1.0)
                    .progressViewStyle(.linear)
                    .padding()
                    .tint(.basicbutton)
                
                switch viewModel.step {
                case .title:
                    CreateSeminarTitleView(viewModel: viewModel)
                        .transition(.opacity)
                case .date:
                    CreateSeminarDateView(viewModel: viewModel)
                        .transition(.opacity)
                case .address:
                    CreateSeminarAddressView(viewModel: viewModel)
                        .transition(.opacity)
                }
            }
            .overlay(alignment: .center) {
                if viewModel.uploadState == .loading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .onChange(of: viewModel.uploadState, { oldValue, newValue in
                if newValue == .complete {
                    action()
                    dismiss()
                }
            })
            .animation(.easeInOut, value: viewModel.step)
            .padding(.horizontal, 24)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        goBack()
                    } label: {
                        Image(systemName: viewModel.step == .title ? "xmark" : "chevron.left")
                            .bold()
                            .foregroundStyle(.basictheme)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        goNext()
                    } label: {
                        if viewModel.step == .address {
                            Text("완료")
                                .bold()
                                .foregroundStyle(.basictheme)
                        } else {
                            Image(systemName: "chevron.forward")
                                .bold()
                                .foregroundStyle(.basictheme)
                        }
                    }
                }
            }
            
        }
    }
    
    private func goBack() {
        switch viewModel.step {
        case .title:
            dismiss()
          return
        case .date:
            viewModel.step = .title
        case .address:
            viewModel.step = .date
        }
    }
    
    private func goNext() {
        switch viewModel.step {
        case .title:
            viewModel.step = .date
        case .date:
            viewModel.step = .address
        case .address:
            Task {
                await viewModel.uploadSeminar()
            }
        }
    }
}

#Preview {
    CreateSeminarContainerView() {}
}
