import SwiftUI
import UIKit

final class RosterImagePreheater {
    static let shared = RosterImagePreheater()

    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "com.lakeshow.roster-image-preheater", qos: .userInitiated)
    private let canvasSize = CGSize(width: 154, height: 176)

    private init() {}

    func preheat(names: [String], scale: CGFloat) {
        let unique = Array(Set(names)).filter { !$0.isEmpty }
        guard !unique.isEmpty else { return }

        queue.async { [weak self] in
            guard let self else { return }

            for name in unique {
                let key = self.cacheKey(for: name, scale: scale)
                if self.cache.object(forKey: key) != nil { continue }
                guard let image = UIImage(named: name) else { continue }
                let thumbnail = self.thumbnail(for: image, scale: scale)
                self.cache.setObject(thumbnail, forKey: key)
            }
        }
    }

    func image(for name: String, scale: CGFloat) -> UIImage? {
        let key = cacheKey(for: name, scale: scale)

        if let cached = cache.object(forKey: key) {
            return cached
        }

        guard let image = UIImage(named: name) else { return nil }
        let thumbnail = thumbnail(for: image, scale: scale)
        cache.setObject(thumbnail, forKey: key)
        return thumbnail
    }

    private func thumbnail(for image: UIImage, scale: CGFloat) -> UIImage {
        let widthScale = canvasSize.width / max(image.size.width, 1)
        let heightScale = canvasSize.height / max(image.size.height, 1)
        let fitScale = min(widthScale, heightScale, 1)
        let scaledSize = CGSize(width: image.size.width * fitScale, height: image.size.height * fitScale)
        let origin = CGPoint(
            x: (canvasSize.width - scaledSize.width) / 2,
            y: canvasSize.height - scaledSize.height
        )

        let format = UIGraphicsImageRendererFormat()
        format.scale = max(scale, 1)
        format.opaque = false

        let renderer = UIGraphicsImageRenderer(size: canvasSize, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: origin, size: scaledSize))
        }
    }

    private func cacheKey(for name: String, scale: CGFloat) -> NSString {
        "\(name)@\(Int((scale * 100).rounded()))" as NSString
    }
}

struct ContentView: View {
    var body: some View {
        RootView()
            .preferredColorScheme(.dark)
    }
}

private struct RootView: View {
    @Environment(\.displayScale) private var displayScale

    private var preheatImageNames: [String] {
        MockData.players.map(\.imageName)
    }

    var body: some View {
        TabView {
            NavigationStack { HomeScreen() }
                .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack { RosterScreen() }
                .tabItem { Label("Roster", systemImage: "person.3.fill") }

            NavigationStack { ScheduleScreen() }
                .tabItem { Label("Schedule", systemImage: "calendar") }

            NavigationStack { StatsScreen() }
                .tabItem { Label("Stats", systemImage: "chart.bar.fill") }

            NavigationStack { MoreScreen() }
                .tabItem { Label("More", systemImage: "ellipsis.circle.fill") }
        }
        .tint(Theme.gold)
        .task {
            RosterImagePreheater.shared.preheat(names: preheatImageNames, scale: displayScale)
        }
    }
}

private enum Theme {
    static let black = Color(red: 0.04, green: 0.04, blue: 0.06)
    static let purple = Color(red: 0.28, green: 0.11, blue: 0.52)
    static let gold = Color(red: 0.98, green: 0.73, blue: 0.18)
    static let card = Color.white.opacity(0.08)
    static let muted = Color.white.opacity(0.68)
    static let border = Color.white.opacity(0.13)

    static let accent = LinearGradient(colors: [gold, purple], startPoint: .topLeading, endPoint: .bottomTrailing)
}

private struct Player: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let coverImageName: String?
    let number: Int
    let position: String
    let height: String
    let weight: String
    let age: Int
    let ppg: Double
    let rpg: Double
    let apg: Double
    let rating: Int
    let tradeValue: Int

    var initials: String {
        name.split(separator: " ").compactMap(\.first).map(String.init).joined()
    }
}

