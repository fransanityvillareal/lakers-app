import Foundation

enum MockPlayerRecentGames {
    static func recentGames(for playerName: String) -> [PlayerRecentGame] {
        switch playerName {
        case "Luka Doncic":
            return lukaGames
        case "LeBron James":
            return lebronGames
        default:
            return generatedGames(for: profile(for: playerName))
        }
    }

    private static var lukaGames: [PlayerRecentGame] {
        [
            game(
                fps: "60.2 fps",
                points: 41,
                rebounds: 9,
                assists: 11,
                opponentCode: "SAC",
                matchupLocation: .away,
                teamScore: 126,
                opponentScore: 121,
                viewers: "6.1",
                reactions: highlightReactions,
                dateLabel: "Apr 13 @ SAC",
                result: .win
            ),
            game(
                fps: "58.9 fps",
                points: 38,
                rebounds: 11,
                assists: 10,
                opponentCode: "DEN",
                matchupLocation: .home,
                teamScore: 122,
                opponentScore: 116,
                viewers: "6.8",
                reactions: featureReactions,
                dateLabel: "Apr 11 vs DEN",
                result: .win
            ),
            game(
                fps: "57.6 fps",
                points: 34,
                rebounds: 6,
                assists: 8,
                opponentCode: "PHI",
                matchupLocation: .home,
                teamScore: 119,
                opponentScore: 112,
                viewers: "5.2",
                reactions: steadyReactions,
                dateLabel: "Apr 9 vs PHI",
                result: .win
            ),
            game(
                fps: "61.4 fps",
                points: 45,
                rebounds: 8,
                assists: 12,
                opponentCode: "BOS",
                matchupLocation: .away,
                teamScore: 128,
                opponentScore: 124,
                viewers: "7.1",
                reactions: featureReactions,
                dateLabel: "Apr 7 @ BOS",
                result: .win
            ),
            game(
                fps: "54.9 fps",
                points: 31,
                rebounds: 7,
                assists: 6,
                opponentCode: "MEM",
                matchupLocation: .home,
                teamScore: 114,
                opponentScore: 109,
                viewers: "4.7",
                reactions: highlightReactions,
                dateLabel: "Apr 5 vs MEM",
                result: .win
            ),
            game(
                fps: "52.8 fps",
                points: 27,
                rebounds: 9,
                assists: 7,
                opponentCode: "OKC",
                matchupLocation: .away,
                teamScore: 108,
                opponentScore: 113,
                viewers: "4.5",
                reactions: steadyReactions,
                dateLabel: "Apr 3 @ OKC",
                result: .loss
            ),
            game(
                fps: "55.1 fps",
                points: 33,
                rebounds: 10,
                assists: 9,
                opponentCode: "NOP",
                matchupLocation: .away,
                teamScore: 117,
                opponentScore: 111,
                viewers: "5.0",
                reactions: highlightReactions,
                dateLabel: "Apr 1 @ NOP",
                result: .win
            ),
            game(
                fps: "54.3 fps",
                points: 29,
                rebounds: 8,
                assists: 11,
                opponentCode: "ORL",
                matchupLocation: .home,
                teamScore: 120,
                opponentScore: 115,
                viewers: "4.8",
                reactions: steadyReactions,
                dateLabel: "Mar 29 vs ORL",
                result: .win
            ),
            game(
                fps: "53.5 fps",
                points: 24,
                rebounds: 7,
                assists: 8,
                opponentCode: "PHI",
                matchupLocation: .home,
                teamScore: 110,
                opponentScore: 114,
                viewers: "4.3",
                reactions: steadyReactions,
                dateLabel: "Mar 27 vs PHI",
                result: .loss
            ),
            game(
                fps: "56.0 fps",
                points: 36,
                rebounds: 9,
                assists: 10,
                opponentCode: "MIL",
                matchupLocation: .away,
                teamScore: 123,
                opponentScore: 119,
                viewers: "5.5",
                reactions: featureReactions,
                dateLabel: "Mar 25 @ MIL",
                result: .win
            )
        ]
    }

