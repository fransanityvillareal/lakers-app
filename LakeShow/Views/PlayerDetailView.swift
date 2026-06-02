import SwiftUI

struct PlayerDetailView: View {
    let player: Player
    @State private var selectedTab: PlayerDetailViewTab = .overview
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            LakeShowBackgroundView()

            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 30) {
                        playerHeader
                            .frame(width: proxy.size.width)

                        VStack(alignment: .leading, spacing: 24) {
                            PlayerDetailTabBarView(selection: $selectedTab)
                            PlayerDetailTabContentView(player: player, selectedTab: selectedTab)
                        }
                        .frame(width: max(proxy.size.width - 40, 0), alignment: .leading)
                    }
                    .frame(width: proxy.size.width)
                    .padding(.bottom, 32)
                }
                .ignoresSafeArea(.container, edges: .top)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .tint(LakeShowTheme.gold)
    }

    private var playerHeader: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                cover
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        LinearGradient(
                            colors: [.black.opacity(0.05), .black.opacity(0.72)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipped()

                Image(player.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 134, height: 134)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(LakeShowTheme.black.opacity(0.82), lineWidth: 6))
                    .overlay(Circle().stroke(LakeShowTheme.gold.opacity(0.65), lineWidth: 2))
                    .shadow(color: .black.opacity(0.45), radius: 12, x: 0, y: 6)
                    .offset(y: 62)
            }

            VStack(spacing: 8) {
                Text(player.name.uppercased())
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Text("#\(player.jerseyNumber)  •  \(player.height)  •  \(player.weight)  •  \(player.position)")
                    .font(.subheadline)
                    .foregroundStyle(LakeShowTheme.mutedText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 76)
            .padding(.bottom, 6)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var cover: some View {
        if let coverImageName = player.coverImageName {
            Image(coverImageName)
                .resizable()
                .scaledToFill()
        } else {
            LinearGradient(colors: [LakeShowTheme.purple, LakeShowTheme.black], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    private var profileExperience: String {
        player.name == "Luka Doncic" ? "8 years" : "\(max(player.age - 20, 1)) years"
    }

    private var keyStats: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            StatCardView(title: "PPG", value: String(format: "%.1f", player.pointsPerGame), detail: "Points", systemImage: "basketball.fill")
            StatCardView(title: "RPG", value: String(format: "%.1f", player.reboundsPerGame), detail: "Boards", systemImage: "arrow.down.circle.fill")
            StatCardView(title: "APG", value: String(format: "%.1f", player.assistsPerGame), detail: "Playmaking", systemImage: "hand.point.up.left.fill")
            StatCardView(title: "Rating", value: "\(player.overallRating)", detail: "Overall", systemImage: "star.fill")
        }
    }

    private var infoSection: some View {
        DetailSection(title: "Player Info", rows: [
            ("Height", player.height),
            ("Weight", player.weight),
            ("Age", "\(player.age)"),
            ("Position", player.position)
        ])
    }

    private var averagesSection: some View {
        DetailSection(title: "Season Averages", rows: [
            ("Points", String(format: "%.1f", player.pointsPerGame)),
            ("Rebounds", String(format: "%.1f", player.reboundsPerGame)),
            ("Assists", String(format: "%.1f", player.assistsPerGame))
        ])
    }

    private var tradeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: "Trade Value Summary")

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Mock trade value")
                        .font(.subheadline)
                        .foregroundStyle(LakeShowTheme.mutedText)

                    Text("\(player.tradeValue)")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(LakeShowTheme.gold)
                }

                Spacer()

                Image(systemName: "arrow.left.arrow.right.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.white.opacity(0.82))
            }
            .padding(18)
            .background(LakeShowTheme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(LakeShowTheme.border, lineWidth: 1)
            )
        }
    }
}

private enum PlayerDetailViewTab: String, CaseIterable {
    case overview = "Overview"
    case stats = "Stats"
    case games = "Games"
}

