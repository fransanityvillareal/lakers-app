import SwiftUI

struct HomeView: View {
    private let viewModel = HomeViewModel()
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

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
