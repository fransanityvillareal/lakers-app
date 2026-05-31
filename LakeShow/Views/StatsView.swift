import SwiftUI

struct StatsView: View {
    private let viewModel = StatsViewModel()
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            LakeShowBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    SectionHeaderView(title: "Team Stats", subtitle: "Mock season dashboard")

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.teamStats) { stat in
                            StatCardView(title: stat.title, value: stat.value, detail: stat.detail, systemImage: stat.systemImage)
                        }
                    }

                    efficiencySummary
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var efficiencySummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: "Snapshot")

            VStack(alignment: .leading, spacing: 10) {
                Text("Data-focused team view")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("Mock numbers are ready to be replaced by a future URLSession service without changing the screen layout.")
                    .font(.subheadline)
                    .foregroundStyle(LakeShowTheme.mutedText)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(LakeShowTheme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(LakeShowTheme.border, lineWidth: 1)
            )
        }
    }
}

#Preview {
    NavigationStack {
        StatsView()
    }
}
