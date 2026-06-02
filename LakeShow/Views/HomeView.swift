import SwiftUI
import UIKit

struct HomeView: View {
    private let viewModel = HomeViewModel()
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    private static let preheatCache = NSCache<NSString, UIImage>()

    private var preheatImageNames: [String] {
        var names: [String] = []
        for p in RosterViewModel().players {
            names.append(p.imageName)
            if let cover = p.coverImageName { names.append(cover) }
        }
        return names
    }

    var body: some View {
        ZStack {
            LakeShowBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    searchCard
                    featuredContent
                    quickActions
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 32)
            }
            .onAppear { preheatImages() }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("LakeShow")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(.white)

            Text("Lakers stats, schedule, roster, and fan tools")
                .font(.subheadline)
                .foregroundStyle(LakeShowTheme.mutedText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var searchCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(LakeShowTheme.gold)

            Text("Ask about Lakers stats...")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.86))

            Spacer()
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.13), Color.white.opacity(0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(LakeShowTheme.border, lineWidth: 1)
        )
    }

    private var featuredContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Featured", subtitle: "Mock team snapshot")

            if let nextGame = viewModel.nextGame {
                GameCardView(game: nextGame)
            }

            if let player = viewModel.spotlightPlayer {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Label("Player Spotlight", systemImage: "star.fill")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Spacer()

                        Text("#\(player.jerseyNumber)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(LakeShowTheme.gold)
                    }

                    HStack(alignment: .center, spacing: 14) {
                        Image(player.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 58, height: 58)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(LakeShowTheme.gold.opacity(0.55), lineWidth: 1)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(player.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)

                            Text("\(player.position) • \(String(format: "%.1f", player.pointsPerGame)) PPG")
                                .font(.subheadline)
                                .foregroundStyle(LakeShowTheme.mutedText)
                        }
                    }
                }
                .padding(16)
                .background(LakeShowTheme.elevatedCard, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(LakeShowTheme.border, lineWidth: 1)
                )
            }
        }
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Quick Actions")

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(viewModel.quickActions) { action in
                    NavigationLink {
                        destination(for: action)
                    } label: {
                        QuickActionCardView(title: action.title, systemImage: action.systemImage)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func preheatImages() {
        let names = Set(preheatImageNames).filter { !$0.isEmpty }
        DispatchQueue.global(qos: .userInitiated).async {
            for name in names {
                if let image = UIImage(named: name) {
                    let key = name as NSString
                    if HomeView.preheatCache.object(forKey: key) == nil {
                        let decoded = decompressed(image: image)
                        HomeView.preheatCache.setObject(decoded, forKey: key)
                    }
                }
            }
        }
    }

    private func decompressed(image: UIImage) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
    }

    @ViewBuilder
    private func destination(for action: QuickAction) -> some View {
        switch action.title {
        case "Roster":
            RosterView()
        case "Schedule":
            ScheduleView()
        case "Stats":
            StatsView()
        default:
            TradeSimulatorView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
