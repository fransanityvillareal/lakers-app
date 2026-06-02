import SwiftUI
import UIKit

struct ScheduleView: View {
    private let viewModel = ScheduleViewModel()
    private let calendar = ScheduleViewModel.scheduleCalendar

    @State private var visibleMonth: Date
    @State private var selectedDate: Date?

    init() {
        let viewModel = ScheduleViewModel()
        let month = viewModel.defaultVisibleMonth()
        _visibleMonth = State(initialValue: month)
        _selectedDate = State(initialValue: nil)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.06, green: 0.07, blue: 0.08)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    CompactScheduleCalendarView(
                        visibleMonth: $visibleMonth,
                        selectedDate: $selectedDate,
                        allGames: allGames,
                        calendar: calendar
                    )
                    
                    Text("Tap a game date to view details")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 8)
                .padding(.top, 4)
                .padding(.bottom, 16)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            if let selectedDate, let selectedGame {
                ScheduleGameSnackbarView(
                    date: selectedDate,
                    game: selectedGame,
                    calendar: calendar
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 6)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onChange(of: visibleMonth) { _, newMonth in
            selectedDate = nil
        }
        .animation(.spring(response: 0.28, dampingFraction: 0.9), value: selectedGame?.id)
    }

    private var allGames: [TeamGame] {
        viewModel.allGames()
    }

    private var selectedGame: TeamGame? {
        guard let selectedDate else { return nil }
        return viewModel.games(on: selectedDate).first
    }
}

private struct CompactScheduleCalendarView: View {
    @Binding var visibleMonth: Date
    @Binding var selectedDate: Date?
    let allGames: [TeamGame]
    let calendar: Calendar

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 12)
                .padding(.top, 12)
                .padding(.bottom, 6)

            weekdayHeader
                .padding(.horizontal, 8)
                .padding(.bottom, 1)

            VStack(spacing: 0) {
                ForEach(Array(weeks.enumerated()), id: \.offset) { index, week in
                    weekRow(week)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 5)

                    if index < weeks.count - 1 {
                        Rectangle()
                            .fill(Color.white.opacity(0.18))
                            .frame(height: 1)
                            .padding(.horizontal, 8)
                    }
                }
            }

            Capsule()
                .fill(Color.white.opacity(0.18))
                .frame(width: 72, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.white.opacity(0.16), lineWidth: 1)
                )
        )
    }

    private var header: some View {
        HStack(alignment: .center) {
            HStack(spacing: 10) {
                monthButton(systemImage: "chevron.left", delta: -1)

                Text(monthTitle)
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                monthButton(systemImage: "chevron.right", delta: 1)
            }

            Spacer(minLength: 10)

            HStack(spacing: 12) {
                legendItem(color: homeRingColor, title: "HOME")
                legendItem(color: awayRingColor, title: "AWAY")
            }
        }
    }

    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func weekRow(_ week: [Date]) -> some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(week, id: \.self) { date in
                Button {
                    selectedDate = game(on: date) == nil ? nil : date
                } label: {
                    ScheduleBoardDayCell(
                        date: date,
                        game: game(on: date),
                        isCurrentMonth: calendar.isDate(date, equalTo: visibleMonth, toGranularity: .month),
                        isSelected: selectedDate.map { calendar.isDate(date, inSameDayAs: $0) } ?? false,
                        homeRingColor: homeRingColor,
                        awayRingColor: awayRingColor
                    )
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func legendItem(color: Color, title: String) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)

            Text(title)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
        }
    }

    private func monthButton(systemImage: String, delta: Int) -> some View {
        Button {
            guard let nextMonth = calendar.date(byAdding: .month, value: delta, to: visibleMonth) else { return }
            withAnimation(.easeInOut(duration: 0.18)) {
                visibleMonth = nextMonth
            }
        } label: {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }

    private func game(on date: Date) -> TeamGame? {
        allGames.first { calendar.isDate($0.date, inSameDayAs: date) }
    }

    private var weeks: [[Date]] {
        stride(from: 0, to: displayedDates.count, by: 7).map { start in
            Array(displayedDates[start..<min(start + 7, displayedDates.count)])
        }
    }

    private var displayedDates: [Date] {
        let monthStart = startOfMonth(visibleMonth)
        let leadingDays = (calendar.component(.weekday, from: monthStart) - calendar.firstWeekday + 7) % 7
        let firstDisplayed = calendar.date(byAdding: .day, value: -leadingDays, to: monthStart) ?? monthStart
        return (0..<42).compactMap { calendar.date(byAdding: .day, value: $0, to: firstDisplayed) }
    }

    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let symbols = formatter.shortWeekdaySymbols ?? calendar.shortWeekdaySymbols
        return Array(symbols.prefix(7)).map { String($0.prefix(1)).uppercased() }
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: visibleMonth)
    }

    private func startOfMonth(_ date: Date) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? date
    }

    private var homeRingColor: Color {
        Color(red: 0.53, green: 0.14, blue: 1.0)
    }

    private var awayRingColor: Color {
        Color.white.opacity(0.76)
    }
}

