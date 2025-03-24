import Foundation

struct FractionProblem: MathProblem {
    let firstNumber: Int // Numerator
    let secondNumber: Int // Denominator
    let operation: GameType = .fractions
    let level: Int
    
    var question: String {
        "\(firstNumber)/\(secondNumber)"
    }
    
    var correctAnswer: Int {
        // For simplicity, we'll use decimal equivalent * 100
        // This way we can work with integers in the UI
        Int((Double(firstNumber) / Double(secondNumber)) * 100)
    }
    
    static func random(level: Int) -> FractionProblem {
        let maxDenominator = min(10, level + 2) // Start with simple denominators
        let denominator = Int.random(in: 2...maxDenominator)
        let maxNumerator = level * denominator // Ensure result is appropriate for level
        let numerator = Int.random(in: 1...maxNumerator)
        
        return FractionProblem(
            firstNumber: numerator,
            secondNumber: denominator,
            level: level
        )
    }
    
    static func generateAnswerOptions(for problem: FractionProblem) -> [Int] {
        var options = Set<Int>()
        options.insert(problem.correctAnswer)
        
        while options.count < 4 {
            // Generate wrong answers within ±20% of correct answer
            let variation = Double(problem.correctAnswer) * 0.2
            let wrongAnswer = Int(Double(problem.correctAnswer) + Double.random(in: -variation...variation))
            if wrongAnswer > 0 {
                options.insert(wrongAnswer)
            }
        }
        
        return Array(options).shuffled()
    }
} 