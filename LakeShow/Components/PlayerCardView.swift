import SwiftUI

struct PlayerCardView: View {
    let player: Player

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text("\(player.jerseyNumber)")
                .font(.system(size: 82, weight: .black, design: .serif))
                .foregroundStyle(Color.black.opacity(0.045))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(width: 92, alignment: .trailing)
                .padding(.trailing, 22)
                .padding(.bottom, -18)

            HStack(spacing: 12) {
                Image(player.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 154, height: 176, alignment: .bottom)
                    .opacity(0.9)
                    .clipped()

                VStack(alignment: .leading, spacing: 8) {
                    Text(player.name.uppercased())
                        .font(.system(size: 30, weight: .black, design: .serif))
                        .foregroundStyle(LakeShowTheme.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.42)

                    PlayerRosterDetailText("\(player.height)   \(formattedWeight)   \(player.position)")
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
                .stroke(LakeShowTheme.gold.opacity(0.48), lineWidth: 1.2)
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

private struct PlayerRosterDetailText: View {
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

#Preview {
    PlayerCardView(player: MockPlayers.players[0])
        .padding()
        .background(LakeShowTheme.black)
}
