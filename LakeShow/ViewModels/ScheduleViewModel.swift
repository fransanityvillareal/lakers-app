import Foundation

struct ScheduleViewModel {
    private let calendar = Self.scheduleCalendar

    func defaultVisibleMonth() -> Date {
        startOfMonth(mockMonthAnchor)
    }

    func defaultSelectedDate(in month: Date) -> Date {
        let monthStart = startOfMonth(month)

        if calendar.isDate(monthStart, equalTo: mockMonthAnchor, toGranularity: .month) {
            return date(year: 2026, month: 3, day: 2)
        }

        return games(in: monthStart).first?.date ?? monthStart
    }

    func allGames() -> [TeamGame] {
        MockLakersSchedule.games(calendar: calendar)
    }

    func games(in month: Date) -> [TeamGame] {
        let monthStart = startOfMonth(month)
        return allGames().filter { calendar.isDate($0.date, equalTo: monthStart, toGranularity: .month) }
    }

    func games(on date: Date) -> [TeamGame] {
        allGames().filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func startOfMonth(_ date: Date) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? date
    }

    private var mockMonthAnchor: Date {
        date(year: 2026, month: 3, day: 1)
    }

    private func date(year: Int, month: Int, day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }

    static var scheduleCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }
}

struct TeamGame: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let opponent: String
    let opponentName: String
    let isHome: Bool
    let arena: String
    let tipoffText: String?
    let lakersScore: Int?
    let opponentScore: Int?
    let broadcast: String?

    var venueLabel: String {
        isHome ? "HOME" : "AWAY"
    }

    var calendarLabel: String {
        isHome ? opponent : "@\(opponent)"
    }

    var matchupConnector: String {
        isHome ? "VS" : "@"
    }

    var matchupTitle: String {
        isHome ? "Lakers vs \(opponentName)" : "Lakers at \(opponentName)"
    }

    var isFinal: Bool {
        lakersScore != nil && opponentScore != nil
    }

    var resultMarker: String? {
        guard let isWin else { return nil }
        return isWin ? "W" : "L"
    }

    var isWin: Bool? {
        guard let lakersScore, let opponentScore else { return nil }
        return lakersScore > opponentScore
    }

    var statusLine: String {
        if let resultMarker, let lakersScore, let opponentScore {
            return "\(resultMarker) \(lakersScore)-\(opponentScore)"
        }

        return tipoffText ?? "TBD"
    }
}

enum MockLakersSchedule {
    static func games(calendar: Calendar = ScheduleViewModel.scheduleCalendar) -> [TeamGame] {
        func game(
            year: Int,
            month: Int,
            day: Int,
            opponent: String,
            opponentName: String,
            isHome: Bool,
            arena: String,
            tipoffText: String? = nil,
            lakersScore: Int? = nil,
            opponentScore: Int? = nil,
            broadcast: String? = nil
        ) -> TeamGame {
            TeamGame(
                date: calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date(),
                opponent: opponent,
                opponentName: opponentName,
                isHome: isHome,
                arena: arena,
                tipoffText: tipoffText,
                lakersScore: lakersScore,
                opponentScore: opponentScore,
                broadcast: broadcast
            )
        }

        return [
            game(year: 2026, month: 3, day: 2, opponent: "SAC", opponentName: "Kings", isHome: false, arena: "Golden 1 Center", lakersScore: 104, opponentScore: 128, broadcast: "NBC Sports CA"),
            game(year: 2026, month: 3, day: 4, opponent: "PHX", opponentName: "Suns", isHome: true, arena: "Crypto.com Arena", tipoffText: "7:30 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 3, day: 6, opponent: "NOP", opponentName: "Pelicans", isHome: true, arena: "Crypto.com Arena", tipoffText: "7:00 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 3, day: 9, opponent: "CHI", opponentName: "Bulls", isHome: true, arena: "Crypto.com Arena", tipoffText: "7:30 PM", broadcast: "ESPN"),
            game(year: 2026, month: 3, day: 11, opponent: "IND", opponentName: "Pacers", isHome: true, arena: "Crypto.com Arena", lakersScore: 114, opponentScore: 109, broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 3, day: 12, opponent: "CHA", opponentName: "Hornets", isHome: true, arena: "Crypto.com Arena", tipoffText: "7:00 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 3, day: 15, opponent: "LAC", opponentName: "Clippers", isHome: false, arena: "Intuit Dome", tipoffText: "7:00 PM", broadcast: "TNT"),
            game(year: 2026, month: 3, day: 16, opponent: "UTA", opponentName: "Jazz", isHome: true, arena: "Crypto.com Arena", tipoffText: "7:30 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 3, day: 18, opponent: "SAS", opponentName: "Spurs", isHome: true, arena: "Crypto.com Arena", tipoffText: "7:30 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 3, day: 20, opponent: "PHI", opponentName: "76ers", isHome: true, arena: "Crypto.com Arena", tipoffText: "8:00 PM", broadcast: "ABC"),
            game(year: 2026, month: 3, day: 23, opponent: "BKN", opponentName: "Nets", isHome: true, arena: "Crypto.com Arena", tipoffText: "7:30 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 3, day: 25, opponent: "CHA", opponentName: "Hornets", isHome: false, arena: "Spectrum Center", tipoffText: "4:00 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 3, day: 27, opponent: "ORL", opponentName: "Magic", isHome: false, arena: "Kia Center", tipoffText: "4:30 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 3, day: 29, opponent: "ATL", opponentName: "Hawks", isHome: false, arena: "State Farm Arena", tipoffText: "3:00 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 3, day: 30, opponent: "BKN", opponentName: "Nets", isHome: false, arena: "Barclays Center", tipoffText: "4:30 PM", broadcast: "NBATV"),
            game(year: 2026, month: 4, day: 2, opponent: "TOR", opponentName: "Raptors", isHome: false, arena: "Scotiabank Arena", tipoffText: "4:00 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 4, day: 4, opponent: "NOP", opponentName: "Pelicans", isHome: true, arena: "Crypto.com Arena", tipoffText: "7:30 PM", broadcast: "Spectrum SportsNet"),
            game(year: 2026, month: 4, day: 6, opponent: "LAC", opponentName: "Clippers", isHome: true, arena: "Crypto.com Arena", tipoffText: "7:30 PM", broadcast: "ESPN"),
            game(year: 2026, month: 4, day: 8, opponent: "GSW", opponentName: "Warriors", isHome: false, arena: "Chase Center", tipoffText: "7:00 PM", broadcast: "TNT"),
            game(year: 2026, month: 4, day: 11, opponent: "GSW", opponentName: "Warriors", isHome: true, arena: "Crypto.com Arena", tipoffText: "12:30 PM", broadcast: "ABC")
        ]
    }
}
