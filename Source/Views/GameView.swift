import SwiftUI

struct GameView: View {
    let gameType: GameType
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var progressManager: ProgressManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            switch gameType {
            case .addition:
                AdditionGameView()
                    .environmentObject(progressManager)
                    .environmentObject(localizationManager)
            case .subtraction:
                SubtractionGameView()
                    .environmentObject(progressManager)
                    .environmentObject(localizationManager)
            case .multiplication:
                MultiplicationGameView()
                    .environmentObject(progressManager)
                    .environmentObject(localizationManager)
            case .division:
                DivisionGameView()
                    .environmentObject(progressManager)
                    .environmentObject(localizationManager)
            case .comparison:
                ComparisonGameView()
                    .environmentObject(progressManager)
                    .environmentObject(localizationManager)
            }
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    GameView(gameType: .addition)
        .environmentObject(ProgressManager())
        .environmentObject(LocalizationManager())
}

// MARK: - Shared Game Components
struct GameHeader: View {
    let gameType: GameType
    let levelText: String
    let levelProgress: Double
    let onBack: () -> Void
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        onBack()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                        Text(localizationManager.strings.back)
                            .font(.system(.body, design: .rounded))
                    }
                    .foregroundColor(gameType.color)
                }
                
                Spacer()
                
                Text(levelText)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(gameType.color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(gameType.color.opacity(0.1))
                    )
                
                Spacer()
            }
            
            ProgressBar(progress: levelProgress, color: gameType.color)
        }
        .padding()
    }
}

struct ProgressBar: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(color.opacity(0.1))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: progress)
            }
        }
        .frame(height: 8)
    }
}

struct GameQuestion: View, Equatable {
    let gameType: GameType
    let problemText: String
    let currentAnswer: String
    let boxSize: CGFloat
    
    static func == (lhs: GameQuestion, rhs: GameQuestion) -> Bool {
        lhs.gameType == rhs.gameType &&
        lhs.problemText == rhs.problemText &&
        lhs.currentAnswer == rhs.currentAnswer &&
        lhs.boxSize == rhs.boxSize
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 20) {
                Text(problemText)
                    .font(.system(size: min(48, geometry.size.width / 8), weight: .bold, design: .rounded))
                    .foregroundColor(gameType.color)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .frame(minWidth: geometry.size.width * 0.4)
                
                Text("=")
                    .font(.system(size: min(48, geometry.size.width / 8), weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(gameType.color.opacity(0.3), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    .frame(width: boxSize * 1.5, height: boxSize)
                    .overlay(
                        Text(currentAnswer.isEmpty ? "?" : currentAnswer)
                            .font(.system(size: min(48, geometry.size.width / 8), weight: .bold, design: .rounded))
                            .foregroundColor(gameType.color)
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
        .frame(height: boxSize)
    }
}

struct GameAnswerOptions: View, Equatable {
    let gameType: GameType
    let options: [Int]
    let currentAnswer: String
    let isCorrect: Bool
    let onSelect: (Int) -> Void
    
    static func == (lhs: GameAnswerOptions, rhs: GameAnswerOptions) -> Bool {
        lhs.gameType == rhs.gameType &&
        lhs.options == rhs.options &&
        lhs.currentAnswer == rhs.currentAnswer &&
        lhs.isCorrect == rhs.isCorrect
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(options, id: \.self) { option in
                Button(action: { onSelect(option) }) {
                    Text("\(option)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(currentAnswer == String(option) ? .white : gameType.color)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    currentAnswer == String(option) ?
                                        (isCorrect ? Color.green : Color.red) :
                                        Color.white
                                )
                                .shadow(
                                    color: (currentAnswer == String(option) ? 
                                        (isCorrect ? Color.green : Color.red) : 
                                        gameType.color).opacity(0.2),
                                    radius: 4, x: 0, y: 2
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    currentAnswer == String(option) ?
                                        (isCorrect ? Color.green : Color.red) :
                                        gameType.color.opacity(0.3),
                                    lineWidth: currentAnswer == String(option) ? 2 : 1
                                )
                        )
                }
                .disabled(!currentAnswer.isEmpty)
                .animation(.spring(response: 0.3), value: currentAnswer)
            }
        }
        .padding(.horizontal, 32)
    }
}

struct GameFeedback: View {
    let message: String
    let isCorrect: Bool
    
    var body: some View {
        Text(message)
            .font(.system(.title2, design: .rounded))
            .foregroundColor(isCorrect ? .green : .orange)
            .padding(.top, 20)
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(response: 0.4), value: message)
    }
}

// Preview
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameType: .addition)
            .environmentObject(ProgressManager())
            .environmentObject(LocalizationManager())
    }
}

// Extension to ensure the view is presented in full screen style
extension View {
    func fullScreenGameView() -> some View {
        self.presentationBackground(.white)
            .presentationDragIndicator(.hidden)
            .presentationDetents([.large])
            .presentationCornerRadius(0)
    }
}