    private static var lebronGames: [PlayerRecentGame] {
        [
            game(
                fps: "59.4 fps",
                points: 29,
                rebounds: 8,
                assists: 12,
                opponentCode: "SAC",
                matchupLocation: .away,
                teamScore: 118,
                opponentScore: 114,
                viewers: "6.8",
                reactions: featureReactions,
                dateLabel: "Apr 13 @ SAC",
                result: .win
            ),
            game(
                fps: "58.1 fps",
                points: 35,
                rebounds: 7,
                assists: 9,
                opponentCode: "MIN",
                matchupLocation: .home,
                teamScore: 121,
                opponentScore: 113,
                viewers: "6.2",
                reactions: highlightReactions,
                dateLabel: "Apr 11 vs MIN",
                result: .win
            ),
            game(
                fps: "55.8 fps",
                points: 22,
                rebounds: 8,
                assists: 11,
                opponentCode: "GSW",
                matchupLocation: .away,
                teamScore: 109,
                opponentScore: 111,
                viewers: "5.1",
                reactions: steadyReactions,
                dateLabel: "Apr 9 @ GSW",
                result: .loss
            ),
            game(
                fps: "56.1 fps",
                points: 26,
                rebounds: 10,
                assists: 7,
                opponentCode: "DAL",
                matchupLocation: .home,
                teamScore: 115,
                opponentScore: 108,
                viewers: "5.6",
                reactions: highlightReactions,
                dateLabel: "Apr 7 vs DAL",
                result: .win
            ),
            game(
                fps: "57.3 fps",
                points: 32,
                rebounds: 7,
                assists: 10,
                opponentCode: "HOU",
                matchupLocation: .away,
                teamScore: 117,
                opponentScore: 112,
                viewers: "5.9",
                reactions: featureReactions,
                dateLabel: "Apr 5 @ HOU",
                result: .win
            ),
            game(
                fps: "54.2 fps",
                points: 28,
                rebounds: 9,
                assists: 8,
                opponentCode: "PHX",
                matchupLocation: .home,
                teamScore: 112,
                opponentScore: 116,
                viewers: "4.9",
                reactions: steadyReactions,
                dateLabel: "Apr 3 vs PHX",
                result: .loss
            ),
            game(
                fps: "53.9 fps",
                points: 24,
                rebounds: 6,
                assists: 10,
                opponentCode: "NOP",
                matchupLocation: .away,
                teamScore: 114,
                opponentScore: 109,
                viewers: "4.7",
                reactions: highlightReactions,
                dateLabel: "Apr 1 @ NOP",
                result: .win
            ),
            game(
                fps: "55.6 fps",
                points: 31,
                rebounds: 8,
                assists: 7,
                opponentCode: "ORL",
                matchupLocation: .home,
                teamScore: 119,
                opponentScore: 112,
                viewers: "5.3",
                reactions: featureReactions,
                dateLabel: "Mar 29 vs ORL",
                result: .win
            ),
            game(
                fps: "52.7 fps",
                points: 21,
                rebounds: 9,
                assists: 9,
                opponentCode: "PHI",
                matchupLocation: .home,
                teamScore: 108,
                opponentScore: 111,
                viewers: "4.4",
                reactions: steadyReactions,
                dateLabel: "Mar 27 vs PHI",
                result: .loss
            ),
            game(
                fps: "56.2 fps",
                points: 34,
                rebounds: 7,
                assists: 11,
                opponentCode: "MIL",
                matchupLocation: .away,
                teamScore: 121,
                opponentScore: 116,
                viewers: "5.8",
                reactions: featureReactions,
                dateLabel: "Mar 25 @ MIL",
                result: .win
            )
        ]
    }

    private static func generatedGames(for profile: PlayerRecentGameProfile) -> [PlayerRecentGame] {
        let basePoints = profile.points
        let baseRebounds = max(1, profile.rebounds)
        let baseAssists = max(0, profile.assists)
        let scoringBonus = profile.rating >= 85 ? 2 : 0
        let matchups: [(String, PlayerRecentGame.MatchupLocation, String)] = [
            ("SAC", .away, "Apr 13 @ SAC"),
            ("MIN", .home, "Apr 11 vs MIN"),
            ("PHI", .home, "Apr 9 vs PHI"),
            ("BOS", .away, "Apr 7 @ BOS"),
            ("MEM", .home, "Apr 5 vs MEM"),
            ("OKC", .away, "Apr 3 @ OKC"),
            ("NOP", .away, "Apr 1 @ NOP"),
            ("ORL", .home, "Mar 29 vs ORL"),
            ("PHX", .home, "Mar 27 vs PHX"),
            ("MIL", .away, "Mar 25 @ MIL")
        ]
        let pointOffsets = [4, 1, 6, -2, 3, -4, 2, 0, -1, 5]
        let reboundOffsets = [1, 3, 0, -1, 2, 1, 2, 0, 1, -1]
        let assistOffsets = [2, 1, 0, -1, 1, -2, 2, 0, -1, 1]

        return matchups.enumerated().map { index, matchup in
            let points = max(0, basePoints + pointOffsets[index] + scoringBonus)
            let rebounds = max(1, baseRebounds + reboundOffsets[index])
            let assists = max(0, baseAssists + assistOffsets[index])
            let isWin = index < 3 || points >= basePoints + scoringBonus
            let teamScore = 104 + points / 2 + index
            let opponentScore = teamScore + (isWin ? -6 : 5)

            return game(
                fps: String(format: "%.1f fps", 51.8 + Double(index) * 1.2 + Double(profile.rating - 70) * 0.08),
                points: points,
                rebounds: rebounds,
                assists: assists,
                opponentCode: matchup.0,
                matchupLocation: matchup.1,
                teamScore: teamScore,
                opponentScore: opponentScore,
                viewers: String(format: "%.1f", max(3.2, Double(profile.tradeValue) / 18.0 + Double(index) * 0.2)),
                reactions: reactionSet(for: index, isWin: isWin),
                dateLabel: matchup.2,
                result: isWin ? .win : .loss
            )
        }
    }

