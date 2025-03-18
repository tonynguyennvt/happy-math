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
                            progress: progressManager.getLevelProgress(for: gameType)
                        ) {
                            selectedGameType = gameType
                        }
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

struct GameTypeCard: View {
    let gameType: GameType
    let level: Int
    let progress: Double
    let action: () -> Void
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Operation symbol circle
                Circle()
                    .fill(gameType.color)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: gameType.symbol)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(gameType.localizedTitle(localizationManager.strings))
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text("Level \(level)")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(gameType.color.opacity(0.2))
                                .frame(height: 4)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(gameType.color)
                                .frame(width: geometry.size.width * progress, height: 4)
                        }
                    }
                    .frame(height: 4)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(gameType.color.opacity(0.1))
            )
        }
    }
}

#Preview {
    LearnView()
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 