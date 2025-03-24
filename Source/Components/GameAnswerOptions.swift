import SwiftUI

struct GameAnswerOptions: View {
    let gameType: GameType
    let options: [String]
    let currentAnswer: String
    let isCorrect: Bool
    let onSelect: (String) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<2) { row in
                HStack(spacing: 16) {
                    ForEach(0..<2) { col in
                        let index = row * 2 + col
                        if index < options.count {
                            AnswerButton(
                                text: options[index],
                                isSelected: options[index] == currentAnswer,
                                isCorrect: isCorrect,
                                color: gameType.color
                            ) {
                                onSelect(options[index])
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

private struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(backgroundColor)
                        .shadow(color: shadowColor, radius: 4, y: 2)
                )
        }
        .disabled(isSelected)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return isCorrect ? .green : .red
        }
        return .white
    }
    
    private var shadowColor: Color {
        if isSelected {
            return isCorrect ? .green.opacity(0.3) : .red.opacity(0.3)
        }
        return color.opacity(0.2)
    }
} 