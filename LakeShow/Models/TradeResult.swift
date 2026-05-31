import Foundation

enum TradeOutcome: String {
    case fairTrade = "Fair Trade"
    case riskyTrade = "Risky Trade"
    case salaryMismatch = "Salary Mismatch"
}

struct TradeResult: Hashable {
    let tradeValue: String
    let salaryMatch: String
    let teamFit: String
    let outcome: TradeOutcome
}
