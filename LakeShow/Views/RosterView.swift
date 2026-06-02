import SwiftUI

struct RosterView: View {
    @Environment(\.displayScale) private var displayScale
    private let viewModel = RosterViewModel()

    var body: some View {
        ZStack {
            LakeShowBackgroundView()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {
                    SectionHeaderView(title: "Roster", subtitle: "Mock Lakers rotation and trade values")

                    ForEach(viewModel.players) { player in
                        NavigationLink {
                            PlayerDetailView(player: player)
                        } label: {
                            PlayerCardView(player: player)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 0)
                .padding(.top, 18)
                .padding(.bottom, 32)
            }
            .ignoresSafeArea(.container, edges: .horizontal)
        }
        .navigationTitle("Roster")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            RosterImagePreheater.shared.preheat(names: viewModel.players.map(\.imageName), scale: displayScale)
        }
    }
}

#Preview {
    NavigationStack {
        RosterView()
    }
}
