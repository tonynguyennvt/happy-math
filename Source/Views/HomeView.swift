import SwiftUI

struct HomeView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var progressManager: ProgressManager
    @State private var selectedSection: MenuSection?
    @State private var showProgress = false
    @State private var showSettings = false
    
    enum MenuSection: String, Identifiable {
        case learn = "Learn"
        case champion = "Champion"
        
        var id: String { rawValue }
        
        var symbol: String {
            switch self {
            case .learn: return "book.fill"
            case .champion: return "trophy.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .learn: return .blue
            case .champion: return .orange
            }
        }
        
        func description(_ strings: LocalizedStrings) -> String {
            switch self {
            case .learn: return strings.practiceDescription
            case .champion: return strings.competeDescription
            }
        }
        
        func title(_ strings: LocalizedStrings) -> String {
            switch self {
            case .learn: return strings.learnSection
            case .champion: return strings.championSection
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Title
                Text(localizationManager.strings.appTitle)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                // Main menu sections in grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach([MenuSection.learn, MenuSection.champion]) { section in
                        Button(action: {
                            selectedSection = section
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: section.symbol)
                                    .font(.system(size: 40))
                                    .foregroundColor(section.color)
                                
                                Text(section.title(localizationManager.strings))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text(section.description(localizationManager.strings))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(section.color.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .strokeBorder(section.color.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Bottom buttons
                HStack(spacing: 40) {
                    // Progress button
                    Button(action: {
                        showProgress = true
                    }) {
                        VStack {
                            Image(systemName: "chart.bar.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text(localizationManager.strings.progress)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Settings button
                    Button(action: {
                        showSettings = true
                    }) {
                        VStack {
                            Image(systemName: "gearshape.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                            Text(localizationManager.strings.settings)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .fullScreenCover(item: $selectedSection) { section in
            if section == .learn {
                LearnView()
                    .environmentObject(localizationManager)
                    .environmentObject(progressManager)
            } else {
                ChampionView()
                    .environmentObject(localizationManager)
            }
        }
        .sheet(isPresented: $showProgress) {
            ProgressView()
                .environmentObject(localizationManager)
                .environmentObject(progressManager)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(localizationManager)
        }
    }
}

struct ChampionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text(localizationManager.strings.championSection)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding()
            
            // Coming soon message
            VStack(spacing: 16) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("Coming Soon!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Get ready for exciting math challenges and compete with other players!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(LocalizationManager())
        .environmentObject(ProgressManager())
} 