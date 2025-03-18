import Foundation

public struct MathProblem {
    public let firstNumber: Int
    public let secondNumber: Int
    public let operation: GameType
    public let level: Int
    
    // Track used results for each level and game type
    private static var usedResults: [String: Set<Int>] = [:] // [gameType_level: Set of used results]
    private static let maxAttemptsToFindNewResult = 100
    
    public var question: String {
        "\(firstNumber) \(operationSymbol) \(secondNumber)"
    }
    
    private var operationSymbol: String {
        switch operation {
        case .addition: return "+"
        case .subtraction: return "-"
        case .multiplication: return "×"
        case .division: return "÷"
        case .comparison: return "?"
        }
    }
    
    public var correctAnswer: Int {
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
            return firstNumber > secondNumber ? 1 : 0 // 1 for ">", 0 for "<"
        }
    }
    
    public init(firstNumber: Int, secondNumber: Int, operation: GameType, level: Int) {
        self.firstNumber = firstNumber
        self.secondNumber = secondNumber
        self.operation = operation
        self.level = level
    }
    
    // Reset used results for a specific level and game type
    public static func resetUsedResults(for gameType: GameType, level: Int) {
        let key = "\(gameType.rawValue)_\(level)"
        usedResults[key] = []
    }
    
    // Check if we've used all possible results for this level
    private static func hasUsedAllResults(for gameType: GameType, level: Int) -> Bool {
        let key = "\(gameType.rawValue)_\(level)"
        let maxResults = level * 10
        return usedResults[key]?.count ?? 0 >= maxResults
    }
    
    // Add a result to the used results set
    private static func addUsedResult(_ result: Int, for gameType: GameType, level: Int) {
        let key = "\(gameType.rawValue)_\(level)"
        if usedResults[key] == nil {
            usedResults[key] = []
        }
        usedResults[key]?.insert(result)
    }
    
    // Check if a result has been used
    private static func isResultUsed(_ result: Int, for gameType: GameType, level: Int) -> Bool {
        let key = "\(gameType.rawValue)_\(level)"
        // If we've used all possible results, allow repeats
        if hasUsedAllResults(for: gameType, level: level) {
            return false
        }
        return usedResults[key]?.contains(result) ?? false
    }
    
    // Generate a random math problem based on level and operation type
    public static func random(gameType: GameType, level: Int) -> MathProblem {
        let maxResult = level * 10 // Maximum allowed result for any operation
        var first: Int
        var second: Int
        var problem: MathProblem
        var attempts = 0
        
        repeat {
            attempts += 1
            switch gameType {
            case .addition:
                repeat {
                    first = Int.random(in: 0...maxResult)
                    second = Int.random(in: 0...maxResult)
                } while first + second > maxResult
                
            case .subtraction:
                repeat {
                    first = Int.random(in: 0...maxResult)
                    second = Int.random(in: 0...maxResult)
                } while first - second < 0 || first - second > maxResult
                
            case .multiplication:
                // First number: Random number from 1 to n (level)
                // Second number: Random number from 1 to 10
                first = Int.random(in: 1...level)
                second = Int.random(in: 1...10)
                
            case .division:
                // Second number: Random number from 1 to n (level)
                second = Int.random(in: 1...level)
                // Generate a random quotient from 1 to 10
                let quotient = Int.random(in: 1...10)
                // Calculate first number to ensure it's divisible by second number
                first = second * quotient
                // If first number is too large, adjust it
                if first > maxResult {
                    first = maxResult - (maxResult % second)
                }
                
            case .comparison:
                repeat {
                    first = Int.random(in: 0...maxResult)
                    second = Int.random(in: 0...maxResult)
                } while first == second // Ensure numbers are different
            }
            
            problem = MathProblem(
                firstNumber: first,
                secondNumber: second,
                operation: gameType,
                level: level
            )
            
            // If we've tried too many times, allow a repeat
            if attempts >= maxAttemptsToFindNewResult {
                break
            }
            
        } while isResultUsed(problem.correctAnswer, for: gameType, level: level)
        
        // Only store the result if we haven't used all possible results
        if !hasUsedAllResults(for: gameType, level: level) {
            addUsedResult(problem.correctAnswer, for: gameType, level: level)
        }
        
        return problem
    }
} 
