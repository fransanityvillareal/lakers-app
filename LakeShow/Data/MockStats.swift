import Foundation

enum MockStats {
    static let teamStats: [TeamStat] = [
        TeamStat(title: "Points", value: "117.8", detail: "Per game", systemImage: "basketball.fill"),
        TeamStat(title: "Rebounds", value: "43.6", detail: "Per game", systemImage: "arrow.down.circle.fill"),
        TeamStat(title: "Assists", value: "28.4", detail: "Per game", systemImage: "hand.point.up.left.fill"),
        TeamStat(title: "FG%", value: "49.1%", detail: "Field goal", systemImage: "scope"),
        TeamStat(title: "3P%", value: "37.2%", detail: "From deep", systemImage: "target"),
        TeamStat(title: "Off Rating", value: "116.9", detail: "Efficiency", systemImage: "chart.line.uptrend.xyaxis"),
        TeamStat(title: "Def Rating", value: "113.2", detail: "Stops", systemImage: "shield.fill")
    ]
}
