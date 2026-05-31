import SwiftUI

struct TradeSimulatorView: View {
    private let viewModel = TradeSimulatorViewModel()

    var body: some View {
        ZStack {
            LakeShowBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header

                    VStack(spacing: 14) {
                        TradeTeamCard(
                            title: "Lakers Side",
                            subtitle: "Mock outgoing players",
                            players: viewModel.trade.lakersPlayers,
                            tint: LakeShowTheme.gold
                        )

                        Image(systemName: "arrow.up.arrow.down")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(LakeShowTheme.gold)
                            .frame(maxWidth: .infinity)

                        TradeTeamCard(
                            title: viewModel.trade.otherTeamName,
                            subtitle: "Mock incoming assets",
                            players: viewModel.trade.otherTeamPlayers,
                            tint: LakeShowTheme.purple
                        )
                    }

                    resultCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Trade Simulator")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Trade Simulator")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(.white)

            Text("Create mock Lakers trades for fun roster-building analysis.")
                .font(.subheadline)
                .foregroundStyle(LakeShowTheme.mutedText)

            Text("Fan simulator • Mock data")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(LakeShowTheme.gold)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(LakeShowTheme.gold.opacity(0.14), in: Capsule())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var resultCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(title: "Trade Result")

            VStack(spacing: 12) {
                ResultRow(title: "Trade Value", value: viewModel.result.tradeValue)
                ResultRow(title: "Salary Match", value: viewModel.result.salaryMatch)
                ResultRow(title: "Team Fit", value: viewModel.result.teamFit)
            }

            HStack {
                Text("Result")
                    .font(.subheadline)
                    .foregroundStyle(LakeShowTheme.mutedText)

                Spacer()

                Text(viewModel.result.outcome.rawValue)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(LakeShowTheme.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(LakeShowTheme.gold, in: Capsule())
            }
        }
        .padding(18)
        .background(LakeShowTheme.elevatedCard, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(LakeShowTheme.border, lineWidth: 1)
        )
    }
}

private struct TradeTeamCard: View {
    let title: String
    let subtitle: String
    let players: [String]
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(LakeShowTheme.mutedText)
                }

                Spacer()

                Image(systemName: "person.crop.circle.badge.checkmark")
                    .foregroundStyle(tint)
            }

            VStack(spacing: 10) {
                ForEach(players, id: \.self) { player in
                    HStack {
                        Image(systemName: "basketball.fill")
                            .foregroundStyle(tint)

                        Text(player)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)

                        Spacer()
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
        }
        .padding(16)
        .background(LakeShowTheme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(LakeShowTheme.border, lineWidth: 1)
        )
    }
}

private struct ResultRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(LakeShowTheme.mutedText)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        TradeSimulatorView()
    }
}
