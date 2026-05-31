import SwiftUI

struct GameCardView: View {
    let game: Game

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(game.matchupTitle)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("\(game.date) • \(game.time) • \(game.venueLabel)")
                        .font(.subheadline)
                        .foregroundStyle(LakeShowTheme.mutedText)
                }

                Spacer(minLength: 12)

                Text(game.status.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.14), in: Capsule())
            }

            if let lakersScore = game.lakersScore, let opponentScore = game.opponentScore {
                HStack(spacing: 14) {
                    ScorePill(team: "LAL", score: lakersScore, isHighlighted: true)
                    ScorePill(team: opponentAbbreviation, score: opponentScore, isHighlighted: false)
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

    private var statusColor: Color {
        switch game.status {
        case .upcoming:
            return LakeShowTheme.gold
        case .final:
            return .white.opacity(0.72)
        case .live:
            return .green
        }
    }

    private var opponentAbbreviation: String {
        String(game.opponent.prefix(3)).uppercased()
    }
}

private struct ScorePill: View {
    let team: String
    let score: Int
    let isHighlighted: Bool

    var body: some View {
        HStack {
            Text(team)
                .font(.caption)
                .fontWeight(.bold)

            Spacer()

            Text("\(score)")
                .font(.headline)
                .fontWeight(.bold)
        }
        .foregroundStyle(isHighlighted ? LakeShowTheme.black : .white)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(isHighlighted ? LakeShowTheme.gold : Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    GameCardView(game: MockGames.games[2])
        .padding()
        .background(LakeShowTheme.black)
}
