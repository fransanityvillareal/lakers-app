import Foundation

struct Trade: Identifiable, Hashable {
    let id = UUID()
    let lakersPlayers: [String]
    let otherTeamPlayers: [String]
    let otherTeamName: String
}