private struct Game: Identifiable {
    let id = UUID()
    let opponent: String
    let date: String
    let time: String
    let homeAway: String
    let status: String
    let score: String?
}

private struct TeamStat: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let detail: String
    let icon: String
}

private enum MockData {
    static let players = [
        Player(name: "LeBron James", imageName: "lebron_james", coverImageName: "lebron_james_cover", number: 23, position: "Forward", height: "6'9\"", weight: "250 lb", age: 41, ppg: 24.4, rpg: 7.8, apg: 8.2, rating: 96, tradeValue: 94),
        Player(name: "Luka Doncic", imageName: "luka_doncic", coverImageName: "luka_doncic_cover", number: 77, position: "Guard", height: "6'7\"", weight: "230 lb", age: 27, ppg: 29.2, rpg: 8.6, apg: 8.9, rating: 97, tradeValue: 98),
        Player(name: "Austin Reaves", imageName: "austin_reaves", coverImageName: nil, number: 15, position: "Guard", height: "6'5\"", weight: "197 lb", age: 28, ppg: 16.8, rpg: 4.3, apg: 5.5, rating: 84, tradeValue: 82),
        Player(name: "Rui Hachimura", imageName: "rui_hachimura", coverImageName: nil, number: 28, position: "Forward", height: "6'8\"", weight: "230 lb", age: 28, ppg: 13.6, rpg: 4.4, apg: 1.3, rating: 80, tradeValue: 74),
        Player(name: "Deandre Ayton", imageName: "deandre_ayton", coverImageName: nil, number: 5, position: "Center", height: "7'0\"", weight: "250 lb", age: 27, ppg: 14.8, rpg: 10.2, apg: 1.6, rating: 82, tradeValue: 78),
        Player(name: "Jarred Vanderbilt", imageName: "jarred_vanderbilt", coverImageName: nil, number: 2, position: "Forward", height: "6'8\"", weight: "214 lb", age: 27, ppg: 6.4, rpg: 7.1, apg: 1.8, rating: 76, tradeValue: 68),
        Player(name: "Jaxson Hayes", imageName: "jaxson_hayes", coverImageName: nil, number: 11, position: "Center", height: "7'0\"", weight: "220 lb", age: 26, ppg: 6.8, rpg: 4.6, apg: 0.9, rating: 74, tradeValue: 62),
        Player(name: "Dalton Knecht", imageName: "dalton_knecht", coverImageName: nil, number: 4, position: "Guard/Forward", height: "6'6\"", weight: "215 lb", age: 25, ppg: 9.2, rpg: 3.1, apg: 1.2, rating: 75, tradeValue: 70),
        Player(name: "Bronny James", imageName: "bronny_james", coverImageName: nil, number: 9, position: "Guard", height: "6'2\"", weight: "210 lb", age: 21, ppg: 4.2, rpg: 1.8, apg: 1.6, rating: 70, tradeValue: 58),
        Player(name: "Maxi Kleber", imageName: "maxi_kleber", coverImageName: nil, number: 14, position: "Forward/Center", height: "6'10\"", weight: "240 lb", age: 34, ppg: 4.7, rpg: 3.8, apg: 1.3, rating: 73, tradeValue: 60),
        Player(name: "Jake LaRavia", imageName: "jake_laravia", coverImageName: nil, number: 12, position: "Forward", height: "6'8\"", weight: "235 lb", age: 24, ppg: 7.4, rpg: 3.9, apg: 1.7, rating: 74, tradeValue: 64),
        Player(name: "Luke Kennard", imageName: "luke_profile", coverImageName: nil, number: 10, position: "Guard", height: "6'5\"", weight: "206 lb", age: 30, ppg: 8.6, rpg: 2.7, apg: 2.4, rating: 76, tradeValue: 66)
    ]