private struct PlayerDetailTabBarView: View {
    @Binding var selection: PlayerDetailViewTab

    var body: some View {
        HStack(spacing: 16) {
            ForEach(PlayerDetailViewTab.allCases, id: \.self) { tab in
                Button {
                    selection = tab
                } label: {
                    Text(tab.rawValue)
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundStyle(selection == tab ? LakeShowTheme.gold : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(selection == tab ? LakeShowTheme.purple : Color.white.opacity(0.08), in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct PlayerDetailTabContentView: View {
    let player: Player
    let selectedTab: PlayerDetailViewTab

    var body: some View {
        switch selectedTab {
        case .overview:
            VStack(alignment: .leading, spacing: 24) {
                PlayerDetailInfoGridView(player: player)
                PlayerDetailBiographyView()
            }
        case .stats:
            PlayerDetailStatsDashboardView(player: player, recentGames: recentGames)
            .padding(.horizontal, 4)
        case .games:
            VStack(alignment: .leading, spacing: 18) {
                DisclosureGroup {
                    if recentGames.isEmpty {
                        Text("No recent games yet.")
                            .font(.subheadline)
                            .foregroundStyle(LakeShowTheme.mutedText)
                    } else {
                        ForEach(recentGames) { game in
                            PlayerRecentGameCardView(player: player, game: game)
                        }
                    }
                } label: {
                    Text("Recent Games")
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                }
                .tint(LakeShowTheme.gold)
            }
            .padding(.horizontal, 4)
        }
    }
    private var recentGames: [PlayerRecentGame] {
        MockPlayerRecentGames.recentGames(for: player.name)
    }
}

private struct PlayerDetailStatsDashboardView: View {
    let player: Player
    let recentGames: [PlayerRecentGame]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            seasonSnapshot

            if recentGames.isEmpty {
                PlayerStatsEmptyStateView()
            } else {
                PlayerRecentPointsChartView(recentGames: recentGames)
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 8)
    }

    private var showcaseProfile: PlayerStatsShowcaseProfile {
        .make(for: player, recentGames: recentGames)
    }

    private var seasonSnapshot: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 12) {
                Text("2025-26")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(LakeShowTheme.statLabel)

                Spacer(minLength: 0)

                HStack(spacing: 6) {
                    Text("Compare")
                    Image(systemName: "chevron.right")
                }
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(LakeShowTheme.gold)
            }

            HStack {
                Spacer(minLength: 0)

                HStack(spacing: 8) {
                    Image(systemName: "basketball.fill")
                        .font(.system(size: 14, weight: .bold))
                    Text(showcaseProfile.accoladeTitle)
                        .font(.system(size: 17, weight: .black, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .foregroundStyle(.white.opacity(0.94))
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(LakeShowTheme.deepPurple.opacity(0.82), in: Capsule())
                .overlay(
                    Capsule()
                        .stroke(LakeShowTheme.gold.opacity(0.26), lineWidth: 1)
                )

                Spacer(minLength: 0)
            }

            PlayerSeasonMetricsRowView(metrics: showcaseProfile.primaryMetrics)
            PlayerSeasonMetricsRowView(metrics: showcaseProfile.secondaryMetrics, horizontalInset: 22)
        }
        .padding(.horizontal, 2)
    }


}

private struct PlayerSeasonMetricsRowView: View {
    let metrics: [PlayerSeasonShowcaseMetric]
    var horizontalInset: CGFloat = 0

    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            ForEach(metrics) { metric in
                PlayerSeasonMetricCell(metric: metric)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, horizontalInset)
    }
}

private struct PlayerSeasonMetricCell: View {
    let metric: PlayerSeasonShowcaseMetric

    var body: some View {
        VStack(spacing: 5) {
            Text(metric.title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(LakeShowTheme.statLabel)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(metric.value)
                .font(.system(size: 19, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.55)

            HStack(spacing: 3) {
                if metric.showsTrophy {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(LakeShowTheme.gold)
                }

                Text(metric.rankText)
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundStyle(LakeShowTheme.gold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .multilineTextAlignment(.center)
    }
}

private struct PlayerRecentPointsChartView: View {
    let recentGames: [PlayerRecentGame]
    private let barSpacing: CGFloat = 8
    private let minimumBarWidth: CGFloat = 30
    private let maximumVisibleGames: CGFloat = 11

    var body: some View {
        GeometryReader { proxy in
            let itemWidth = resolvedItemWidth(for: proxy.size.width)

            VStack(alignment: .leading, spacing: 10) {
                Text("Recent performances")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(.white.opacity(0.45))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: barSpacing) {
                        ForEach(chartGames) { game in
                            PlayerRecentPointsBarView(
                                game: game,
                                maxPoints: maxPoints,
                                itemWidth: itemWidth
                            )
                        }
                    }
                    .frame(height: 212, alignment: .bottom)
                    .padding(.bottom, 8)
                }
            }
        }
        .frame(height: 262)
        .padding(.top, 4)
    }

    private func resolvedItemWidth(for availableWidth: CGFloat) -> CGFloat {
        let visibleGames = min(CGFloat(max(chartGames.count, 1)), maximumVisibleGames)
        let totalSpacing = max(visibleGames - 1, 0) * barSpacing
        let proposedWidth = (availableWidth - totalSpacing) / visibleGames
        return max(minimumBarWidth, proposedWidth)
    }

    private var chartGames: [PlayerRecentGame] {
        Array(recentGames.reversed())
    }

    private var maxPoints: Int {
        max(chartGames.map(\.points).max() ?? 1, 1)
    }
}

private struct PlayerRecentPointsBarView: View {
    let game: PlayerRecentGame
    let maxPoints: Int
    let itemWidth: CGFloat

    var body: some View {
        VStack(spacing: 7) {
            Text("\(game.points)")
                .font(.system(size: 13, weight: .black, design: .rounded))
                .fontWeight(.black)
                .foregroundStyle(.white.opacity(0.45))
                .frame(height: 16)

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(LakeShowTheme.gold)
                .frame(width: itemWidth)
                .frame(height: barHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(LakeShowTheme.gold.opacity(0.14), lineWidth: 0.8)
                )
                .shadow(color: LakeShowTheme.purple.opacity(0.2), radius: 4, x: 0, y: 2)

            Text(game.compactMatchupLabel)
                .font(.system(size: 11, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(0.45))
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .frame(height: 14)
        }
        .frame(width: itemWidth)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    private var barHeight: CGFloat {
        let ratio = CGFloat(game.points) / CGFloat(max(maxPoints, 1))
        return max(14, ratio * 132)
    }
}

private struct PlayerStatsEmptyStateView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent scoring")
                .font(.headline)
                .fontWeight(.black)
                .foregroundStyle(LakeShowTheme.gold)

            Text("No recent game data available yet.")
                .font(.subheadline)
                .foregroundStyle(LakeShowTheme.mutedText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}

private struct PlayerSeasonShowcaseMetric: Identifiable {
    let title: String
    let value: String
    let rankText: String
    let showsTrophy: Bool

    var id: String { title }
}

private struct PlayerStatsShowcaseProfile {
    let accoladeTitle: String
    let primaryMetrics: [PlayerSeasonShowcaseMetric]
    let secondaryMetrics: [PlayerSeasonShowcaseMetric]

    static func make(for player: Player, recentGames: [PlayerRecentGame]) -> PlayerStatsShowcaseProfile {
        let wins = recentGames.filter { $0.result == .win }.count
        let losses = recentGames.filter { $0.result == .loss }.count
        let guardBias = player.position.contains("Guard") ? 1.0 : player.position.contains("Forward") ? 0.45 : 0.12
        let centerBias = player.position.contains("Center") ? 1.0 : player.position.contains("Forward") ? 0.38 : 0.0

        let gamesPlayed = seasonGamesPlayed(for: player)
        let steals = rounded(0.55 + player.assistsPerGame * 0.06 + guardBias * 0.28 + Double(player.overallRating - 70) * 0.01)
        let blocks = rounded(0.22 + centerBias * 0.95 + player.reboundsPerGame * 0.04)
        let turnovers = rounded(max(0.8, player.pointsPerGame / 9.3 + player.assistsPerGame / 5.6))
        let minutes = rounded(min(38.6, 26.0 + Double(player.overallRating - 70) * 0.27))
        let fieldGoal = rounded(min(63.5, 43.0 + player.reboundsPerGame * 0.65 + centerBias * 5.4 + Double(player.overallRating - 75) * 0.12))
        let threePoint = rounded(max(28.0, min(42.5, 29.5 + guardBias * 4.5 + min(5.8, player.pointsPerGame / 5.5) + Double(player.overallRating - 75) * 0.05)))
        let threesAttempted = rounded(max(1.0, min(10.5, player.pointsPerGame / 5.2 + guardBias * 2.0 + centerBias * 0.2)))
        let freeThrow = rounded(min(91.0, 67.0 + Double(player.overallRating - 70) * 0.45 + guardBias * 2.5))
        let freeThrowsAttempted = rounded(max(1.2, min(11.5, player.pointsPerGame / 4.0 + guardBias * 0.55)))
        let plusMinus = rounded(Double(wins - losses) * 1.15 + Double(player.overallRating - 80) * 0.18)
        let trueShooting = rounded(min(69.5, 44.0 + (fieldGoal - 44.0) * 0.55 + (threePoint - 33.0) * 0.65 + (freeThrow - 72.0) * 0.22 + min(4.0, player.pointsPerGame / 8.0)))

        return PlayerStatsShowcaseProfile(
            accoladeTitle: accoladeTitle(for: player),
            primaryMetrics: [
                metric(title: "G", value: "\(gamesPlayed)", rawValue: Double(gamesPlayed), range: 35 ... 82),
                metric(title: "PTS", value: formatted(player.pointsPerGame), rawValue: player.pointsPerGame, range: 4 ... 34),
                metric(title: "REB", value: formatted(player.reboundsPerGame), rawValue: player.reboundsPerGame, range: 1 ... 15),
                metric(title: "AST", value: formatted(player.assistsPerGame), rawValue: player.assistsPerGame, range: 0.5 ... 12),
                metric(title: "STL", value: formatted(steals), rawValue: steals, range: 0.2 ... 2.4),
                metric(title: "BLK", value: formatted(blocks), rawValue: blocks, range: 0.1 ... 2.6),
                metric(title: "TO", value: formatted(turnovers), rawValue: turnovers, range: 0.8 ... 5.2, higherIsBetter: false),
                metric(title: "MIN", value: formatted(minutes), rawValue: minutes, range: 12 ... 38.6)
            ],
            secondaryMetrics: [
                metric(title: "FG%", value: formatted(fieldGoal), rawValue: fieldGoal, range: 38 ... 63.5),
                metric(title: "3FG%", value: formatted(threePoint), rawValue: threePoint, range: 28 ... 42.5),
                metric(title: "3PA", value: formatted(threesAttempted), rawValue: threesAttempted, range: 0.5 ... 10.5),
                metric(title: "FT%", value: formatted(freeThrow), rawValue: freeThrow, range: 60 ... 91),
                metric(title: "FTA", value: formatted(freeThrowsAttempted), rawValue: freeThrowsAttempted, range: 0.8 ... 11.5),
                metric(title: "+/-", value: formatted(plusMinus), rawValue: plusMinus, range: -8 ... 12),
                metric(title: "TS%", value: formatted(trueShooting), rawValue: trueShooting, range: 47 ... 69.5)
            ]
        )
    }

    private static func seasonGamesPlayed(for player: Player) -> Int {
        switch player.name {
        case "Luka Doncic":
            return 65
        case "LeBron James":
            return 68
        default:
            return min(81, max(46, 54 + Int(player.pointsPerGame.rounded()) / 2 + Int(player.assistsPerGame.rounded())))
        }
    }

    private static func accoladeTitle(for player: Player) -> String {
        if player.overallRating >= 97 { return "All-NBA 1st Team" }
        if player.overallRating >= 95 { return "All-NBA Caliber" }
        if player.assistsPerGame >= 7 { return "Offensive Engine" }
        if player.pointsPerGame >= 20 { return "Primary Scorer" }
        if player.position.contains("Center") { return "Interior Anchor" }
        return "Rotation Spark"
    }

    private static func metric(
        title: String,
        value: String,
        rawValue: Double,
        range: ClosedRange<Double>,
        higherIsBetter: Bool = true
    ) -> PlayerSeasonShowcaseMetric {
        let rank = ranking(for: rawValue, within: range, higherIsBetter: higherIsBetter)
        return PlayerSeasonShowcaseMetric(
            title: title,
            value: value,
            rankText: ordinal(rank),
            showsTrophy: rank <= 3
        )
    }

    private static func ranking(
        for value: Double,
        within range: ClosedRange<Double>,
        higherIsBetter: Bool
    ) -> Int {
        let clamped = min(max(value, range.lowerBound), range.upperBound)
        let span = max(range.upperBound - range.lowerBound, 0.0001)
        let normalized = (clamped - range.lowerBound) / span
        let standing = higherIsBetter ? normalized : 1 - normalized
        let rank = Int(round(180 - standing * 179))
        return min(max(rank, 1), 180)
    }

    private static func rounded(_ value: Double) -> Double {
        (value * 10).rounded() / 10
    }

    private static func formatted(_ value: Double) -> String {
        String(format: "%.1f", value)
    }

    private static func ordinal(_ value: Int) -> String {
        let tens = (value / 10) % 10
        let ones = value % 10

        if tens == 1 { return "\(value)th" }

        switch ones {
        case 1: return "\(value)st"
        case 2: return "\(value)nd"
        case 3: return "\(value)rd"
        default: return "\(value)th"
        }
    }
}

private struct PlayerRecentGameCardView: View {
    let player: Player
    let game: PlayerRecentGame

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                Image(player.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(LakeShowTheme.gold.opacity(0.6), lineWidth: 2))

                VStack(alignment: .leading, spacing: 4) {
                    Text(displayName)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(game.fps)
                        .font(.caption)
                        .foregroundStyle(LakeShowTheme.mutedText)
                }

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .font(.caption)
                    Text(game.viewers)
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                .foregroundStyle(.white.opacity(0.78))
            }

            HStack(spacing: 22) {
                statValue("pts", value: game.points)
                statValue("reb", value: game.rebounds)
                statValue("ast", value: game.assists)
            }

            HStack(spacing: 12) {
                ForEach(game.reactions) { reaction in
                    HStack(spacing: 6) {
                        Image(systemName: reaction.systemImage)
                            .font(.caption)
                        if !reaction.count.isEmpty {
                            Text(reaction.count)
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundStyle(.white.opacity(0.78))
                }
            }

            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.dateLabel)
                        .font(.caption)
                        .foregroundStyle(LakeShowTheme.mutedText)

                    Text(game.scoreLine)
                        .font(.caption2)
                        .foregroundStyle(LakeShowTheme.mutedText.opacity(0.82))
                }

                Spacer(minLength: 0)

                Text(game.result.label)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(game.result.color)
            }
        }
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(height: 1)
        }
    }

    private func statValue(_ label: String, value: Int) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 6) {
            Text("\(value)")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)

            Text(label)
                .font(.caption)
                .foregroundStyle(LakeShowTheme.mutedText)
        }
    }

    private var displayName: String {
        let parts = player.name.split(separator: " ")
        guard let first = parts.first, let last = parts.last else { return player.name }
        return "\(first.prefix(1)). \(last)"
    }
}

private struct PlayerDetailBiographyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Biography")
                .font(.headline)
                .fontWeight(.black)
                .foregroundStyle(.white)

            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vitae lacus at justo facilisis finibus. Praesent euismod, nibh at commodo gravida, arcu augue aliquet nisl, vitae posuere mi nibh non arcu.")
                .font(.subheadline)
                .foregroundStyle(LakeShowTheme.mutedText)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}

private struct PlayerDetailInfoGridView: View {
    let player: Player
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 18), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 28) {
            PlayerDetailInfoCell(value: positionAbbreviation, label: "Position")
            PlayerDetailInfoCell(value: "#\(player.jerseyNumber)", label: "Number")
            PlayerDetailInfoCell(value: "\(player.age) years", label: birthDate)
            PlayerDetailInfoCell(value: player.height, label: "Height")
            PlayerDetailInfoCell(value: formattedWeight, label: "Weight")
            PlayerDetailInfoCell(value: experience, label: "Experience")
            PlayerDetailInfoCell(value: royCount, label: "ROY")
            PlayerDetailInfoCell(value: allStarCount, label: "All-Star")
            PlayerDetailInfoCell(value: allNbaCount, label: "All-NBA")
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
    }

    private var formattedWeight: String {
        player.weight.replacingOccurrences(of: " lb", with: " lbs")
    }

    private var positionAbbreviation: String {
        if player.name == "Luka Doncic" { return "PG" }
        if player.position.contains("Center") && player.position.contains("Forward") { return "F/C" }
        if player.position.contains("Guard") && player.position.contains("Forward") { return "G/F" }
        if player.position.contains("Center") { return "C" }
        if player.position.contains("Forward") { return "F" }
        return "G"
    }

    private var birthDate: String {
        switch player.name {
        case "Luka Doncic": return "Feb 28, 1999"
        case "LeBron James": return "Dec 30, 1984"
        case "Austin Reaves": return "May 29, 1998"
        case "Rui Hachimura": return "Feb 8, 1998"
        default: return "Mock profile"
        }
    }

    private var experience: String {
        player.name == "Luka Doncic" ? "8 years" : "\(max(player.age - 20, 1)) years"
    }

    private var royCount: String {
        player.name == "Luka Doncic" ? "1x" : "-"
    }

    private var allStarCount: String {
        switch player.name {
        case "LeBron James": return "21x"
        case "Luka Doncic": return "5x"
        default: return "-"
        }
    }

    private var allNbaCount: String {
        switch player.name {
        case "LeBron James": return "20x"
        case "Luka Doncic": return "5x"
        default: return "-"
        }
    }
}

private struct PlayerDetailInfoCell: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(LakeShowTheme.gold)
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(LakeShowTheme.gold.opacity(0.86))
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct DetailSection: View {
    let title: String
    let rows: [(String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: title)

            VStack(spacing: 0) {
                ForEach(rows, id: \.0) { row in
                    HStack {
                        Text(row.0)
                            .foregroundStyle(LakeShowTheme.mutedText)

                        Spacer()

                        Text(row.1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                    .font(.subheadline)
                    .padding(.vertical, 12)

                    if row.0 != rows.last?.0 {
                        Divider().overlay(Color.white.opacity(0.12))
                    }
                }
            }
            .padding(.horizontal, 16)
            .background(LakeShowTheme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(LakeShowTheme.border, lineWidth: 1)
            )
        }
    }
}

#Preview {
    NavigationStack {
        PlayerDetailView(player: MockPlayers.players[0])
    }
}
