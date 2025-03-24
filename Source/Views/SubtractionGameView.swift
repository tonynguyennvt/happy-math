import SwiftUI

struct SubtractionGameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var progressManager: ProgressManager
    
    init() {
        _viewModel = StateObject(wrappedValue: GameViewModel())
    }
    
    private var level: Int {
        progressManager.getLevel(for: .subtraction)
    }
    
    private var score: Int {
        progressManager.getScore(for: .subtraction)
    }
    
    private var levelProgress: Double {
        progressManager.getLevelProgress(for: .subtraction)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let boxSize = min(geometry.size.width / 5, 100)
            
            VStack(spacing: 0) {
                GameHeader(
                    gameType: .subtraction,
                    levelText: localizationManager.strings.levelScore(level: level, score: score, total: level * 10),
                    levelProgress: levelProgress,
                    onBack: { dismiss() }
                )
                
                Spacer()
                    .frame(maxHeight: geometry.size.height * 0.05)
                
                GameQuestion(
                    gameType: .subtraction,
                    problemText: viewModel.problemText,
                    currentAnswer: viewModel.currentAnswer,
                    boxSize: boxSize
                )
                
                Spacer()
                    .frame(height: geometry.size.height * 0.1)
                
                GameAnswerOptions(
                    gameType: .subtraction,
                    options: viewModel.answerOptions,
                    currentAnswer: viewModel.currentAnswer,
                    isCorrect: viewModel.isCorrect,
                    onSelect: { answer in
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.checkAnswer(answer)
                            progressManager.updateProgress(for: .subtraction, isCorrect: viewModel.isCorrect)
                        }
                    }
                )
                
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
                viewModel.startGame(type: .subtraction, level: level)
            }
        }
    }
}

#Preview {
    SubtractionGameView()
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 