import SwiftUI

struct LearnView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedGameType: GameType?
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var progressManager: ProgressManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text(localizationManager.strings.learnSection)
                    .font(.system(size: 34, weight: .bold))
                
                Spacer()
                
                // Empty view to balance the back button
                Color.clear
                    .frame(width: 30, height: 30)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            // Game type grid
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(GameType.allCases) { gameType in
                        GameTypeCard(
                            gameType: gameType,
                            level: progressManager.getLevel(for: gameType),
                            progress: progressManager.getLevelProgress(for: gameType),
                            isLocked: false,
                            onTap: { selectedGameType = gameType }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarHidden(true)
        .fullScreenCover(item: $selectedGameType) { gameType in
            GameView(gameType: gameType)
                .environmentObject(localizationManager)
                .environmentObject(progressManager)
        }
    }
}

#Preview {
    LearnView()
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 