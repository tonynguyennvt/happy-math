import Foundation

struct ComparisonProblem {
    let firstNumber: Int
    let secondNumber: Int
    let correctAnswer: String // ">" or "<"
    
    var question: String {
        return "\(firstNumber) ? \(secondNumber)"
    }
    
    static func random(level: Int) -> ComparisonProblem {
        let maxNumber = level * 10
        var first = Int.random(in: 0...maxNumber)
        var second = Int.random(in: 0...maxNumber)
        
        // Ensure numbers are different
        while first == second {
            second = Int.random(in: 0...maxNumber)
        }
        
        let answer = first > second ? ">" : "<"
        
        return ComparisonProblem(
            firstNumber: first,
            secondNumber: second,
            correctAnswer: answer
        )
    }
} 