import SwiftUI

public enum GameType: String, CaseIterable, Identifiable, Codable {
    case addition
    case subtraction
    case multiplication
    case division
    case comparison
    
    public var id: String { rawValue }
    
    var symbol: String {
        switch self {
        case .addition: return "plus"
        case .subtraction: return "minus"
        case .multiplication: return "multiply"
        case .division: return "divide"
        case .comparison: return "arrow.left.arrow.right"
        }
    }
    
    var color: Color {
        switch self {
        case .addition: return .green
        case .subtraction: return .blue
        case .multiplication: return .purple
        case .division: return .orange
        case .comparison: return .teal
        }
    }
    
    func localizedTitle(_ strings: LocalizedStrings) -> String {
        switch self {
        case .addition: return strings.additionTitle
        case .subtraction: return strings.subtractionTitle
        case .multiplication: return strings.multiplicationTitle
        case .division: return strings.divisionTitle
        case .comparison: return strings.comparisonTitle
        }
    }
} 