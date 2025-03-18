import SwiftUI

struct GameButton: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var progressManager: ProgressManager
    let type: GameType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: type.symbol)
                    .font(.system(size: 40))
                    .foregroundColor(type.color)
                
                Text(type.localizedTitle(localizationManager.strings))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Level \(progressManager.getLevel(for: type))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(type.color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(type.color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    GameButton(type: .addition) {}
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 