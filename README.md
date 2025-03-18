# Happy Math

A fun and educational math learning app for kids, featuring various math operations and game modes.

## Features

- **Multiple Game Types**
  - Addition
  - Subtraction
  - Multiplication
  - Division
  - Number Comparison

- **Adaptive Learning**
  - Level-based progression
  - Score tracking
  - Progress visualization
  - Dynamic difficulty adjustment

- **User Interface**
  - Clean and intuitive design
  - Engaging animations
  - Full-screen game mode
  - Progress tracking
  - Multi-language support

## Navigation Flow

1. **Loading Screen**
   - App title with animations
   - Math operation symbols with animations
   - Automatic transition to home screen

2. **Home Screen**
   - Two main sections:
     - Learn: Practice math skills at your own pace
     - Champion: Compete with others (coming soon)
   - Quick access to:
     - Progress tracking
     - Settings

3. **Learn Section**
   - List of available math games
   - Each game card shows:
     - Operation symbol
     - Current level
     - Progress bar
   - Full-screen game launch

4. **Game Screen**
   - Clear problem presentation
   - Multiple choice answers
   - Real-time feedback
   - Level progress tracking
   - Score updates

## Screen Structure

```
App
└── LoadingView
    └── HomeView
        ├── LearnView
        │   └── GameView
        │       ├── Addition Game
        │       ├── Subtraction Game
        │       ├── Multiplication Game
        │       ├── Division Game
        │       └── Comparison Game
        ├── ChampionView (Coming Soon)
        ├── ProgressView (Modal)
        └── SettingsView (Modal)

Components:
├── GameButton (Used in game views)
├── GameTypeCard (Used in LearnView)
├── SettingsButton (Used in HomeView)
└── Shared Game Components
    ├── GameHeader
    ├── GameQuestion
    ├── GameAnswerOptions
    └── ProgressBar
```

## Technical Implementation

### Core Data Structures

```swift
enum GameType: String, CaseIterable, Identifiable, Codable {
    case addition, subtraction, multiplication, division, comparison
    
    var symbol: String  // SF Symbol name
    var color: Color    // SwiftUI Color
    var localizedTitle: (LocalizedStrings) -> String
}
```

### State Management

- **ProgressManager**
  - Tracks per-game progress
  - Manages levels and scores
  - Persists data using UserDefaults
  - Handles level progression

- **LocalizationManager**
  - Supports multiple languages
  - Dynamic language switching
  - System language detection

### File Structure

```
Source/
├── Models/
│   ├── GameType.swift
│   ├── GameProgress.swift
│   ├── LocalizedStrings.swift
│   └── MathProblem.swift
├── Views/
│   ├── LoadingView.swift
│   ├── HomeView.swift
│   ├── LearnView.swift
│   ├── GameView.swift
│   ├── ProgressView.swift
│   └── SettingsView.swift
├── ViewModels/
│   └── GameViewModel.swift
├── Components/
│   ├── GameButton.swift
│   ├── GameTypeCard.swift
│   └── SettingsButton.swift
└── Managers/
    ├── LocalizationManager.swift
    └── ProgressManager.swift
```

### Environment Objects

Required at root level:
```swift
@StateObject var localizationManager = LocalizationManager()
@StateObject var progressManager = ProgressManager()
```

### Persistence

- **Progress Data**
  ```json
  {
    "gameType": {
      "currentLevel": 1,
      "totalProblems": 0,
      "correctAnswers": 0,
      "highestScore": 0,
      "lastPlayed": "2024-03-16T10:00:00Z",
      "streakCount": 0
    }
  }
  ```

- **Settings**
  - Language preference
  - Game preferences
  - User progress

## Development

### Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

### Setup

1. Clone the repository
2. Open `Happy Math.xcodeproj`
3. Build and run

## Future Enhancements

- Champion mode for competitive play
- More game types
- Achievement system
- Social features
- Advanced statistics
- Custom themes

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
