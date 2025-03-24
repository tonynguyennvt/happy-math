import Foundation
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published private(set) var currentProblem: (any MathProblem)?
    @Published private(set) var problemText: String = ""
    @Published private(set) var currentAnswer: String = ""
    @Published private(set) var answerOptions: [String] = []
    @Published private(set) var isCorrect: Bool = false
    
    private var gameType: GameType = .addition
    private var currentLevel: Int = 1
    
    func startGame(type: GameType, level: Int) {
        gameType = type
        currentLevel = level
        generateNewProblem()
    }
    
    func checkAnswer(_ answer: String) {
        guard let problem = currentProblem else { return }
        currentAnswer = answer
        isCorrect = answer == problem.correctAnswer.description
        
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
        switch gameType {
        case .addition, .subtraction, .multiplication, .division, .comparison:
            currentProblem = BasicMathProblem.random(gameType: gameType, level: currentLevel)
        case .fractions:
            currentProblem = FractionProblem.random(level: currentLevel)
        case .decimals:
            currentProblem = DecimalProblem.random(level: currentLevel)
        }
        problemText = currentProblem?.question ?? ""
        answerOptions = generateAnswerOptions()
    }
    
    private func generateAnswerOptions() -> [String] {
        guard let problem = currentProblem else { return [] }
        
        var options = Set<String>()
        options.insert(String(problem.correctAnswer))
        
        // Generate wrong answers based on the correct answer
        while options.count < 4 {
            let wrongAnswer = generateWrongAnswer(for: problem)
            options.insert(wrongAnswer)
        }
        
        return Array(options).shuffled()
    }
    
    private func generateWrongAnswer(for problem: any MathProblem) -> String {
        let correctAnswer = problem.correctAnswer
        
        switch gameType {
        case .addition:
            let correctInt = Int(correctAnswer) ?? 0
            let wrongAnswer = correctInt + Int.random(in: -5...5)
            return String(wrongAnswer)
            
        case .subtraction:
            let correctInt = Int(correctAnswer) ?? 0
            let wrongAnswer = correctInt + Int.random(in: -5...5)
            return String(wrongAnswer)
            
        case .multiplication:
            let correctInt = Int(correctAnswer) ?? 0
            let wrongAnswer = correctInt + Int.random(in: -5...5)
            return String(wrongAnswer)
            
        case .division:
            let correctInt = Int(correctAnswer) ?? 0
            let wrongAnswer = correctInt + Int.random(in: -5...5)
            return String(wrongAnswer)
            
        case .comparison:
            let correctInt = Int(correctAnswer) ?? 0
            return correctInt == 1 ? "<" : ">"
            
        case .fractions:
            let correctInt = Int(correctAnswer) ?? 0
            let wrongAnswer = correctInt + Int.random(in: 1...5)
            return String(wrongAnswer)
            
        case .decimals:
            let correctDouble = Double(correctAnswer) ?? 0.0
            let wrongAnswer = correctDouble + Double.random(in: -0.5...0.5)
            return String(format: "%.2f", wrongAnswer)
        }
    }
} 