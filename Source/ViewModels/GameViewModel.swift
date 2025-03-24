import Foundation
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published private(set) var currentProblem: (any MathProblem)?
    @Published private(set) var problemText: String = ""
    @Published private(set) var currentAnswer: String = ""
    @Published private(set) var answerOptions: [Int] = []
    @Published private(set) var isCorrect: Bool = false
    
    private var gameType: GameType = .addition
    private var currentLevel: Int = 1
    
    func startGame(type: GameType, level: Int) {
        gameType = type
        currentLevel = level
        generateNewProblem()
    }
    
    func checkAnswer(_ answer: Int) {
        guard currentProblem != nil else { return }
        currentAnswer = String(answer)
        isCorrect = answer == currentProblem?.correctAnswer
        
        // Generate new problem after delay
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation {
                self.generateNewProblem()
                self.currentAnswer = ""
            }
        }
    }
    
    private func generateNewProblem() {
        currentProblem = MathProblem.random(gameType: gameType, level: currentLevel)
        problemText = currentProblem?.question ?? ""
        answerOptions = generateAnswerOptions()
    }
    
    private func generateAnswerOptions() -> [Int] {
        guard let problem = currentProblem else { return [] }
        
        switch gameType {
        case .fractions:
            if let fractionProblem = problem as? FractionProblem {
                return FractionProblem.generateAnswerOptions(for: fractionProblem)
            }
        case .decimals:
            if let decimalProblem = problem as? DecimalProblem {
                return DecimalProblem.generateAnswerOptions(for: decimalProblem)
            }
        default:
            var options = Set<Int>()
            options.insert(problem.correctAnswer)
            
            // Generate wrong answers based on the correct answer
            while options.count < 4 {
                if let wrongAnswer = generateWrongAnswer(for: problem) {
                    options.insert(wrongAnswer)
                }
            }
            
            return Array(options).shuffled()
        }
        
        return []
    }
    
    private func generateWrongAnswer(for problem: any MathProblem) -> Int? {
        let correctAnswer = problem.correctAnswer
        let level = currentLevel
        let maxResult = level * 10
        
        switch gameType {
        case .addition, .subtraction:
            // For addition and subtraction, generate answers within ±5 of correct answer
            let minAnswer = max(0, correctAnswer - 5)
            let maxAnswer = min(maxResult, correctAnswer + 5)
            var wrongAnswer = Int.random(in: minAnswer...maxAnswer)
            while wrongAnswer == correctAnswer {
                wrongAnswer = Int.random(in: minAnswer...maxAnswer)
            }
            return wrongAnswer
            
        case .multiplication:
            // For multiplication, generate answers within ±10 of correct answer
            let minAnswer = max(0, correctAnswer - 10)
            let maxAnswer = min(maxResult, correctAnswer + 10)
            var wrongAnswer = Int.random(in: minAnswer...maxAnswer)
            while wrongAnswer == correctAnswer {
                wrongAnswer = Int.random(in: minAnswer...maxAnswer)
            }
            return wrongAnswer
            
        case .division:
            // For division, generate answers within ±3 of correct answer
            let minAnswer = max(1, correctAnswer - 3)
            let maxAnswer = min(maxResult, correctAnswer + 3)
            var wrongAnswer = Int.random(in: minAnswer...maxAnswer)
            while wrongAnswer == correctAnswer {
                wrongAnswer = Int.random(in: minAnswer...maxAnswer)
            }
            return wrongAnswer
            
        case .comparison:
            // For comparison, use numbers close to the correct answer
            let wrongAnswer = correctAnswer + [-2, -1, 1, 2].randomElement()!
            return max(0, wrongAnswer) // Ensure answer is not negative
            
        default:
            return nil
        }
    }
} 