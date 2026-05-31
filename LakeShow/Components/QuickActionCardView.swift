import SwiftUI

struct QuickActionCardView: View {
    let title: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(LakeShowTheme.gold)
                .frame(width: 34, height: 34)
                .background(Color.white.opacity(0.08), in: Circle())

            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
        }
        .frame(maxWidth: .infinity, minHeight: 112, alignment: .leading)
        .padding(14)
        .background(LakeShowTheme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(LakeShowTheme.border, lineWidth: 1)
        )
    }
}

#Preview {
    QuickActionCardView(title: "Trade Simulator", systemImage: "arrow.left.arrow.right")
        .padding()
        .background(LakeShowTheme.black)
}
