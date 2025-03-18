import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View
    
    {
        NavigationView {
            SettingsContent(dismiss: dismiss)
                .environmentObject(localizationManager)
        }
    }
}

private struct SettingsContent: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    let dismiss: DismissAction
    
    var body: some View {
        List {
            LanguageSection()
        }
        .navigationTitle(localizationManager.strings.settings)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(dismiss: dismiss)
            }
        }
    }
}

private struct LanguageSection: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        Section(localizationManager.strings.languageTitle) {
            ForEach(LocalizationManager.Language.allCases, id: \.self) { language in
                LanguageRow(language: language)
            }
        }
    }
}

private struct LanguageRow: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    let language: LocalizationManager.Language
    
    var body: some View {
        Button(action: {
            localizationManager.setLanguage(language)
        }) {
            HStack {
                Text(language.rawValue)
                if localizationManager.currentLanguage == language {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

private struct BackButton: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    let dismiss: DismissAction
    
    var body: some View {
        Button(localizationManager.strings.back) {
            dismiss()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(LocalizationManager())
} 
