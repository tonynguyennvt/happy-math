import Foundation

struct DecimalProblem: MathProblem {
    let firstNumber: Int // Stored as integer (x100 for 2 decimal places)
    let secondNumber: Int // Stored as integer (x100 for 2 decimal places)
    let operation: GameType = .decimals
    let level: Int
    let operationType: OperationType
    
    enum OperationType {
        case addition
        case subtraction
        
        var symbol: String {
            switch self {
            case .addition: return "+"
            case .subtraction: return "-"
            }
        }
    }
    
    var question: String {
        let first = String(format: "%.2f", Double(firstNumber) / 100.0)
        let second = String(format: "%.2f", Double(secondNumber) / 100.0)
        return "\(first) \(operationSymbol) \(second)"
    }
    
    var operationSymbol: String {
        operationType.symbol
    }
    
    var correctAnswer: Int {
        switch operationType {
        case .addition:
            return firstNumber + secondNumber
        case .subtraction:
            return firstNumber - secondNumber
        }
    }
    
    static func random(level: Int) -> DecimalProblem {
        let operationType: OperationType = Bool.random() ? .addition : .subtraction
        let maxNumber = level * 100 // Maximum whole number part
        
        var first: Int
        var second: Int
        
        switch operationType {
        case .addition:
            first = Int.random(in: 1...maxNumber)
            second = Int.random(in: 1...(maxNumber - first))
            
        case .subtraction:
            first = Int.random(in: 1...maxNumber)
            second = Int.random(in: 1...first) // Ensure positive result
        }
        
        // Add decimal part (0-99)
        first = first * 100 + Int.random(in: 0...99)
        second = second * 100 + Int.random(in: 0...99)
        
        return DecimalProblem(
            firstNumber: first,
            secondNumber: second,
            level: level,
            operationType: operationType
        )
    }
    
    static func generateAnswerOptions(for problem: DecimalProblem) -> [Int] {
        var options = Set<Int>()
        options.insert(problem.correctAnswer)
        
        while options.count < 4 {
            // Generate wrong answers within ±10% of correct answer
            let variation = Double(problem.correctAnswer) * 0.1
            let wrongAnswer = Int(Double(problem.correctAnswer) + Double.random(in: -variation...variation))
            if wrongAnswer >= 0 {
                options.insert(wrongAnswer)
            }
        }
        
        return Array(options).shuffled()
    }
} 