import SwiftUI

struct RosterView: View {
    private let viewModel = RosterViewModel()

    var body: some View {
        ZStack {
            LakeShowBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
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
    }
}

#Preview {
    NavigationStack {
        RosterView()
    }
}
