import UIKit

final class ImagePreheater {
    static let shared = ImagePreheater()

    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "com.lakeshow.image-preheater", qos: .userInitiated)

    private init() {}

    /// Preloads and decompresses images by asset names on a background queue.
    /// Subsequent uses of these images will avoid first-draw decoding cost.
    func preheat(names: [String]) {
        let unique = Array(Set(names)).filter { !$0.isEmpty }
        guard !unique.isEmpty else { return }

        queue.async { [weak self] in
            guard let self else { return }
            for name in unique {
                if self.cache.object(forKey: name as NSString) != nil { continue }
                if let image = UIImage(named: name) {
                    let decompressed = self.decompressed(image: image)
                    self.cache.setObject(decompressed, forKey: name as NSString)
                }
            }
        }
    }

    /// Returns a preheated (decompressed) UIImage if available, otherwise loads,
    /// decompresses, caches, and returns it.
    func image(for name: String) -> UIImage? {
        if let cached = cache.object(forKey: name as NSString) {
            return cached
        }
        guard let image = UIImage(named: name) else { return nil }
        let decompressed = decompressed(image: image)
        cache.setObject(decompressed, forKey: name as NSString)
        return decompressed
    }

    private func decompressed(image: UIImage) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        format.opaque = false // preserve transparency in assets
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
    }
}
