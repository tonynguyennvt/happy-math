import SwiftUI

struct FractionsGameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var progressManager: ProgressManager
    
    init() {
        _viewModel = StateObject(wrappedValue: GameViewModel())
    }
    
    private var level: Int {
        progressManager.getLevel(for: .fractions)
    }
    
    private var score: Int {
        progressManager.getScore(for: .fractions)
    }
    
    private var levelProgress: Double {
        progressManager.getLevelProgress(for: .fractions)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let boxSize = min(geometry.size.width / 5, 100)
            
            VStack(spacing: 0) {
                GameHeader(
                    gameType: .fractions,
                    levelText: localizationManager.strings.levelScore(level: level, score: score, total: level * 10),
                    levelProgress: levelProgress,
                    onBack: { dismiss() }
                )
                
                Spacer()
                    .frame(maxHeight: geometry.size.height * 0.05)
                
                // Visual fraction representation
                HStack(spacing: 20) {
                    if let problem = viewModel.currentProblem as? FractionProblem {
                        FractionView(numerator: problem.firstNumber, denominator: problem.secondNumber)
                            .frame(width: boxSize * 2, height: boxSize * 2)
                            .foregroundColor(.fractions)
                    }
                    
                    Text("=")
                        .font(.system(size: min(48, geometry.size.width / 8), weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.fractions.opacity(0.3), lineWidth: 2)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .frame(width: boxSize * 1.5, height: boxSize)
                        .overlay(
                            Text(viewModel.currentAnswer.isEmpty ? "?" : viewModel.currentAnswer)
                                .font(.system(size: min(48, geometry.size.width / 8), weight: .bold, design: .rounded))
                                .foregroundColor(.fractions)
                        )
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                Spacer()
                    .frame(height: geometry.size.height * 0.1)
                
                GameAnswerOptions(
                    gameType: .fractions,
                    options: viewModel.answerOptions,
                    currentAnswer: viewModel.currentAnswer,
                    isCorrect: viewModel.isCorrect
                ) { option in
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.checkAnswer(option)
                        progressManager.updateProgress(for: .fractions, isCorrect: viewModel.isCorrect)
                    }
                }
                
                Spacer()
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
            withAnimation(.easeInOut) {
                viewModel.startGame(type: .fractions, level: level)
            }
        }
    }
}

struct FractionView: View {
    let numerator: Int
    let denominator: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(numerator)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Rectangle()
                .frame(height: 4)
            
            Text("\(denominator)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
        }
    }
}

#Preview {
    FractionsGameView()
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 