    static let games = [
        Game(opponent: "Warriors", date: "Jun 4", time: "7:30 PM", homeAway: "Home", status: "Upcoming", score: nil),
        Game(opponent: "Celtics", date: "Jun 7", time: "5:00 PM", homeAway: "Away", status: "Upcoming", score: nil),
        Game(opponent: "Nuggets", date: "May 29", time: "Final", homeAway: "Home", status: "Final", score: "LAL 112 - DEN 108"),
        Game(opponent: "Suns", date: "Live", time: "Q3 4:18", homeAway: "Away", status: "Live", score: "LAL 84 - PHX 81")
    ]

    static let stats = [
        TeamStat(title: "Points", value: "117.8", detail: "Per game", icon: "basketball.fill"),
        TeamStat(title: "Rebounds", value: "43.6", detail: "Per game", icon: "arrow.down.circle.fill"),
        TeamStat(title: "Assists", value: "28.4", detail: "Per game", icon: "hand.point.up.left.fill"),
        TeamStat(title: "FG%", value: "49.1%", detail: "Field goal", icon: "scope"),
        TeamStat(title: "3P%", value: "37.2%", detail: "From deep", icon: "target"),
        TeamStat(title: "Off Rating", value: "116.9", detail: "Efficiency", icon: "chart.line.uptrend.xyaxis"),
        TeamStat(title: "Def Rating", value: "113.2", detail: "Stops", icon: "shield.fill")
    ]
}

private struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [Theme.purple.opacity(0.9), Theme.black, Theme.purple.opacity(0.35)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

private struct SectionTitle: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline).foregroundStyle(.white)
            if let subtitle {
                Text(subtitle).font(.subheadline).foregroundStyle(Theme.muted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let detail: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title).font(.caption).fontWeight(.semibold).foregroundStyle(Theme.muted)
                Spacer()
                Image(systemName: icon).font(.caption).foregroundStyle(Theme.gold)
            }

            Text(value).font(.title2).fontWeight(.black).foregroundStyle(.white)
            Text(detail).font(.caption2).foregroundStyle(Theme.muted)
        }
        .frame(maxWidth: .infinity, minHeight: 104, alignment: .topLeading)
        .padding(14)
        .cardStyle()
    }
}

private struct HomeScreen: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("LakeShow").font(.largeTitle).fontWeight(.black).foregroundStyle(.white)
                        Text("Lakers stats, schedule, roster, and fan tools").font(.subheadline).foregroundStyle(Theme.muted)
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass").foregroundStyle(Theme.gold)
                        Text("Ask about Lakers stats...").font(.headline).foregroundStyle(.white.opacity(0.86))
                        Spacer()
                    }
                    .padding(18)
                    .cardStyle(cornerRadius: 22)

                    VStack(alignment: .leading, spacing: 14) {
                        SectionTitle(title: "Featured", subtitle: "Mock team snapshot")
                        GameCard(game: MockData.games[0])
                        PlayerSpotlight(player: MockData.players[0])
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        SectionTitle(title: "Quick Actions")
                        LazyVGrid(columns: columns, spacing: 14) {
                            NavigationLink { RosterScreen() } label: { QuickCard(title: "Roster", icon: "person.3.fill") }
                            NavigationLink { ScheduleScreen() } label: { QuickCard(title: "Schedule", icon: "calendar") }
                            NavigationLink { StatsScreen() } label: { QuickCard(title: "Stats", icon: "chart.bar.fill") }
                            NavigationLink { TradeSimulatorScreen() } label: { QuickCard(title: "Trade Simulator", icon: "arrow.left.arrow.right") }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 0)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .ignoresSafeArea(.container, edges: .horizontal)
        }
    }
}

private struct PlayerSpotlight: View {
    let player: Player

    var body: some View {
        HStack(spacing: 14) {
            PlayerImage(imageName: player.imageName, size: 58)
            VStack(alignment: .leading, spacing: 4) {
                Text("Player Spotlight").font(.caption).fontWeight(.bold).foregroundStyle(Theme.gold)
                Text(player.name).font(.title3).fontWeight(.bold).foregroundStyle(.white)
                Text("#\(player.number) - \(player.position) - \(player.ppg, specifier: "%.1f") PPG").font(.subheadline).foregroundStyle(Theme.muted)
            }
            Spacer()
        }
        .padding(16)
        .cardStyle(cornerRadius: 22)
    }
}

