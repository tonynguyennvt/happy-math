import SwiftUI

struct DecimalsGameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var progressManager: ProgressManager
    
    init() {
        _viewModel = StateObject(wrappedValue: GameViewModel())
    }
    
    private var level: Int {
        progressManager.getLevel(for: .decimals)
    }
    
    private var score: Int {
        progressManager.getScore(for: .decimals)
    }
    
    private var levelProgress: Double {
        progressManager.getLevelProgress(for: .decimals)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let boxSize = min(geometry.size.width / 5, 100)
            
            VStack(spacing: 0) {
                GameHeader(
                    gameType: .decimals,
                    levelText: localizationManager.strings.levelScore(level: level, score: score, total: level * 10),
                    levelProgress: levelProgress,
                    onBack: { dismiss() }
                )
                
                Spacer()
                    .frame(maxHeight: geometry.size.height * 0.05)
                
                // Decimal problem display
                HStack(spacing: 20) {
                    if let problem = viewModel.currentProblem as? DecimalProblem {
                        Text(String(format: "%.2f", Double(problem.firstNumber) / 100.0))
                            .font(.system(size: min(48, geometry.size.width / 8), weight: .bold, design: .rounded))
                            .foregroundColor(.decimals)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .frame(minWidth: geometry.size.width * 0.4)
                        
                        Text(problem.operationSymbol)
                            .font(.system(size: min(48, geometry.size.width / 8), weight: .bold, design: .rounded))
                            .foregroundColor(.decimals)
                        
                        Text(String(format: "%.2f", Double(problem.secondNumber) / 100.0))
                            .font(.system(size: min(48, geometry.size.width / 8), weight: .bold, design: .rounded))
                            .foregroundColor(.decimals)
                    }
                    
                    Text("=")
                        .font(.system(size: min(48, geometry.size.width / 8), weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.decimals.opacity(0.3), lineWidth: 2)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .frame(width: boxSize * 2, height: boxSize)
                        .overlay(
                            Text(viewModel.currentAnswer.isEmpty ? "?" : viewModel.currentAnswer)
                                .font(.system(size: min(48, geometry.size.width / 8), weight: .bold, design: .rounded))
                                .foregroundColor(.decimals)
                        )
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                Spacer()
                    .frame(height: geometry.size.height * 0.1)
                
                GameAnswerOptions(
                    gameType: .decimals,
                    options: viewModel.answerOptions,
                    currentAnswer: viewModel.currentAnswer,
                    isCorrect: viewModel.isCorrect
                ) { option in
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.checkAnswer(option)
                        progressManager.updateProgress(for: .decimals, isCorrect: viewModel.isCorrect)
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
                viewModel.startGame(type: .decimals, level: level)
            }
        }
    }
}

#Preview {
    DecimalsGameView()
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 