private struct ScheduleBoardDayCell: View {
    let date: Date
    let game: TeamGame?
    let isCurrentMonth: Bool
    let isSelected: Bool
    let homeRingColor: Color
    let awayRingColor: Color

    private let calendar = ScheduleViewModel.scheduleCalendar

    var body: some View {
        VStack(spacing: 6) {
            if let game {
                ZStack {
                    Circle()
                        .stroke(ringColor.opacity(isCurrentMonth ? 1 : 0.55), lineWidth: isSelected ? 3.5 : 2.5)
                        .frame(width: 38, height: 38)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(isSelected ? 0.06 : 0))
                        )

                    Text(dayText)
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                        .foregroundStyle(dayColor)
                }

                Text(game.calendarLabel)
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundStyle(labelColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            } else {
                Text(dayText)
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundStyle(dayColor)
                    .frame(height: 38, alignment: .center)

                Text(" ")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .frame(height: 18)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 58, alignment: .top)
        .contentShape(Rectangle())
    }

    private var dayText: String {
        String(calendar.component(.day, from: date))
    }

    private var ringColor: Color {
        guard let game else { return .clear }
        return game.isHome ? homeRingColor : awayRingColor
    }

    private var dayColor: Color {
        isCurrentMonth ? .white : Color.white.opacity(0.45)
    }

    private var labelColor: Color {
        isCurrentMonth ? .white : Color.white.opacity(0.45)
    }
}

private struct ScheduleGameSnackbarView: View {
    let date: Date
    let game: TeamGame
    let calendar: Calendar

    var body: some View {
        VStack(spacing: 12) {
            Text("\(game.venueLabel)  |  \(selectedDateText)")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .tracking(0.8)
                .foregroundStyle(Color.white.opacity(0.92))

            if !game.isFinal {
                Text(game.matchupTitle.uppercased())
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundStyle(LakeShowTheme.gold.opacity(0.9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            if game.isFinal {
                Text(resultBadgeText(for: game))
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 124, height: 42)
                    .background(resultColor(for: game), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            if game.isFinal {
                finalScoreLayout(for: game)
            } else {
                upcomingLayout(for: game)
            }

            detailFooter(for: game)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(red: 0.13, green: 0.14, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.28), radius: 18, x: 0, y: 10)
    }

    private func finalScoreLayout(for game: TeamGame) -> some View {
        HStack(alignment: .center, spacing: 12) {
            TeamLogoColumnView(brand: .lakers, logoSize: 84, codeFontSize: 20, nameFontSize: 11)
                .frame(maxWidth: .infinity)

            HStack(alignment: .lastTextBaseline, spacing: 8) {
                scoreValue(game.lakersScore)
                
                Text(game.matchupConnector)
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.9))
                    .frame(width: 34)
                
                scoreValue(game.opponentScore)
            }
            .frame(minWidth: 170)

            TeamLogoColumnView(brand: opponentBrand, logoSize: 84, codeFontSize: 20, nameFontSize: 11)
                .frame(maxWidth: .infinity)
        }
    }

    private func upcomingLayout(for game: TeamGame) -> some View {
        HStack(alignment: .center, spacing: 12) {
            TeamLogoColumnView(brand: .lakers, logoSize: 84, codeFontSize: 20, nameFontSize: 11)
                .frame(maxWidth: .infinity)

            VStack(spacing: 8) {
                Text(game.tipoffText ?? "TBD")
                    .font(.system(size: 27, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                Text(game.matchupConnector)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.8))
            }
            .frame(minWidth: 120)

            TeamLogoColumnView(brand: opponentBrand, logoSize: 84, codeFontSize: 20, nameFontSize: 11)
                .frame(maxWidth: .infinity)
        }
    }

    private func scoreValue(_ score: Int?) -> some View {
        Text("\(score ?? 0)")
            .font(.system(size: 32, weight: .heavy, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 62)
    }

    private func detailFooter(for game: TeamGame) -> some View {
        VStack(spacing: 6) {
            if let footerLogoAssetName, let logo = UIImage(named: footerLogoAssetName) {
                Image(uiImage: logo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
            } else {
                Text(game.arena.uppercased())
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.66))
            }

            if let broadcast = game.broadcast {
                Text(broadcast.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.42))
            }
        }
    }

    private func resultColor(for game: TeamGame) -> Color {
        (game.isWin == true ? Color.green : Color.red).opacity(0.95)
    }

    private func resultBadgeText(for game: TeamGame) -> String {
        game.isWin == true ? "WIN" : "LOSE"
    }

    private var selectedDateText: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE MMM dd"
        return formatter.string(from: date).uppercased()
    }