private struct QuickCard: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Theme.gold)
                .frame(width: 34, height: 34)
                .background(Color.white.opacity(0.08), in: Circle())
            Text(title).font(.subheadline).fontWeight(.semibold).foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 112, alignment: .leading)
        .padding(14)
        .cardStyle()
    }
}

private struct RosterScreen: View {
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {
                    SectionTitle(title: "Roster", subtitle: "Mock Lakers rotation and trade values")
                    ForEach(MockData.players) { player in
                        NavigationLink { PlayerDetailScreen(player: player) } label: { PlayerCard(player: player) }
                            .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Roster")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct PlayerCard: View {
    @Environment(\.displayScale) private var displayScale
    let player: Player

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text("\(player.number)")
                .font(.system(size: 82, weight: .black, design: .serif))
                .foregroundStyle(Color.black.opacity(0.045))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(width: 92, alignment: .trailing)
                .padding(.trailing, 22)
                .padding(.bottom, -18)

            HStack(spacing: 12) {
                Group {
                    if let uiImage = RosterImagePreheater.shared.image(for: player.imageName, scale: displayScale) {
                        Image(uiImage: uiImage)
                            .resizable()
                    } else {
                        Image(player.imageName)
                            .resizable()
                    }
                }
                    .scaledToFit()
                    .frame(width: 154, height: 176, alignment: .bottom)
                    .opacity(0.9)
                    .clipped()

                VStack(alignment: .leading, spacing: 8) {
                    Text(player.name.uppercased())
                        .font(.system(size: 30, weight: .black, design: .serif))
                        .foregroundStyle(Theme.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.42)

                    RosterDetailText("\(player.height)   \(formattedWeight)   \(player.position)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 36)
                .offset(y: -10)

                Spacer(minLength: 0)
            }
            .padding(.trailing, 0)
        }
        .frame(maxWidth: .infinity, minHeight: 164, alignment: .leading)
        .background(.white.opacity(0.96), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.gold.opacity(0.48), lineWidth: 1.2)
        }
        .overlay(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.75), lineWidth: 1)
                .padding(1)
        }
        .shadow(color: .white.opacity(0.12), radius: 18, x: 0, y: 2)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var formattedWeight: String {
        player.weight.replacingOccurrences(of: " lb", with: "lbs")
    }
}

private struct RosterDetailText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .regular))
            .foregroundStyle(Color.black.opacity(0.7))
            .lineLimit(1)
            .minimumScaleFactor(0.45)
            .allowsTightening(true)
    }
}

private struct PlayerDetailScreen: View {
    let player: Player
    @State private var selectedTab: PlayerDetailTab = .overview
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            BackgroundView()
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 30) {
                        PlayerHeroHeader(player: player)
                            .frame(width: proxy.size.width)

                        VStack(alignment: .leading, spacing: 24) {
                            PlayerDetailTabBar(selection: $selectedTab)
                            PlayerDetailTabContent(player: player, selectedTab: selectedTab)
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
        .tint(Theme.gold)
    }
}

private struct PlayerHeroHeader: View {
    let player: Player

