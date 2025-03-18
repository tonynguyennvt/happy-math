import SwiftUI

struct ProgressView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var progressManager: ProgressManager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(localizationManager.strings.progressTitle)) {
                    ProgressRow(gameType: .addition)
                    ProgressRow(gameType: .subtraction)
                    ProgressRow(gameType: .multiplication)
                    ProgressRow(gameType: .division)
                    ProgressRow(gameType: .comparison)
                }
            }
            .navigationTitle(localizationManager.strings.progress)
            .navigationBarItems(trailing: Button(localizationManager.strings.done) {
                dismiss()
            })
        }
    }
}

struct ProgressRow: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var localizationManager: LocalizationManager
    let gameType: GameType
    
    var body: some View {
        HStack {
            Image(systemName: gameType.symbol)
                .foregroundColor(gameType.color)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(gameType.localizedTitle(localizationManager.strings))
                    .font(.headline)
                Text(localizationManager.strings.level(progressManager.getLevel(for: gameType)))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(String(progressManager.getScore(for: gameType)))
                .font(.headline)
                .foregroundColor(gameType.color)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ProgressView()
        .environmentObject(LocalizationManager())
} 
