import SwiftUI

struct PlayerDetailView: View {
    let player: Player
    @State private var selectedTab: PlayerDetailViewTab = .overview
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            LakeShowBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    playerHeader

                    VStack(alignment: .leading, spacing: 24) {
                        PlayerDetailTabBarView(selection: $selectedTab)
                        PlayerDetailTabContentView(player: player, selectedTab: selectedTab)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 32)
            }
            .ignoresSafeArea(.container, edges: [.top, .horizontal])
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
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        switch selectedTab {
        case .overview:
            VStack(alignment: .leading, spacing: 24) {
                PlayerDetailInfoGridView(player: player)
                PlayerDetailBiographyView()
            }
        case .stats:
            LazyVGrid(columns: columns, spacing: 12) {
                StatCardView(title: "PPG", value: String(format: "%.1f", player.pointsPerGame), detail: "Points", systemImage: "basketball.fill")
                StatCardView(title: "RPG", value: String(format: "%.1f", player.reboundsPerGame), detail: "Boards", systemImage: "arrow.down.circle.fill")
                StatCardView(title: "APG", value: String(format: "%.1f", player.assistsPerGame), detail: "Playmaking", systemImage: "hand.point.up.left.fill")
                StatCardView(title: "Rating", value: "\(player.overallRating)", detail: "Overall", systemImage: "star.fill")
            }
            .padding(.horizontal, 4)
        case .games:
            DetailSection(title: "Recent Games", rows: [
                ("Lakers vs Warriors", "Upcoming"),
                ("Lakers vs Nuggets", "112-108"),
                ("Lakers at Suns", "Live")
            ])
            .padding(.horizontal, 4)
        }
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
        .padding(.horizontal, 20)
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