    var body: some View {
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
                    .overlay(Circle().stroke(Theme.black.opacity(0.82), lineWidth: 6))
                    .overlay(Circle().stroke(Theme.gold.opacity(0.65), lineWidth: 2))
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

                Text("#\(player.number)  •  \(player.height)  •  \(player.weight)  •  \(player.position)")
                    .font(.subheadline)
                    .foregroundStyle(Theme.muted)
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
            LinearGradient(colors: [Theme.purple, Theme.black], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

private enum PlayerDetailTab: String, CaseIterable {
    case overview = "Overview"
    case stats = "Stats"
    case games = "Games"
}

private struct PlayerDetailTabBar: View {
    @Binding var selection: PlayerDetailTab

    var body: some View {
        HStack(spacing: 16) {
            ForEach(PlayerDetailTab.allCases, id: \.self) { tab in
                Button {
                    selection = tab
                } label: {
                    Text(tab.rawValue)
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundStyle(selection == tab ? Theme.gold : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(selection == tab ? Theme.purple : Color.white.opacity(0.08), in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct PlayerDetailTabContent: View {
    let player: Player
    let selectedTab: PlayerDetailTab
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        switch selectedTab {
        case .overview:
            VStack(alignment: .leading, spacing: 24) {
                PlayerProfileInfoGrid(player: player)
                PlayerBiographySection()
            }
        case .stats:
            LazyVGrid(columns: columns, spacing: 12) {
                StatCard(title: "PPG", value: String(format: "%.1f", player.ppg), detail: "Points", icon: "basketball.fill")
                StatCard(title: "RPG", value: String(format: "%.1f", player.rpg), detail: "Boards", icon: "arrow.down.circle.fill")
                StatCard(title: "APG", value: String(format: "%.1f", player.apg), detail: "Playmaking", icon: "hand.point.up.left.fill")
                StatCard(title: "Rating", value: "\(player.rating)", detail: "Overall", icon: "star.fill")
            }
            .padding(.horizontal, 4)
        case .games:
            DetailRows(title: "Recent Games", rows: [
                ("Lakers vs Warriors", "Upcoming"),
                ("Lakers vs Nuggets", "112-108"),
                ("Lakers at Suns", "Live")
            ])
            .padding(.horizontal, 4)
        }
    }
}

private struct PlayerBiographySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Biography")
                .font(.headline)
                .fontWeight(.black)
                .foregroundStyle(.white)

            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vitae lacus at justo facilisis finibus. Praesent euismod, nibh at commodo gravida, arcu augue aliquet nisl, vitae posuere mi nibh non arcu.")
                .font(.subheadline)
                .foregroundStyle(Theme.muted)
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

private struct PlayerProfileInfoGrid: View {
    let player: Player
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 18), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 28) {
            ProfileInfoCell(value: positionAbbreviation, label: "Position")
            ProfileInfoCell(value: "#\(player.number)", label: "Number")
            ProfileInfoCell(value: "\(player.age) years", label: birthDate)
            ProfileInfoCell(value: player.height, label: "Height")
            ProfileInfoCell(value: formattedWeight, label: "Weight")
            ProfileInfoCell(value: experience, label: "Experience")
            ProfileInfoCell(value: royCount, label: "ROY")
            ProfileInfoCell(value: allStarCount, label: "All-Star")
            ProfileInfoCell(value: allNbaCount, label: "All-NBA")
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

private struct ProfileInfoCell: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(Theme.gold)
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Theme.gold.opacity(0.86))
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ScheduleScreen: View {
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    SectionTitle(title: "Schedule", subtitle: "Upcoming, live, and recent mock games")
                    ForEach(MockData.games) { GameCard(game: $0) }
                }
                .padding(20)
            }
        }
        .navigationTitle("Schedule")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct GameCard: View {
    let game: Game

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Lakers vs \(game.opponent)").font(.headline).foregroundStyle(.white)
                    Text("\(game.date) - \(game.time) - \(game.homeAway)").font(.subheadline).foregroundStyle(Theme.muted)
                }
                Spacer()
                Text(game.status)
                    .font(.caption).fontWeight(.bold)
                    .foregroundStyle(game.status == "Live" ? .green : Theme.gold)
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(Color.white.opacity(0.08), in: Capsule())
            }
            if let score = game.score {
                Text(score).font(.headline).fontWeight(.bold).foregroundStyle(Theme.gold)
            }
        }
        .padding(16)
        .cardStyle(cornerRadius: 20)
    }
}

private struct StatsScreen: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    SectionTitle(title: "Team Stats", subtitle: "Mock season dashboard")
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(MockData.stats) { stat in
                            StatCard(title: stat.title, value: stat.value, detail: stat.detail, icon: stat.icon)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct MoreScreen: View {
    var body: some View {
        ZStack {
            BackgroundView()
            List {
                NavigationLink("Trade Simulator") { TradeSimulatorScreen() }
                NavigationLink("Saved Trades") { PlaceholderScreen(title: "Saved Trades", icon: "bookmark.fill") }
                NavigationLink("Favorites") { PlaceholderScreen(title: "Favorites", icon: "heart.fill") }
                NavigationLink("Settings") { PlaceholderScreen(title: "Settings", icon: "gearshape.fill") }
                NavigationLink("About") { PlaceholderScreen(title: "About", icon: "info.circle.fill") }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
        }
        .navigationTitle("More")
    }
}

private struct TradeSimulatorScreen: View {
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Trade Simulator").font(.largeTitle).fontWeight(.black).foregroundStyle(.white)
                        Text("Create mock Lakers trades for fun roster-building analysis.").font(.subheadline).foregroundStyle(Theme.muted)
                        Text("Fan simulator - Mock data").font(.caption).fontWeight(.bold).foregroundStyle(Theme.gold)
                    }

                    TradeTeamCard(title: "Lakers Side", subtitle: "Mock outgoing players", players: ["D'Angelo Russell", "Rui Hachimura"])
                    TradeTeamCard(title: "Other Team Side", subtitle: "Mock incoming assets", players: ["Mock Wing", "Future Pick"])

                    VStack(alignment: .leading, spacing: 14) {
                        SectionTitle(title: "Trade Result")
                        DetailLine(title: "Trade Value", value: "Balanced")
                        DetailLine(title: "Salary Match", value: "92% Match")
                        DetailLine(title: "Team Fit", value: "Strong spacing fit")
                        HStack {
                            Text("Result").foregroundStyle(Theme.muted)
                            Spacer()
                            Text("Fair Trade")
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.black)
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(Theme.gold, in: Capsule())
                        }
                    }
                    .padding(18)
                    .cardStyle(cornerRadius: 22)
                }
                .padding(20)
            }
        }
        .navigationTitle("Trade Simulator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TradeTeamCard: View {
    let title: String
    let subtitle: String
    let players: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: title, subtitle: subtitle)
            ForEach(players, id: \.self) { player in
                HStack {
                    Image(systemName: "basketball.fill").foregroundStyle(Theme.gold)
                    Text(player).font(.subheadline).fontWeight(.semibold).foregroundStyle(.white)
                    Spacer()
                }
                .padding(12)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(16)
        .cardStyle(cornerRadius: 20)
    }
}

