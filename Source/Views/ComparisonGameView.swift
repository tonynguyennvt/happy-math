import SwiftUI

struct ComparisonGameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var progressManager: ProgressManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    @State private var currentProblem: ComparisonProblem
    @State private var selectedAnswer: String?
    @State private var feedbackMessage: String?
    @State private var isCorrect = false
    
    private var level: Int {
        progressManager.getLevel(for: .comparison)
    }
    
    private var score: Int {
        progressManager.getScore(for: .comparison)
    }
    
    private var levelProgress: Double {
        progressManager.getLevelProgress(for: .comparison)
    }
    
    private var answerOptions: [(symbol: String, text: String)] {
        [
            (symbol: ">", text: localizationManager.strings.greaterThan),
            (symbol: "<", text: localizationManager.strings.lessThan)
        ]
    }
    
    init() {
        _currentProblem = State(initialValue: ComparisonProblem.random(level: 1))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                GameHeader(
                    gameType: .comparison,
                    levelText: localizationManager.strings.levelScore(level: level, score: score, total: level * 10),
                    levelProgress: levelProgress,
                    onBack: { dismiss() }
                )
                
                Spacer()
                    .frame(maxHeight: geometry.size.height * 0.05)
                
                // Question
                HStack(spacing: min(40, geometry.size.width * 0.1)) {
                    Text("\(currentProblem.firstNumber)")
                        .font(.system(size: min(72, geometry.size.width / 6), weight: .bold, design: .rounded))
                        .foregroundColor(.teal)
                    
                    Text("?")
                        .font(.system(size: min(72, geometry.size.width / 6), weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                    
                    Text("\(currentProblem.secondNumber)")
                        .font(.system(size: min(72, geometry.size.width / 6), weight: .bold, design: .rounded))
                        .foregroundColor(.teal)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                Spacer()
                    .frame(height: geometry.size.height * 0.08)
                
                // Answer options in horizontal row
                HStack(spacing: min(20, geometry.size.width * 0.05)) {
                    ForEach(answerOptions, id: \.symbol) { option in
                        Button(action: {
                            checkAnswer(option.symbol)
                        }) {
                            VStack(spacing: 8) {
                                Text(option.symbol)
                                    .font(.system(size: min(36, geometry.size.width / 10), weight: .bold, design: .rounded))
                                Text(option.text)
                                    .font(.system(size: min(16, geometry.size.width / 20), weight: .medium, design: .rounded))
                                    .multilineTextAlignment(.center)
                            }
                            .foregroundColor(selectedAnswer == option.symbol ? .white : .teal)
                            .frame(width: min(140, geometry.size.width / 2.5), height: min(140, geometry.size.width / 2.5))
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        selectedAnswer == option.symbol ?
                                            (isCorrect ? Color.green : Color.red) :
                                            Color.white
                                    )
                                    .shadow(
                                        color: (selectedAnswer == option.symbol ?
                                            (isCorrect ? Color.green : Color.red) :
                                            Color.teal).opacity(0.2),
                                        radius: 4, x: 0, y: 2
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        selectedAnswer == option.symbol ?
                                            (isCorrect ? Color.green : Color.red) :
                                            Color.teal.opacity(0.3),
                                        lineWidth: selectedAnswer == option.symbol ? 2 : 1
                                    )
                            )
                        }
                        .disabled(selectedAnswer != nil)
                        .animation(.spring(response: 0.3), value: selectedAnswer)
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                    .frame(height: geometry.size.height * 0.1)
                
                // Feedback message
                if let message = feedbackMessage {
                    GameFeedback(message: message, isCorrect: isCorrect)
                }
                
                Spacer()
                    .frame(maxHeight: geometry.size.height * 0.05)
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
        .interactiveDismissDisabled(true)
        .ignoresSafeArea(.keyboard)
        .background(Color.white)
        .presentationDragIndicator(.hidden)
        .presentationDetents([.large])
        .presentationBackground(.clear)
        .onAppear {
            currentProblem = ComparisonProblem.random(level: level)
        }
    }
    
    private func checkAnswer(_ answer: String) {
        selectedAnswer = answer
        isCorrect = answer == currentProblem.correctAnswer
        
        // Update progress in ProgressManager
        progressManager.updateProgress(for: .comparison, isCorrect: isCorrect)
        
        // Show feedback
        feedbackMessage = isCorrect ? localizationManager.strings.correct : localizationManager.strings.tryAgain
        
        // Generate new problem after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                currentProblem = ComparisonProblem.random(level: level)
                selectedAnswer = nil
                feedbackMessage = nil
            }
        }
    }
}

#Preview {
    ComparisonGameView()
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 