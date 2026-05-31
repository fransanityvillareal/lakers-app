import Foundation

struct TradeSimulatorViewModel {
    let trade = Trade(
        lakersPlayers: ["D'Angelo Russell", "Rui Hachimura"],
        otherTeamPlayers: ["Mock Wing", "Future Pick"],
        otherTeamName: "Other Team"
    )

    let result = TradeResult(
        tradeValue: "Balanced",
        salaryMatch: "92% Match",
        teamFit: "Strong spacing fit",
        outcome: .fairTrade
    )
}
