import Foundation
import SwiftUI

@MainActor
public final class ProgressManager: ObservableObject {
    @Published public private(set) var progress: [GameType: GameProgress] = [:]
    @Published private(set) var currentLevels: [GameType: Int] = [:]
    @Published private(set) var currentScores: [GameType: Int] = [:]
    
    private let defaults = UserDefaults.standard
    private let progressKey = "gameProgress"
    private let scoreKey = "gameScore"
    private let levelKey = "gameLevel"
    private var lastAnswerTime: Date?
    private var pendingUpdates: Set<GameType> = []
    
    public init() {
        loadProgress()
    }
    
    private func loadProgress() {
        // Load scores and levels
        for gameType in GameType.allCases {
            currentScores[gameType] = defaults.integer(forKey: "\(scoreKey)_\(gameType.rawValue)")
            currentLevels[gameType] = defaults.integer(forKey: "\(levelKey)_\(gameType.rawValue)")
            if currentLevels[gameType] == 0 {
                currentLevels[gameType] = 1
            }
        }
        
        // Load detailed progress
        if let data = defaults.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode([GameType: GameProgress].self, from: data) {
            progress = decoded
        }
    }
    
    // Calculate points needed for current level
    private func pointsRequiredForLevel(_ level: Int) -> Int {
        return level * 10
    }
    
    // Get level for a specific game type
    public func getLevel(for gameType: GameType) -> Int {
        return currentLevels[gameType] ?? 1
    }
    
    // Get score for a specific game type
    public func getScore(for gameType: GameType) -> Int {
        return currentScores[gameType] ?? 0
    }
    
    // Get progress percentage towards next level
    public func getLevelProgress(for gameType: GameType) -> Double {
        let currentScore = getScore(for: gameType)
        let currentLevel = getLevel(for: gameType)
        let pointsNeeded = pointsRequiredForLevel(currentLevel)
        return min(1.0, max(0.0, Double(currentScore) / Double(pointsNeeded)))
    }
    
    // Update progress when a problem is solved
    public func updateProgress(for gameType: GameType, isCorrect: Bool) {
        var currentScore = currentScores[gameType] ?? 0
        var currentLevel = currentLevels[gameType] ?? 1
        
        if isCorrect {
            currentScore += 1
            // Check for level up
            if currentScore >= pointsRequiredForLevel(currentLevel) {
                currentLevel += 1
                currentScore = 0
            }
        } else {
            // Only decrease score if we're not at level 1 with score 0
            if !(currentLevel == 1 && currentScore == 0) {
                currentScore -= 1
                // Check for level down
                if currentScore < 0 && currentLevel > 1 {
                    currentLevel -= 1
                    currentScore = pointsRequiredForLevel(currentLevel) - 1
                }
            }
        }
        
        // Ensure score doesn't go below 0 at level 1
        if currentLevel == 1 && currentScore < 0 {
            currentScore = 0
        }
        
        // Update published properties
        currentLevels[gameType] = currentLevel
        currentScores[gameType] = currentScore
        
        // Update progress details
        var currentProgress = progress[gameType] ?? GameProgress()
        currentProgress.totalProblems += 1
        if isCorrect {
            currentProgress.correctAnswers += 1
            currentProgress.streakCount += 1
        } else {
            currentProgress.streakCount = 0
        }
        
        // Update time-based stats
        let now = Date()
        if let lastTime = lastAnswerTime {
            let responseTime = now.timeIntervalSince(lastTime)
            currentProgress.timeSpent += responseTime
        }
        lastAnswerTime = now
        
        // Update other stats
        currentProgress.lastPlayed = now
        currentProgress.highestScore = max(currentProgress.highestScore, currentScore)
        currentProgress.highestDifficulty = max(currentProgress.highestDifficulty, currentLevel)
        
        progress[gameType] = currentProgress
        
        // Save progress immediately
        saveProgress(for: gameType)
    }
    
    private func saveProgress(for gameType: GameType) {
        // Save scores and levels
        defaults.set(currentScores[gameType], forKey: "\(scoreKey)_\(gameType.rawValue)")
        defaults.set(currentLevels[gameType], forKey: "\(levelKey)_\(gameType.rawValue)")
        
        // Save detailed progress
        if let encoded = try? JSONEncoder().encode(progress) {
            defaults.set(encoded, forKey: progressKey)
        }
    }
    
    // Reset progress for a specific game type
    public func resetProgress(for gameType: GameType) {
        currentScores[gameType] = 0
        currentLevels[gameType] = 1
        progress[gameType] = GameProgress()
        saveProgress(for: gameType)
    }
    
    // Reset all progress
    public func resetAllProgress() {
        for gameType in GameType.allCases {
            resetProgress(for: gameType)
        }
    }
    
    // Get progress for a specific game type
    public func getProgress(for gameType: GameType) -> GameProgress {
        return progress[gameType] ?? GameProgress()
    }
    
    // Get total progress across all game types
    public func getTotalProgress() -> GameProgress {
        progress.values.reduce(GameProgress()) { result, current in
            GameProgress(
                totalProblems: result.totalProblems + current.totalProblems,
                correctAnswers: result.correctAnswers + current.correctAnswers,
                highestScore: max(result.highestScore, current.highestScore),
                lastPlayed: max(result.lastPlayed, current.lastPlayed),
                highestDifficulty: max(result.highestDifficulty, current.highestDifficulty),
                streakCount: max(result.streakCount, current.streakCount),
                timeSpent: result.timeSpent + current.timeSpent,
                averageResponseTime: (result.averageResponseTime + current.averageResponseTime) / 2
            )
        }
    }
} 