private struct PlaceholderScreen: View {
    let title: String
    let icon: String

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 16) {
                Image(systemName: icon).font(.largeTitle).foregroundStyle(Theme.gold)
                Text(title).font(.title).fontWeight(.bold).foregroundStyle(.white)
                Text("This MVP placeholder is ready for the next iteration.").font(.subheadline).foregroundStyle(Theme.muted).multilineTextAlignment(.center)
            }
            .padding(24)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct PlayerImage: View {
    let imageName: String
    let size: CGFloat

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
        .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Theme.gold.opacity(0.5), lineWidth: max(1, size / 48))
            )
    }
}

private struct MiniStat: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.subheadline).fontWeight(.bold).foregroundStyle(.white)
            Text(title).font(.caption2).fontWeight(.semibold).foregroundStyle(Theme.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct DetailRows: View {
    let title: String
    let rows: [(String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: title)
            VStack(spacing: 0) {
                ForEach(rows, id: \.0) { row in
                    DetailLine(title: row.0, value: row.1)
                        .padding(.vertical, 10)
                }
            }
            .padding(.horizontal, 16)
            .cardStyle(cornerRadius: 20)
        }
    }
}

private struct DetailLine: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title).foregroundStyle(Theme.muted)
            Spacer()
            Text(value).fontWeight(.semibold).foregroundStyle(.white).multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

private extension View {
    func cardStyle(cornerRadius: CGFloat = 18) -> some View {
        background(Theme.card, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Theme.border, lineWidth: 1)
            )
    }
}

#Preview {
    ContentView()
}
