import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var progressManager: ProgressManager
    @State private var showMainView = false
    
    let symbols = ["plus.circle.fill", "minus.circle.fill", "multiply.circle.fill", "divide.circle.fill"]
    let colors: [Color] = [.green, .blue, .purple, .orange]
    
    @State private var currentSymbolIndex = 0
    @State private var currentColorIndex = 0
    @State private var isAnimating = false
    
    var body: some View {
        Group {
            if showMainView {
                HomeView()
                    .transition(.opacity)
            } else {
                VStack {
                    Text(localizationManager.strings.appTitle)
                        .font(.largeTitle)
                        .bold()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 1.0), value: isAnimating)
                    
                    HStack(spacing: 20) {
                        ForEach(0..<4) { index in
                            Image(systemName: symbols[index])
                                .font(.system(size: 40))
                                .foregroundColor(colors[index])
                                .opacity(isAnimating ? 1 : 0)
                                .animation(.easeIn(duration: 0.5).delay(Double(index) * 0.2), value: isAnimating)
                        }
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
            // Transition to main view after animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    showMainView = true
                }
            }
        }
    }
}

#Preview {
    LoadingView()
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 
