import Foundation

enum GameStatus: String, CaseIterable {
    case upcoming = "Upcoming"
    case final = "Final"
    case live = "Live"
}

struct Game: Identifiable, Hashable {
    let id = UUID()
    let opponent: String
    let date: String
    let time: String
    let isHomeGame: Bool
    let status: GameStatus
    let lakersScore: Int?
    let opponentScore: Int?

    var matchupTitle: String {
        isHomeGame ? "Lakers vs \(opponent)" : "Lakers at \(opponent)"
    }

    var venueLabel: String {
        isHomeGame ? "Home" : "Away"
    }
}
