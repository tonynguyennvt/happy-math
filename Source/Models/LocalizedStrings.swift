import Foundation

public struct LocalizedStrings {
    private let language: LocalizationManager.Language
    
    public init(language: LocalizationManager.Language) {
        self.language = language
    }
    
    // MARK: - Game Types
    public var additionTitle: String {
        switch language {
        case .english: return "Addition Fun"
        case .chinese: return "加法乐趣"
        case .vietnamese: return "Phép Cộng"
        case .system: return "Addition Fun"
        }
    }
    
    public var subtractionTitle: String {
        switch language {
        case .english: return "Subtraction Fun"
        case .chinese: return "减法乐趣"
        case .vietnamese: return "Phép Trừ"
        case .system: return "Subtraction Fun"
        }
    }
    
    public var comparisonTitle: String {
        switch language {
        case .english: return "Number Compare"
        case .chinese: return "数字比较"
        case .vietnamese: return "So Sánh"
        case .system: return "Number Compare"
        }
    }
    
    public var multiplicationTitle: String {
        switch language {
        case .english: return "Multiplication Magic"
        case .chinese: return "乘法魔法"
        case .vietnamese: return "Phép Nhân"
        case .system: return "Multiplication Magic"
        }
    }
    
    public var divisionTitle: String {
        switch language {
        case .english: return "Division Quest"
        case .chinese: return "除法探索"
        case .vietnamese: return "Phép Chia"
        case .system: return "Division Quest"
        }
    }
    
    // MARK: - Navigation
    public var back: String {
        switch language {
        case .english: return "Back"
        case .chinese: return "返回"
        case .vietnamese: return "Quay lại"
        case .system: return "Back"
        }
    }
    
    public var done: String {
        switch language {
        case .english: return "Done"
        case .chinese: return "完成"
        case .vietnamese: return "Xong"
        case .system: return "Done"
        }
    }
    
    public var progressTitle: String {
        switch language {
        case .english: return "Game Progress"
        case .chinese: return "游戏进度"
        case .vietnamese: return "Tiến độ trò chơi"
        case .system: return "Game Progress"
        }
    }
    
    public var settings: String {
        switch language {
        case .english: return "Settings"
        case .chinese: return "设置"
        case .vietnamese: return "Cài đặt"
        case .system: return "Settings"
        }
    }
    
    public var progress: String {
        switch language {
        case .english: return "Progress"
        case .chinese: return "进度"
        case .vietnamese: return "Tiến độ"
        case .system: return "Progress"
        }
    }
    
    // MARK: - Sections
    public var appTitle: String {
        switch language {
        case .english: return "Happy Math!"
        case .chinese: return "快乐数学！"
        case .vietnamese: return "Toán Vui!"
        case .system: return "Happy Math!"
        }
    }
    
    public var learnSection: String {
        switch language {
        case .english: return "Learn"
        case .chinese: return "学习"
        case .vietnamese: return "Học tập"
        case .system: return "Learn"
        }
    }
    
    public var championSection: String {
        switch language {
        case .english: return "Champion"
        case .chinese: return "冠军"
        case .vietnamese: return "Vô địch"
        case .system: return "Champion"
        }
    }
    
    public var practiceDescription: String {
        switch language {
        case .english: return "Practice math skills at your own pace"
        case .chinese: return "按照自己的节奏练习数学技能"
        case .vietnamese: return "Luyện tập kỹ năng toán học theo tốc độ của bạn"
        case .system: return "Practice math skills at your own pace"
        }
    }
    
    public var competeDescription: String {
        switch language {
        case .english: return "Challenge yourself and compete with others"
        case .chinese: return "挑战自己，与他人竞争"
        case .vietnamese: return "Thử thách bản thân và thi đấu với người khác"
        case .system: return "Challenge yourself and compete with others"
        }
    }
    
    // MARK: - Game UI
    public func levelScore(level: Int, score: Int, total: Int) -> String {
        switch language {
        case .english:
            return "Level \(level) • \(score)/\(total)"
        case .chinese:
            return "等级 \(level) • \(score)/\(total)"
        case .vietnamese:
            return "Cấp \(level) • \(score)/\(total)"
        case .system:
            return "Level \(level) • \(score)/\(total)"
        }
    }
    
    public func level(_ number: Int) -> String {
        switch language {
        case .english:
            return "Level \(number)"
        case .chinese:
            return "等级 \(number)"
        case .vietnamese:
            return "Cấp \(number)"
        case .system:
            return "Level \(number)"
        }
    }
    
    // MARK: - Language selection
    public var languageTitle: String {
        switch language {
        case .english: return "Language"
        case .chinese: return "语言"
        case .vietnamese: return "Ngôn ngữ"
        case .system: return "Language"
        }
    }
    
    public var english: String {
        switch language {
        case .english: return "English"
        case .chinese: return "英语"
        case .vietnamese: return "Tiếng Anh"
        case .system: return "English"
        }
    }
    
    public var chinese: String {
        switch language {
        case .english: return "Chinese"
        case .chinese: return "中文"
        case .vietnamese: return "Tiếng Trung"
        case .system: return "Chinese"
        }
    }
    
    public var vietnamese: String {
        switch language {
        case .english: return "Vietnamese"
        case .chinese: return "越南语"
        case .vietnamese: return "Tiếng Việt"
        case .system: return "Vietnamese"
        }
    }
    
    // MARK: - Comparison Game
    public var greaterThan: String {
        switch language {
        case .english: return "Greater than"
        case .chinese: return "大于"
        case .vietnamese: return "Lớn hơn"
        case .system: return "Greater than"
        }
    }
    
    public var lessThan: String {
        switch language {
        case .english: return "Less than"
        case .chinese: return "小于"
        case .vietnamese: return "Nhỏ hơn"
        case .system: return "Less than"
        }
    }
    
    // MARK: - Feedback Messages
    public var correct: String {
        switch language {
        case .english: return "Correct! 🎉"
        case .chinese: return "正确！🎉"
        case .vietnamese: return "Đúng rồi! 🎉"
        case .system: return "Correct! 🎉"
        }
    }
    
    public var tryAgain: String {
        switch language {
        case .english: return "Try again! 😊"
        case .chinese: return "再试一次！😊"
        case .vietnamese: return "Thử lại nhé! 😊"
        case .system: return "Try again! 😊"
        }
    }
} 
