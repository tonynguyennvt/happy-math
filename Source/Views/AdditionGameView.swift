import SwiftUI

struct AdditionGameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var progressManager: ProgressManager
    
    init() {
        _viewModel = StateObject(wrappedValue: GameViewModel())
    }
    
    private var level: Int {
        progressManager.getLevel(for: .addition)
    }
    
    private var score: Int {
        progressManager.getScore(for: .addition)
    }
    
    private var levelProgress: Double {
        progressManager.getLevelProgress(for: .addition)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let boxSize = min(geometry.size.width / 5, 100)
            
            VStack(spacing: 0) {
                GameHeader(
                    gameType: .addition,
                    levelText: localizationManager.strings.levelScore(level: level, score: score, total: level * 10),
                    levelProgress: levelProgress,
                    onBack: { dismiss() }
                )
                
                Spacer()
                    .frame(maxHeight: geometry.size.height * 0.05)
                
                GameQuestion(
                    gameType: .addition,
                    problemText: viewModel.problemText,
                    currentAnswer: viewModel.currentAnswer,
                    boxSize: boxSize
                )
                
                Spacer()
                    .frame(height: geometry.size.height * 0.1)
                
                GameAnswerOptions(
                    gameType: .addition,
                    options: viewModel.answerOptions,
                    currentAnswer: viewModel.currentAnswer,
                    isCorrect: viewModel.isCorrect
                ) { option in
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.checkAnswer(option)
                        progressManager.updateProgress(for: .addition, isCorrect: viewModel.isCorrect)
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
                viewModel.startGame(type: .addition, level: level)
            }
        }
    }
}

#Preview {
    AdditionGameView()
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 