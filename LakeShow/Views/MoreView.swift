import SwiftUI

struct MoreView: View {
    private let rows: [MoreRow] = [
        MoreRow(title: "Trade Simulator", subtitle: "Mock fan trade analysis", systemImage: "arrow.left.arrow.right", destination: .tradeSimulator),
        MoreRow(title: "Saved Trades", subtitle: "Placeholder", systemImage: "bookmark.fill", destination: .savedTrades),
        MoreRow(title: "Favorites", subtitle: "Placeholder", systemImage: "heart.fill", destination: .favorites),
        MoreRow(title: "Settings", subtitle: "Placeholder", systemImage: "gearshape.fill", destination: .settings),
        MoreRow(title: "About", subtitle: "Placeholder", systemImage: "info.circle.fill", destination: .about)
    ]

    var body: some View {
        ZStack {
            LakeShowBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeaderView(title: "More", subtitle: "Fan tools and app preferences")

                    VStack(spacing: 12) {
                        ForEach(rows) { row in
                            NavigationLink {
                                destination(for: row.destination)
                            } label: {
                                MoreRowView(row: row)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("More")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func destination(for destination: MoreDestination) -> some View {
        switch destination {
        case .tradeSimulator:
            TradeSimulatorView()
        case .savedTrades:
            PlaceholderDetailView(title: "Saved Trades", systemImage: "bookmark.fill")
        case .favorites:
            PlaceholderDetailView(title: "Favorites", systemImage: "heart.fill")
        case .settings:
            PlaceholderDetailView(title: "Settings", systemImage: "gearshape.fill")
        case .about:
            PlaceholderDetailView(title: "About", systemImage: "info.circle.fill")
        }
    }
}

private struct MoreRow: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
    let destination: MoreDestination
}

private enum MoreDestination {
    case tradeSimulator
    case savedTrades
    case favorites
    case settings
    case about
}

private struct MoreRowView: View {
    let row: MoreRow

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: row.systemImage)
                .font(.headline)
                .foregroundStyle(LakeShowTheme.gold)
                .frame(width: 38, height: 38)
                .background(Color.white.opacity(0.08), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(row.title)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(row.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(LakeShowTheme.mutedText)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(LakeShowTheme.mutedText)
        }
        .padding(16)
        .background(LakeShowTheme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(LakeShowTheme.border, lineWidth: 1)
        )
    }
}

private struct PlaceholderDetailView: View {
    let title: String
    let systemImage: String

    var body: some View {
        ZStack {
            LakeShowBackgroundView()

            VStack(spacing: 16) {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .foregroundStyle(LakeShowTheme.gold)

                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("This MVP placeholder is ready for the next iteration.")
                    .font(.subheadline)
                    .foregroundStyle(LakeShowTheme.mutedText)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MoreView()
    }
}