    private var opponentBrand: ScheduleTeamBrand {
        .brand(for: game.opponent, fallbackName: game.opponentName)
    }

    private var footerLogoAssetName: String? {
        if game.isHome && game.arena == "Crypto.com Arena" {
            return "crypto_arena_logo"
        }

        return nil
    }
}

private struct TeamLogoColumnView: View {
    let brand: ScheduleTeamBrand
    var logoSize: CGFloat = 72
    var codeFontSize: CGFloat = 18
    var nameFontSize: CGFloat = 10

    var body: some View {
        VStack(spacing: 8) {
            if let assetName = brand.assetName, let logo = UIImage(named: assetName) {
                Image(uiImage: logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoSize, height: logoSize)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
            } else {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: logoSize, height: logoSize)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                    .overlay {
                        Text(brand.code)
                            .font(.system(size: codeFontSize + 4, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                    }
            }

            Text(brand.code)
                .font(.system(size: codeFontSize, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)

            Text(brand.name.uppercased())
                .font(.system(size: nameFontSize, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.55))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

private struct ScheduleTeamBrand {
    let code: String
    let name: String
    let assetName: String?

    static let lakers = ScheduleTeamBrand(
        code: "LAL",
        name: "Lakers",
        assetName: "los_angeles_lakers"
    )

    static func brand(for code: String, fallbackName: String) -> ScheduleTeamBrand {
        switch code {
        case "ATL":
            return .init(code: "ATL", name: "Hawks", assetName: "atlanta_hawks")
        case "BKN":
            return .init(code: "BKN", name: "Nets", assetName: "brooklyn_nets")
        case "CHI":
            return .init(code: "CHI", name: "Bulls", assetName: "chicago_bulls")
        case "CHA":
            return .init(code: "CHA", name: "Hornets", assetName: nil)
        case "DAL":
            return .init(code: "DAL", name: "Mavericks", assetName: "dallas_mavericks")
        case "DEN":
            return .init(code: "DEN", name: "Nuggets", assetName: "denver_nuggets")
        case "GSW":
            return .init(code: "GSW", name: "Warriors", assetName: "golden_state_warriors")
        case "HOU":
            return .init(code: "HOU", name: "Rockets", assetName: "houston_rockets")
        case "IND":
            return .init(code: "IND", name: "Pacers", assetName: "indiana_pacers")
        case "LAC":
            return .init(code: "LAC", name: "Clippers", assetName: "los_angeles_clippers")
        case "MEM":
            return .init(code: "MEM", name: "Grizzlies", assetName: "memphis_grizzlies")
        case "NOP":
            return .init(code: "NOP", name: "Pelicans", assetName: "new_orleans_pelicans")
        case "OKC":
            return .init(code: "OKC", name: "Thunder", assetName: "oklahoma_city_thunder")
        case "ORL":
            return .init(code: "ORL", name: "Magic", assetName: "orlando_magic")
        case "PHI":
            return .init(code: "PHI", name: "76ers", assetName: "philadelphia_76ers")
        case "PHX":
            return .init(code: "PHX", name: "Suns", assetName: "phoenix_suns")
        case "SAC":
            return .init(code: "SAC", name: "Kings", assetName: "sacramento_kings")
        case "SAS":
            return .init(code: "SAS", name: "Spurs", assetName: "san_antonio_spurs")
        case "TOR":
            return .init(code: "TOR", name: "Raptors", assetName: "toronto_raptors")
        case "UTA":
            return .init(code: "UTA", name: "Jazz", assetName: "utah_jazz")
        default:
            return .init(code: code, name: fallbackName, assetName: nil)
        }
    }
}

#Preview {
    NavigationStack {
        ScheduleView()
    }
}
