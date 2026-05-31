import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(LakeShowTheme.mutedText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SectionHeaderView(title: "Roster", subtitle: "Mock rotation")
        .padding()
        .background(LakeShowTheme.black)
}
