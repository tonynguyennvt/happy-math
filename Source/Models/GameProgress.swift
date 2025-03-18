import Foundation

public struct GameProgress: Codable {
    public var totalProblems: Int = 0
    public var correctAnswers: Int = 0
    public var highestScore: Int = 0
    public var lastPlayed: Date = Date()
    public var highestDifficulty: Int = 1
    public var streakCount: Int = 0
    public var timeSpent: TimeInterval = 0
    public var averageResponseTime: TimeInterval = 0
    
    public var accuracyPercentage: Double {
        guard totalProblems > 0 else { return 0 }
        return (Double(correctAnswers) / Double(totalProblems)) * 100
    }
    
    public init(
        totalProblems: Int = 0,
        correctAnswers: Int = 0,
        highestScore: Int = 0,
        lastPlayed: Date = Date(),
        highestDifficulty: Int = 1,
        streakCount: Int = 0,
        timeSpent: TimeInterval = 0,
        averageResponseTime: TimeInterval = 0
    ) {
        self.totalProblems = totalProblems
        self.correctAnswers = correctAnswers
        self.highestScore = highestScore
        self.lastPlayed = lastPlayed
        self.highestDifficulty = highestDifficulty
        self.streakCount = streakCount
        self.timeSpent = timeSpent
        self.averageResponseTime = averageResponseTime
    }
} 