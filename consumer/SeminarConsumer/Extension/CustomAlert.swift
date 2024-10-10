//
//  CustomAlert.swift
//  SeminarConsumer
//
//  Created by Hyojeong on 10/9/24.
//

import SwiftUI

extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        transition: AnyTransition,
        title: String,
        message: String,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void
    ) -> some View {
        return modifier(
            CustomAlertViewModifier(
                isPresented: isPresented,
                transition: transition,
                title: title,
                message: message,
                primaryButtonTitle: primaryButtonTitle,
                primaryAction: primaryAction
            )
        )
    }
}

private struct CustomAlertViewModifier: ViewModifier {

    @Binding var isPresented: Bool
    let transition: AnyTransition
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void

    // 이거 반드시 구현해야 함 (프로토콜의 요구사항)
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isPresented ? 2 : 0)

            ZStack {
                if isPresented {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    CustomAlert(
                        isPresented: self.$isPresented,
                        title: self.title,
                        message: self.message,
                        primaryButtonTitle: self.primaryButtonTitle,
                        primaryAction: self.primaryAction
                    )
                    .transition(self.transition)
                }
            }
            // 암시적 애니메이션
            .animation(.snappy, value: isPresented)
        }
    }
}

private struct CustomAlert: View {

    /// Alert 를 트리거 하기 위한 바인딩 필요
    @Binding var isPresented: Bool
    
    /// Alert 의 제목
    let title: String

    /// Alert 의 설명
    let message: String
    
    /// 주요 버튼에 들어갈 텍스트
    let primaryButtonTitle: String
    
    /// 주요 버튼이 눌렸을 때의 액션 (클로저가 필요함!)
    let primaryAction: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            Image(systemName: "trash")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
                .padding(8)
                .background(
                    Circle()
                        .fill(.button)
                        .frame(width: 60, height: 60)
                )

            Text(title)
                .font(.title2)
                .bold()

            Text(message)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
            
            VStack {
                Button {
                    isPresented = false // Alert dismiss
                } label: {
                    Text("취소")
                        .font(.headline)
                        .foregroundStyle(.button)
                        .bold()
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                .tint(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.button, lineWidth: 1)
                }
                
                Button {
                    isPresented = false // Alert dismiss
                    primaryAction() // 클로저 실행
                } label: {
                    Text(primaryButtonTitle)
                        .font(.headline)
                        .bold()
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                .tint(.button)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .frame(width: 270)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
//                .strokeBorder(.accent, lineWidth: 1)
        )
    }
}

#Preview {
    CustomAlert(
        isPresented: .constant(true),
        title: "계정을 탈퇴합니다",
        message: "탈퇴 후 삭제되는 모든 정보는 복구할 수 없습니다.",
        primaryButtonTitle: "탈퇴",
        primaryAction: { }
    )
}
