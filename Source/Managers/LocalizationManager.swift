import Foundation
import SwiftUI

@MainActor
public class LocalizationManager: ObservableObject {
    public enum Language: String, CaseIterable {
        case system = "System"
        case english = "English"
        case chinese = "中文"
        case vietnamese = "Tiếng Việt"
    }
    
    @Published public private(set) var currentLanguage: Language
    @Published public private(set) var strings: LocalizedStrings
    
    public init() {
        // Get the saved language from UserDefaults
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
        let initialLanguage = savedLanguage.flatMap(Language.init) ?? .system
        
        // Get the effective language for strings initialization
        let effectiveLanguage: Language
        if initialLanguage == .system {
            let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
            effectiveLanguage = Language(rawValue: languageCode) ?? .english
        } else {
            effectiveLanguage = initialLanguage
        }
        
        // Initialize all stored properties
        self.currentLanguage = initialLanguage
        self.strings = LocalizedStrings(language: effectiveLanguage)
    }
    
    public func setLanguage(_ language: Language) {
        currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "selectedLanguage")
        updateLocalizedStrings()
    }
    
    private func getEffectiveLanguage() -> Language {
        if currentLanguage == .system {
            let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
            return Language(rawValue: languageCode) ?? .english
        }
        return currentLanguage
    }
    
    private func updateLocalizedStrings() {
        strings = LocalizedStrings(language: getEffectiveLanguage())
    }
} 