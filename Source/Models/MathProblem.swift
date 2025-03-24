import Foundation

protocol MathProblem {
    var firstNumber: Int { get }
    var secondNumber: Int { get }
    var operation: GameType { get }
    var level: Int { get }
    var question: String { get }
    var correctAnswer: Int { get }
    
    static func random(level: Int) -> Self
}

extension MathProblem {
    static func random(gameType: GameType, level: Int) -> any MathProblem {
        switch gameType {
        case .addition:
            return generateAdditionProblem(level: level)
        case .subtraction:
            return generateSubtractionProblem(level: level)
        case .multiplication:
            return generateMultiplicationProblem(level: level)
        case .division:
            return generateDivisionProblem(level: level)
        case .comparison:
            return generateComparisonProblem(level: level)
        case .fractions:
            return FractionProblem.random(level: level)
        case .decimals:
            return DecimalProblem.random(level: level)
        }
    }
    
    private static func generateAdditionProblem(level: Int) -> MathProblem {
        let maxResult = level * 10
        var first: Int
        var second: Int
        
        repeat {
            first = Int.random(in: 0...maxResult)
            second = Int.random(in: 0...maxResult)
        } while first + second > maxResult
        
        return BasicMathProblem(
            firstNumber: first,
            secondNumber: second,
            operation: .addition,
            level: level
        )
    }
    
    private static func generateSubtractionProblem(level: Int) -> MathProblem {
        let maxResult = level * 10
        var first: Int
        var second: Int
        
        repeat {
            first = Int.random(in: 0...maxResult)
            second = Int.random(in: 0...maxResult)
        } while first - second < 0 || first - second > maxResult
        
        return BasicMathProblem(
            firstNumber: first,
            secondNumber: second,
            operation: .subtraction,
            level: level
        )
    }
    
    private static func generateMultiplicationProblem(level: Int) -> MathProblem {
        let first = Int.random(in: 1...level)
        let second = Int.random(in: 1...10)
        
        return BasicMathProblem(
            firstNumber: first,
            secondNumber: second,
            operation: .multiplication,
            level: level
        )
    }
    
    private static func generateDivisionProblem(level: Int) -> MathProblem {
        let second = Int.random(in: 1...level)
        let quotient = Int.random(in: 1...10)
        let first = second * quotient
        
        return BasicMathProblem(
            firstNumber: first,
            secondNumber: second,
            operation: .division,
            level: level
        )
    }
    
    private static func generateComparisonProblem(level: Int) -> MathProblem {
        let maxNumber = level * 10
        var first: Int
        var second: Int
        
        repeat {
            first = Int.random(in: 0...maxNumber)
            second = Int.random(in: 0...maxNumber)
        } while first == second
        
        return BasicMathProblem(
            firstNumber: first,
            secondNumber: second,
            operation: .comparison,
            level: level
        )
    }
}

struct BasicMathProblem: MathProblem {
    let firstNumber: Int
    let secondNumber: Int
    let operation: GameType
    let level: Int
    
    var question: String {
        switch operation {
        case .addition:
            return "\(firstNumber) + \(secondNumber)"
        case .subtraction:
            return "\(firstNumber) - \(secondNumber)"
        case .multiplication:
            return "\(firstNumber) × \(secondNumber)"
        case .division:
            return "\(firstNumber) ÷ \(secondNumber)"
        case .comparison:
            return "\(firstNumber) ? \(secondNumber)"
        default:
            return ""
        }
    }
    
    var correctAnswer: Int {
        switch operation {
        case .addition:
            return firstNumber + secondNumber
        case .subtraction:
            return firstNumber - secondNumber
        case .multiplication:
            return firstNumber * secondNumber
        case .division:
            return firstNumber / secondNumber
        case .comparison:
            return firstNumber > secondNumber ? 1 : 0
        default:
            return 0
        }
    }
    
    static func random(level: Int) -> BasicMathProblem {
        fatalError("Use MathProblem.random(gameType:level:) instead")
    }
} 
