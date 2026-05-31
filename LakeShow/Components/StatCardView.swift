import SwiftUI

struct StatCardView: View {
    let title: String
    let value: String
    var detail: String? = nil
    var systemImage: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(LakeShowTheme.mutedText)
                    .lineLimit(2)

                Spacer(minLength: 8)

                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.caption)
                        .foregroundStyle(LakeShowTheme.gold)
                }
            }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .minimumScaleFactor(0.8)

            if let detail {
                Text(detail)
                    .font(.caption2)
                    .foregroundStyle(LakeShowTheme.mutedText)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 104, alignment: .topLeading)
        .padding(14)
        .background(LakeShowTheme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(LakeShowTheme.border, lineWidth: 1)
        )
    }
}

#Preview {
    StatCardView(title: "Points", value: "117.8", detail: "Per game", systemImage: "basketball.fill")
        .padding()
        .background(LakeShowTheme.black)
}