    private static func reactionSet(for index: Int, isWin: Bool) -> [PlayerRecentGameReaction] {
        let reactionCount = 3.8 + Double(index) * 0.7
        return [
            PlayerRecentGameReaction(systemImage: "face.smiling", count: String(format: "%.1fk", reactionCount)),
            PlayerRecentGameReaction(systemImage: isWin ? "flame.fill" : "hand.thumbsup.fill", count: ""),
            PlayerRecentGameReaction(systemImage: index.isMultiple(of: 2) ? "sparkles" : "medal.fill", count: index.isMultiple(of: 2) ? "" : "1")
        ]
    }

    private static func game(
        fps: String,
        points: Int,
        rebounds: Int,
        assists: Int,
        opponentCode: String,
        matchupLocation: PlayerRecentGame.MatchupLocation,
        teamScore: Int,
        opponentScore: Int,
        viewers: String,
        reactions: [PlayerRecentGameReaction],
        dateLabel: String,
        result: PlayerRecentGame.Result
    ) -> PlayerRecentGame {
        PlayerRecentGame(
            fps: fps,
            points: points,
            rebounds: rebounds,
            assists: assists,
            opponentCode: opponentCode,
            matchupLocation: matchupLocation,
            teamScore: teamScore,
            opponentScore: opponentScore,
            viewers: viewers,
            reactions: reactions,
            dateLabel: dateLabel,
            result: result
        )
    }

    private static let featureReactions = [
        PlayerRecentGameReaction(systemImage: "face.smiling", count: "12.4k"),
        PlayerRecentGameReaction(systemImage: "trophy.fill", count: ""),
        PlayerRecentGameReaction(systemImage: "medal.fill", count: "2")
    ]

    private static let highlightReactions = [
        PlayerRecentGameReaction(systemImage: "face.smiling", count: "9.8k"),
        PlayerRecentGameReaction(systemImage: "flame.fill", count: ""),
        PlayerRecentGameReaction(systemImage: "sparkles", count: "")
    ]

    private static let steadyReactions = [
        PlayerRecentGameReaction(systemImage: "face.smiling", count: "8.6k"),
        PlayerRecentGameReaction(systemImage: "hand.thumbsup.fill", count: ""),
        PlayerRecentGameReaction(systemImage: "medal.fill", count: "1")
    ]

    private static func profile(for playerName: String) -> PlayerRecentGameProfile {
        switch playerName {
        case "Austin Reaves":
            return PlayerRecentGameProfile(points: 17, rebounds: 4, assists: 6, rating: 84, tradeValue: 82)
        case "Rui Hachimura":
            return PlayerRecentGameProfile(points: 14, rebounds: 5, assists: 2, rating: 80, tradeValue: 74)
        case "Deandre Ayton":
            return PlayerRecentGameProfile(points: 15, rebounds: 10, assists: 2, rating: 82, tradeValue: 78)
        case "Jarred Vanderbilt":
            return PlayerRecentGameProfile(points: 6, rebounds: 7, assists: 2, rating: 76, tradeValue: 68)
        case "Jaxson Hayes":
            return PlayerRecentGameProfile(points: 7, rebounds: 5, assists: 1, rating: 74, tradeValue: 62)
        case "Dalton Knecht":
            return PlayerRecentGameProfile(points: 9, rebounds: 3, assists: 1, rating: 75, tradeValue: 70)
        case "Bronny James":
            return PlayerRecentGameProfile(points: 4, rebounds: 2, assists: 2, rating: 70, tradeValue: 58)
        case "Maxi Kleber":
            return PlayerRecentGameProfile(points: 5, rebounds: 4, assists: 1, rating: 73, tradeValue: 60)
        case "Jake LaRavia":
            return PlayerRecentGameProfile(points: 7, rebounds: 4, assists: 2, rating: 74, tradeValue: 64)
        case "Luke Kennard":
            return PlayerRecentGameProfile(points: 9, rebounds: 3, assists: 2, rating: 76, tradeValue: 66)
        default:
            return PlayerRecentGameProfile(points: 12, rebounds: 5, assists: 3, rating: 78, tradeValue: 70)
        }
    }
}

private struct PlayerRecentGameProfile {
    let points: Int
    let rebounds: Int
    let assists: Int
    let rating: Int
    let tradeValue: Int
}
