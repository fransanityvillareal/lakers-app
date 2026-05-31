import Foundation

struct HomeViewModel {
    let nextGame = MockGames.games.first { $0.status == .upcoming }
    let spotlightPlayer = MockPlayers.players.first
    let quickActions: [QuickAction] = [
        QuickAction(title: "Roster", systemImage: "person.3.fill"),
        QuickAction(title: "Schedule", systemImage: "calendar"),
        QuickAction(title: "Stats", systemImage: "chart.bar.fill"),
        QuickAction(title: "Trade Simulator", systemImage: "arrow.left.arrow.right")
    ]
}

struct QuickAction: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let systemImage: String
}
