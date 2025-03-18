import SwiftUI

struct SettingsButton: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var showSettings = false
    
    var body: some View {
        Button(action: {
            showSettings = true
        }) {
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(localizationManager)
        }
    }
} 