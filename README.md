# Happy Math

A SwiftUI-based educational math game application designed to help children learn basic arithmetic operations in an engaging and interactive way.

## Application Overview

Happy Math is an iOS application that teaches mathematics through interactive games covering:
- Addition
- Subtraction
- Multiplication
- Division
- Number Comparison

## Project Structure

```
Happy Math/
├── Source/
│   ├── Views/
│   │   ├── LearnView.swift         # Main learning interface
│   │   ├── GameView.swift          # Base game view structure
│   │   ├── LoadingView.swift       # Initial loading screen
│   │   ├── AdditionGameView.swift  # Addition game implementation
│   │   ├── SubtractionGameView.swift
│   │   ├── MultiplicationGameView.swift
│   │   ├── DivisionGameView.swift
│   │   └── ComparisonGameView.swift
│   ├── ViewModels/
│   │   └── GameViewModel.swift     # Game logic and state management
│   ├── Models/
│   │   └── MathProblem.swift      # Problem generation and validation
│   ├── Managers/
│   │   ├── ProgressManager.swift   # User progress tracking
│   │   └── LocalizationManager.swift # Language and text management
│   └── Components/
│       └── Shared UI components
```

## Key Features

1. **Progressive Learning System**
   - Level-based progression
   - Difficulty increases gradually
   - Progress tracking across game types

2. **Interactive Game Interface**
   - Clear, child-friendly UI
   - Immediate feedback on answers
   - Animated responses for engagement

3. **Multiple Game Types**
   - Addition: Basic to complex addition problems
   - Subtraction: Learning number differences
   - Multiplication: Times tables and beyond
   - Division: Basic division concepts
   - Comparison: Greater than/less than exercises

4. **Adaptive Difficulty**
   - Problems scale with user progress
   - Answer options dynamically generated
   - Level-appropriate challenges

## Technical Implementation

### Views
- **LearnView**: Main interface showing available games and progress
- **GameView**: Base view structure for all game types
- **LoadingView**: Initial loading screen with animations
- Game-specific views for each operation type

### ViewModels
- **GameViewModel**: Manages game state and logic
  - Problem generation
  - Answer validation
  - Score tracking
  - Difficulty progression

### Models
- **MathProblem**: Defines problem structure and generation rules
- **GameType**: Enum defining different game types
- **Progress**: Tracks user advancement

### Components
- **GameButton**: Reusable game selection buttons
- **ProgressBar**: Visual progress indicator
- **GameQuestion**: Question display component
- **GameAnswerOptions**: Answer selection interface
- **GameFeedback**: User feedback display

## UI/UX Design

1. **Color Scheme**
   - Each game type has a distinct color
   - High contrast for readability
   - Child-friendly color palette

2. **Typography**
   - Rounded system fonts for readability
   - Large, clear numbers
   - Appropriate sizing for different devices

3. **Layout**
   - Spacious button layout
   - Clear visual hierarchy
   - Consistent padding and spacing

4. **Animations**
   - Smooth transitions between states
   - Feedback animations
   - Progress animations

## Game Logic

### Problem Generation
```swift
// Example problem generation for different game types
switch gameType {
case .addition:
    // Level-based number range
    let maxNumber = level * 10
    let num1 = Int.random(in: 1...maxNumber)
    let num2 = Int.random(in: 1...maxNumber)
    return MathProblem(num1: num1, num2: num2, operation: .addition)
// Similar logic for other game types
}
```

### Answer Generation
```swift
// Generate wrong answers based on correct answer
private func generateWrongAnswer(for problem: MathProblem) -> Int? {
    let correctAnswer = problem.correctAnswer
    let level = currentLevel
    
    switch gameType {
    case .addition, .subtraction:
        // Generate answers within ±5 of correct answer
        let minAnswer = max(0, correctAnswer - 5)
        let maxAnswer = min(level * 10, correctAnswer + 5)
        return Int.random(in: minAnswer...maxAnswer)
    // Similar logic for other game types
    }
}
```

## Progress Management

- Progress tracked per game type
- Level unlocking system
- Persistent storage of progress
- Achievement tracking

## Localization

- Support for multiple languages
- Localized game instructions
- Localized numbers and operations
- RTL language support

## Building the Project

1. Requirements:
   - Xcode 15.0 or later
   - iOS 17.0 or later
   - Swift 5.9 or later

2. Setup:
   ```bash
   git clone [repository-url]
   cd Happy-Math
   open Happy\ Math.xcodeproj
   ```

3. Build and run in Xcode

## Future Enhancements

1. Additional Game Types:
   - Fractions
   - Decimals
   - Basic Algebra

2. Features to Consider:
   - Multiplayer mode
   - Daily challenges
   - Achievement badges
   - Parent dashboard
   - Custom problem sets

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

Created with ❤️ for making math fun and accessible to children ages 5-12 everywhere.
