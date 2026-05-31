import Foundation

enum MockGames {
    static let games: [Game] = [
        Game(opponent: "Warriors", date: "Jun 4", time: "7:30 PM", isHomeGame: true, status: .upcoming, lakersScore: nil, opponentScore: nil),
        Game(opponent: "Celtics", date: "Jun 7", time: "5:00 PM", isHomeGame: false, status: .upcoming, lakersScore: nil, opponentScore: nil),
        Game(opponent: "Nuggets", date: "May 29", time: "Final", isHomeGame: true, status: .final, lakersScore: 112, opponentScore: 108),
        Game(opponent: "Suns", date: "Live", time: "Q3 4:18", isHomeGame: false, status: .live, lakersScore: 84, opponentScore: 81)
    ]
}
