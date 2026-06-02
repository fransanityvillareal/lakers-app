import SwiftUI

enum LakeShowTheme {
    static let deepPurple = Color(red: 0.18, green: 0.08, blue: 0.34)
    static let purple = Color(red: 0.33, green: 0.16, blue: 0.66)
    static let gold = Color(red: 0.98, green: 0.73, blue: 0.18)
    static let black = Color(red: 0.04, green: 0.04, blue: 0.06)
    static let statsBlue = Color(red: 0.05, green: 0.59, blue: 0.96)
    static let statLabel = Color.white.opacity(0.56)
    static let card = Color.white.opacity(0.08)
    static let elevatedCard = Color.white.opacity(0.12)
    static let mutedText = Color.white.opacity(0.68)
    static let border = Color.white.opacity(0.12)

    static let accentGradient = LinearGradient(
        colors: [gold, purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let purpleGradient = LinearGradient(
        colors: [deepPurple, black],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
