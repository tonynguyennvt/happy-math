import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var selectedDifficulty: Difficulty = .easy
    @Published var showingSettings = false
    
    enum Difficulty: String, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    // Game statistics
    @Published var totalProblems = 0
    @Published var correctAnswers = 0
    
    // Calculate progress percentage
    var progressPercentage: Double {
        guard totalProblems > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalProblems) * 100
    }
    
    // Update statistics
    func updateStats(correct: Bool) {
        totalProblems += 1
        if correct {
            correctAnswers += 1
        }
    }
    
    // Reset statistics
    func resetStats() {
        totalProblems = 0
        correctAnswers = 0
    }
}
