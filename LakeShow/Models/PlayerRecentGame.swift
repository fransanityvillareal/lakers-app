import SwiftUI

struct PlayerRecentGame: Identifiable, Hashable {
    enum Result: Hashable {
        case win
        case loss

        var label: String {
            switch self {
            case .win: return "W"
            case .loss: return "L"
            }
        }

        var color: Color {
            switch self {
            case .win: return .green
            case .loss: return .red
            }
        }
    }

    enum MatchupLocation: String, Hashable {
        case home = "vs"
        case away = "@"
    }

    let id = UUID()
    let fps: String
    let points: Int
    let rebounds: Int
    let assists: Int
    let opponentCode: String
    let matchupLocation: MatchupLocation
    let teamScore: Int
    let opponentScore: Int
    let viewers: String
    let reactions: [PlayerRecentGameReaction]
    let dateLabel: String
    let result: Result

    var matchupLabel: String {
        "\(matchupLocation.rawValue) \(opponentCode)"
    }

    var compactMatchupLabel: String {
        "\(matchupLocation.rawValue)\(opponentCode)"
    }

    var scoreLine: String {
        "LAL \(teamScore) - \(opponentCode) \(opponentScore)"
    }
}

struct PlayerRecentGameReaction: Identifiable, Hashable {
    let id = UUID()
    let systemImage: String
    let count: String
}
