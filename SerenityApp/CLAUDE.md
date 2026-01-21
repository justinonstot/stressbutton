# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Run

Open in Xcode and build:
```bash
open SerenityApp.xcodeproj
# Press ⌘+R to build and run
```

Requires Xcode 15+ and iOS 17.0+ simulator or device.

## Architecture

**SwiftUI + SwiftData app** for tracking anxiety events with calming audio feedback.

### Data Flow
- `SerenityApp.swift` - App entry point, creates shared `ModelContainer` for SwiftData
- `AnxietyViewModel` - Observable class managing all data operations, injected with `ModelContext`
- `AnxietyRecord` - SwiftData `@Model` storing timestamp and dayKey (yyyy-MM-dd format for efficient daily queries)

### Key Patterns
- **Audio Generation**: `AudioService` generates tones programmatically using `AVAudioEngine` - no audio files needed. Uses healing frequencies (396Hz, 528Hz, 639Hz, 741Hz) with sine waves and harmonics.
- **Date Queries**: Records use a `dayKey` string property for fast daily aggregation rather than date component extraction at query time.
- **Theme System**: `Theme.swift` centralizes all colors, gradients, and styling constants. Views use `cardStyle()` and `gradientBackground()` modifiers.

### View Hierarchy
```
ContentView (main screen with Serenity button)
└── DashboardView (analytics with charts)
    ├── BarChartView (Swift Charts)
    └── WeeklyTrendView (statistics summary)
```

## SwiftData Schema

Single model `AnxietyRecord`:
- `timestamp: Date` - exact time of event
- `dayKey: String` - "yyyy-MM-dd" for daily grouping
