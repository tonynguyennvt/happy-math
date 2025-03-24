import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var progressManager: ProgressManager
    @State private var showMainView = false
    
    let symbols = ["plus.circle.fill", "minus.circle.fill", "multiply.circle.fill", "divide.circle.fill", "greaterthan.circle.fill"]
    let colors: [Color] = [.green, .blue, .purple, .orange, .pink]
    
    @State private var isAnimating = false
    @State private var textScale: CGFloat = 1.0
    @State private var showStars = false
    @State private var showBubbles = false
    @State private var showHearts = false
    
    var body: some View {
        Group {
            if showMainView {
                HomeView()
                    .transition(.opacity)
            } else {
                ZStack {
                    // Fun background with animated shapes
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.15),
                            Color.purple.opacity(0.15),
                            Color.pink.opacity(0.15)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // Animated background shapes
                    ForEach(0..<8) { index in
                        Circle()
                            .fill(Color.random.opacity(0.1))
                            .frame(width: CGFloat.random(in: 50...150))
                            .position(
                                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                            )
                            .animation(
                                Animation.easeInOut(duration: Double.random(in: 2...4))
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    }
                    
                    VStack(spacing: 30) {
                        // Fun app title with rainbow effect and bounce
                        VStack(spacing: 5) {
                            Text("HAPPY")
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple, .pink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .scaleEffect(textScale)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.6)
                                        .repeatForever(autoreverses: true),
                                    value: textScale
                                )
                            
                            Text("MATH")
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.orange, .green, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .scaleEffect(textScale)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.6)
                                        .repeatForever(autoreverses: true),
                                    value: textScale
                                )
                        }
                        
                        // Game icons with fun animations
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: symbols[index])
                                    .font(.system(size: 45))
                                    .foregroundColor(colors[index])
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                                    .animation(
                                        .linear(duration: 3)
                                            .repeatForever(autoreverses: false),
                                        value: isAnimating
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            isAnimating = true
            textScale = 1.1
            showStars = true
            showBubbles = true
            showHearts = true
            
            // Transition to main view after animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    showMainView = true
                }
            }
        }
    }
}

// MARK: - Helper Extensions
extension Color {
    static var random: Color {
        Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

#Preview {
    LoadingView()
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 
