import Foundation

struct Player: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let coverImageName: String?
    let jerseyNumber: Int
    let position: String
    let height: String
    let weight: String
    let age: Int
    let pointsPerGame: Double
    let reboundsPerGame: Double
    let assistsPerGame: Double
    let overallRating: Int
    let tradeValue: Int

    var initials: String {
        name
            .split(separator: " ")
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }
}
