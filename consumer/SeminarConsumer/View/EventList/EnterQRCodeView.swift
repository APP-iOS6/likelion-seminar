//
//  ContentView.swift
//  QRcode
//
//  Created by 이다영 on 10/7/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins // QR 코드를 생성하는 필터
import Foundation

struct EnterQRCodeView: View {
    @State private var showQRCodeSheet = true
    @State private var sampleData = SampleData()
    
    var body: some View {
        VStack {
            Button(action: {
                showQRCodeSheet.toggle()
            }) {
                Text("입장 코드 받기")
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .cornerRadius(12)
            }
        }
        .fullScreenCover(isPresented: $showQRCodeSheet) {
            // 홈페이지로 이동(임의주소)
            QRCodeSheetView(text: "https://www.instagram.com/dk_dk0422/", isPresented: $showQRCodeSheet, seminar: sampleData.createSampleData()[0], userName: "")
                .background(Color.black.opacity(0.6))
            
        }
    }
}

// QR코드 표시
struct QRCodeSheetView: View {
    let text: String
    @Binding var isPresented: Bool
    var seminar: Seminar
    var userName: String
    
    var body: some View {
        ZStack {
            Image("ticket")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 + 20) //위치조정
                .ignoresSafeArea()
            
            // 안내 문구 및 유저 이름
            VStack(spacing: 10) {
                Text("화면에 QR코드를 제시해 주세요.")
                    .font(.headline)
                    .padding(.top, 60)
                
                // 주어진 문자열로부터 QR코드 생성하는 함수
                if let qrCodeImage = generateQRCode(from: text) {
                    Image(uiImage: qrCodeImage)
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding(.top, 10)
                    
                } else {
                    Text("QR코드가 없습니다.")
                }
                
                // 유저 이름
                Text("\(userName) 님")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(10)
                
                // 세미나 정보 표시
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(seminar.name)")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 77)
                    
                    HStack {
                        Text("일시")
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                            .frame(width: 40, alignment: .leading)
                            .padding(.leading, 56)
                        
                        Text(formatDate(seminar.startDateForSeminar, endDate: seminar.endDateForSeminar))
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, alignment: .bottomLeading)
                    }
                    .padding(.leading, 20)
                    
                    HStack {
                        Text("장소")
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                            .frame(width: 40, alignment: .leading)
                            .padding(.leading, 56)
                        
                        Text("\(seminar.location)")
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, alignment: .bottomLeading)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
                
                Spacer()
                
            }
            .padding()
            
            // 닫기 버튼
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                            .padding(3)
                    }
                    .padding(.top, 15)
                    .padding(.trailing, 46)
                }
                Spacer()
            }
        }
    }
    
    // QR코드 생성 함수
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator() // QR코드 생성위한 CoreImage 필터
        filter.message = Data(string.utf8) // QR코드에 포함할 메시지 설정(현재는 주소)
        
        // QR코드를 CGImage -> UIImage로
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    
    // 날짜 포맷 함수
    func formatDate(_ startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd(E) HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let startString = dateFormatter.string(from: startDate)
        let endString = dateFormatter.string(from: endDate).components(separatedBy: " ").last ?? ""
        
        return "\(startString) ~ \(endString)"
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    EnterQRCodeView()
}

