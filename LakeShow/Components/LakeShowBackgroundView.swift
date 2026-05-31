import SwiftUI

struct LakeShowBackgroundView: View {
    var body: some View {
        ZStack {
            LakeShowTheme.black.ignoresSafeArea()

            LinearGradient(
                colors: [
                    LakeShowTheme.deepPurple.opacity(0.88),
                    LakeShowTheme.black,
                    LakeShowTheme.purple.opacity(0.34)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LakeShowBackgroundView()
}
