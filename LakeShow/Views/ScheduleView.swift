import SwiftUI

struct ScheduleView: View {
    private let viewModel = ScheduleViewModel()

    var body: some View {
        ZStack {
            LakeShowBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeaderView(title: "Schedule", subtitle: "Upcoming, live, and recent mock games")

                    ForEach(viewModel.games) { game in
                        GameCardView(game: game)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Schedule")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ScheduleView()
    }
}
