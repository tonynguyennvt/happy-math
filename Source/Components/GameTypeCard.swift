import SwiftUI

// MARK: - Game Icon View
private struct GameIconView: View {
    let symbol: String
    let color: Color
    
    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: 32))
            .foregroundColor(color)
            .frame(width: 60, height: 60)
            .background(
                Circle()
                    .fill(Color(.systemBackground))
                    .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .accessibilityHidden(true)
    }
}

// MARK: - Progress Bar View
private struct ProgressBarView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(height: 6)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: geometry.size.width * progress, height: 6)
            }
        }
        .frame(height: 6)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress: \(Int(progress * 100))%")
    }
}

// MARK: - Level Info View
private struct LevelInfoView: View {
    let level: Int
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Level \(level)")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            ProgressBarView(progress: progress, color: color)
        }
    }
}

// MARK: - Main GameTypeCard View
struct GameTypeCard: View {
    let gameType: GameType
    let level: Int
    let progress: Double
    let isLocked: Bool
    let onTap: () -> Void
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                GameIconView(symbol: gameType.symbol, color: gameType.color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(gameType.localizedTitle(localizationManager.strings))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    LevelInfoView(level: level, progress: progress, color: gameType.color)
                }
                
                Spacer()
                
                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .accessibilityHidden(true)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(gameType.color.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(isLocked)
        .accessibilityLabel("\(gameType.localizedTitle(localizationManager.strings)), Level \(level)")
        .accessibilityHint(isLocked ? "Locked" : "Double tap to play")
        .accessibilityAddTraits(.isButton)
        .accessibilityElement(children: .ignore)
        .accessibilityValue(isLocked ? "Locked" : "Unlocked")
    }
}

// MARK: - Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 12) {
        GameTypeCard(
            gameType: .addition,
            level: 3,
            progress: 0.7,
            isLocked: false
        ) {}
        .environmentObject(LocalizationManager())
        
        GameTypeCard(
            gameType: .multiplication,
            level: 1,
            progress: 0.3,
            isLocked: true
        ) {}
        .environmentObject(LocalizationManager())
    }
    .padding()
    .background(Color(.systemGray6))
} 