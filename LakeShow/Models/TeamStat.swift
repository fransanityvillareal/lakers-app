import Foundation

struct TeamStat: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let value: String
    let detail: String
    let systemImage: String
}
