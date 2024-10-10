//
//  SeminarImageView.swift
//  likelion_seminar_admin
//
//  Created by Hwang_Inyoung on 10/8/24.
//
import SwiftUI

struct SeminarImageView: View {
    let imageURL: String
    let geometry: GeometryProxy
    let isPortrait: Bool
    
    var body: some View {
        if let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()  // 로딩 중
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (geometry.size.width / (isPortrait ? 2 : 4)) - 16, height: isPortrait ? 200 : 150)
                        .cornerRadius(8)
                        .clipped()
                case .failure:
                    Image("defaultImage")  // 기본 이미지
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (geometry.size.width / (isPortrait ? 2 : 4)) - 16, height: isPortrait ? 200 : 150)
                        .cornerRadius(8)
                        .clipped()
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image("defaultImage")  // 기본 이미지
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: (geometry.size.width / (isPortrait ? 2 : 4)) - 16, height: isPortrait ? 200 : 150)
                .cornerRadius(8)
                .clipped()
        }
    }
}
