import SwiftUI
import UIKit

final class RosterImagePreheater {
    static let shared = RosterImagePreheater()

    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "com.lakeshow.roster-image-preheater", qos: .userInitiated)
    private let canvasSize = CGSize(width: 154, height: 176)

    private init() {}

    func preheat(names: [String], scale: CGFloat) {
        let unique = Array(Set(names)).filter { !$0.isEmpty }
        guard !unique.isEmpty else { return }

        queue.async { [weak self] in
            guard let self else { return }

            for name in unique {
                let key = self.cacheKey(for: name, scale: scale)
                if self.cache.object(forKey: key) != nil { continue }
                guard let image = UIImage(named: name) else { continue }
                let thumbnail = self.thumbnail(for: image, scale: scale)
                self.cache.setObject(thumbnail, forKey: key)
            }
        }
    }

    func image(for name: String, scale: CGFloat) -> UIImage? {
        let key = cacheKey(for: name, scale: scale)

        if let cached = cache.object(forKey: key) {
            return cached
        }

        guard let image = UIImage(named: name) else { return nil }
        let thumbnail = thumbnail(for: image, scale: scale)
        cache.setObject(thumbnail, forKey: key)
        return thumbnail
    }

    private func thumbnail(for image: UIImage, scale: CGFloat) -> UIImage {
        let widthScale = canvasSize.width / max(image.size.width, 1)
        let heightScale = canvasSize.height / max(image.size.height, 1)
        let fitScale = min(widthScale, heightScale, 1)
        let scaledSize = CGSize(width: image.size.width * fitScale, height: image.size.height * fitScale)
        let origin = CGPoint(
            x: (canvasSize.width - scaledSize.width) / 2,
            y: canvasSize.height - scaledSize.height
        )

        let format = UIGraphicsImageRendererFormat()
        format.scale = max(scale, 1)
        format.opaque = false

        let renderer = UIGraphicsImageRenderer(size: canvasSize, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: origin, size: scaledSize))
        }
    }

    private func cacheKey(for name: String, scale: CGFloat) -> NSString {
        "\(name)@\(Int((scale * 100).rounded()))" as NSString
    }
}

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
}
