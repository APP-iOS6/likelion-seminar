import SwiftUI

extension UIImage {
    static func fetchImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // HTTP 응답 상태 코드 확인
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // 이미지 데이터 변환
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to create image from data"])
        }
        
        return image
    }
}

struct AsyncImageView: View {
    let urlString: String
    @State private var uiImage: UIImage? = nil
    @State private var isLoading: Bool = false
    @State private var error: Error? = nil
    
    var body: some View {
        VStack {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if isLoading {
                ProgressView() // 로딩 중일 때 표시되는 ProgressView
            } else if error != nil {
                Image(systemName: "exclamationmark.triangle") // 에러 발생 시 표시되는 이미지
            } else {
                Image(systemName: "photo") // 초기 상태 또는 기본 플레이스홀더 이미지
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    func loadImage() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let image = try await UIImage.fetchImage(from: urlString)
                uiImage = image
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
}
