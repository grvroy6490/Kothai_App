# Kothai App - Complete Architecture & Flow Diagram

## Excalidraw Diagram Instructions

Copy the following diagram structure into Excalidraw to visualize your complete app architecture:

## 🏗️ **ARCHITECTURE OVERVIEW**

### **1. APP STRUCTURE (Top Level)**
```
┌─────────────────────────────────────────────────────────────┐
│                    KOTHAI TYPING APP                        │
├─────────────────────────────────────────────────────────────┤
│  📱 Flutter App (Material Design)                          │
│  🔄 Riverpod State Management                              │
│  🎯 Clean Architecture (Domain-Data-Presentation)         │
│  🎮 Gamification System                                    │
│  🔐 Firebase Authentication                               │
│  💾 SQLite + SharedPreferences Storage                    │
└─────────────────────────────────────────────────────────────┘
```

### **2. NAVIGATION FLOW**
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   SPLASH    │───▶│    APP      │───▶│  PRACTICE   │───▶│   CHALLENGE │
│    PAGE     │    │   LAYOUT    │    │    PAGE     │    │    PAGE     │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                           │                   │                   │
                           ▼                   ▼                   ▼
                   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
                   │   PROFILE   │    │   RANDOMIZE │    │   COMPLETE  │
                   │    PAGE     │    │    PAGE     │    │    PAGE     │
                   └─────────────┘    └─────────────┘    └─────────────┘
```

### **3. FEATURE MODULES**

#### **A. TYPING SESSION FEATURE**
```
┌─────────────────────────────────────────────────────────────┐
│                TYPING SESSION FEATURE                       │
├─────────────────────────────────────────────────────────────┤
│  📄 Pages:                                                  │
│  ├─ PracticePage (Main Editor)                             │
│  ├─ PracticeEditorPage (Text Input)                        │
│  ├─ PracticeCompletePage (Results)                         │
│  ├─ PracticeRandomizePage (New Content)                    │
│  └─ PracticeStopPage (Pause)                               │
│                                                             │
│  🎛️ Controllers:                                           │
│  ├─ PracticeConfigProvider (Settings)                      │
│  ├─ TextContentController (Content Management)             │
│  └─ GamificationController (XP/Levels)                     │
│                                                             │
│  🧩 Widgets:                                                │
│  ├─ MainMetricsBar (WPM/Accuracy/Time)                     │
│  ├─ TypingProgress (Progress Bar)                          │
│  ├─ AnimatedContentBoard (Text Display)                    │
│  └─ LevelXPIndicator (Gamification)                        │
└─────────────────────────────────────────────────────────────┘
```

#### **B. AUTHENTICATION FEATURE**
```
┌─────────────────────────────────────────────────────────────┐
│                AUTHENTICATION FEATURE                       │
├─────────────────────────────────────────────────────────────┤
│  📄 Pages:                                                  │
│  ├─ LoginPage                                               │
│  └─ SignupPage                                              │
│                                                             │
│  🔐 Services:                                               │
│  ├─ AuthService (Firebase Auth)                            │
│  └─ AuthProvider (Riverpod State)                          │
│                                                             │
│  🔗 Integration:                                            │
│  └─ Firebase Authentication                                 │
└─────────────────────────────────────────────────────────────┘
```

#### **C. USER PROFILE FEATURE**
```
┌─────────────────────────────────────────────────────────────┐
│                 USER PROFILE FEATURE                        │
├─────────────────────────────────────────────────────────────┤
│  📄 Pages:                                                  │
│  └─ ProfilePage (User Stats & Settings)                    │
│                                                             │
│  📊 Data:                                                   │
│  ├─ User Statistics                                         │
│  ├─ Level & XP Progress                                     │
│  └─ Practice History                                        │
└─────────────────────────────────────────────────────────────┘
```

### **4. DATA LAYER ARCHITECTURE**

#### **A. DATA SOURCES**
```
┌─────────────────────────────────────────────────────────────┐
│                      DATA SOURCES                           │
├─────────────────────────────────────────────────────────────┤
│  🌐 Remote Sources:                                         │
│  ├─ ContentApiSource (Text Generation)                     │
│  └─ GamificationApiSource (Levels/XP)                      │
│                                                             │
│  💾 Local Sources:                                          │
│  ├─ GamificationLocalSource (JSON Assets)                  │
│  ├─ SharedPreferences (Settings Cache)                     │
│  └─ SQLite Database (Sessions & XP)                        │
│                                                             │
│  📊 Database Tables:                                        │
│  ├─ typing_sessions (id, mode, difficulty, stats)          │
│  └─ xp_entries (id, timestamp, amount, synced)             │
└─────────────────────────────────────────────────────────────┘
```

#### **B. REPOSITORIES**
```
┌─────────────────────────────────────────────────────────────┐
│                     REPOSITORIES                            │
├─────────────────────────────────────────────────────────────┤
│  🏪 GamificationRepository:                                 │
│  ├─ getGamificationData()                                   │
│  └─ preloadGamificationData()                               │
│                                                             │
│  📝 ContentRepository:                                      │
│  ├─ fetchTextContent()                                      │
│  ├─ preloadInitialTexts()                                   │
│  └─ randomizedTexts()                                       │
│                                                             │
│  💾 Cache Layer:                                            │
│  ├─ GamificationCache (SharedPrefs)                        │
│  └─ ContentCache (Local Storage)                           │
└─────────────────────────────────────────────────────────────┘
```

### **5. DOMAIN LAYER**

#### **A. ENTITIES**
```
┌─────────────────────────────────────────────────────────────┐
│                       ENTITIES                              │
├─────────────────────────────────────────────────────────────┤
│  🎮 GamificationEntity:                                     │
│  ├─ difficultyCriteria: List<DifficultyCriteriaEntity>     │
│  └─ levels: List<LevelEntity>                               │
│                                                             │
│  📝 TextContentEntity:                                      │
│  ├─ id: String                                              │
│  ├─ content: String                                         │
│  ├─ difficulty: DifficultyEnum                              │
│  └─ wordCount: int                                          │
│                                                             │
│  ⚙️ PracticeConfigEntity:                                   │
│  ├─ difficulty: DifficultyEnum                              │
│  ├─ mode: ExpertiseModeEnum                                 │
│  ├─ settings: Various boolean flags                         │
│  └─ multipliers: XP & Difficulty multipliers               │
└─────────────────────────────────────────────────────────────┘
```

#### **B. ENUMS & CONSTANTS**
```
┌─────────────────────────────────────────────────────────────┐
│                    ENUMS & CONSTANTS                        │
├─────────────────────────────────────────────────────────────┤
│  🎯 DifficultyEnum: easy, medium, hard                      │
│  🎮 PracticeStatusEnum: start, pause, stop, complete        │
│  📊 XpMultiplier: easy(150), medium(250), hard(400)         │
│  🔢 DifficultyMultiplier: easy(1.0), medium(1.2), hard(1.5) │
│  📏 TextSizeEnum: XS, S, M, L, XL                          │
│  ⏱️ TextLengthEnum: short, medium, long                     │
└─────────────────────────────────────────────────────────────┘
```

### **6. STATE MANAGEMENT (RIVERPOD)**

#### **A. PROVIDER HIERARCHY**
```
┌─────────────────────────────────────────────────────────────┐
│                   RIVERPOD PROVIDERS                        │
├─────────────────────────────────────────────────────────────┤
│  🏗️ Core Providers:                                         │
│  ├─ sharedPrefsServiceProvider                              │
│  ├─ databaseProvider                                        │
│  ├─ themeProvider                                           │
│  └─ navigationProvider                                      │
│                                                             │
│  🎮 Feature Providers:                                      │
│  ├─ practiceConfigurationProvider                           │
│  ├─ textContentControllerProvider                           │
│  ├─ gamificationContentControllerProvider                   │
│  └─ authServiceProvider                                     │
│                                                             │
│  🔄 State Flow:                                             │
│  User Action → Provider Update → UI Rebuild                 │
└─────────────────────────────────────────────────────────────┘
```

### **7. GAMIFICATION SYSTEM FLOW**

#### **A. XP CALCULATION FLOW**
```
┌─────────────────────────────────────────────────────────────┐
│                 GAMIFICATION FLOW                           │
├─────────────────────────────────────────────────────────────┤
│  🎯 User Types Text                                         │
│  ↓                                                          │
│  📊 Session Data Collected (typed, correct, errors, time)   │
│  ↓                                                          │
│  🧮 XP Calculation:                                         │
│  XP = (Correct Chars ÷ 5) × XP Multiplier × Difficulty     │
│  ↓                                                          │
│  💾 Save to Database (xp_entries table)                    │
│  ↓                                                          │
│  📈 Update User Level (compare with level thresholds)      │
│  ↓                                                          │
│  🎉 UI Update (Level Indicator, Progress Bar)              │
└─────────────────────────────────────────────────────────────┘
```

#### **B. DIFFICULTY CRITERIA**
```
┌─────────────────────────────────────────────────────────────┐
│                DIFFICULTY CRITERIA                          │
├─────────────────────────────────────────────────────────────┤
│  🟢 EASY:                                                   │
│  ├─ Accuracy: 90%                                           │
│  ├─ WPM: 50                                                 │
│  ├─ Time Limit: 5 minutes                                   │
│  ├─ XP Multiplier: 150                                      │
│  └─ Difficulty Multiplier: 1.0x                            │
│                                                             │
│  🟡 MEDIUM:                                                 │
│  ├─ Accuracy: 95%                                           │
│  ├─ WPM: 30                                                 │
│  ├─ Time Limit: 4 minutes                                   │
│  ├─ XP Multiplier: 250                                      │
│  └─ Difficulty Multiplier: 1.2x                            │
│                                                             │
│  🔴 HARD:                                                   │
│  ├─ Accuracy: 98%                                           │
│  ├─ WPM: 40                                                 │
│  ├─ Time Limit: 3 minutes                                   │
│  ├─ XP Multiplier: 400                                      │
│  └─ Difficulty Multiplier: 1.5x                            │
└─────────────────────────────────────────────────────────────┘
```

### **8. USER INTERACTION FLOW**

#### **A. PRACTICE SESSION FLOW**
```
┌─────────────────────────────────────────────────────────────┐
│                PRACTICE SESSION FLOW                        │
├─────────────────────────────────────────────────────────────┤
│  1. 🏠 User Opens App                                      │
│  2. 📱 App Loads (Splash → Main Layout)                    │
│  3. 🎯 User Selects Practice Tab                           │
│  4. ⚙️ User Configures Settings (Difficulty, etc.)         │
│  5. 📝 Content Loads (TextContentController)               │
│  6. ▶️ User Starts Typing                                  │
│  7. 📊 Real-time Metrics (WPM, Accuracy, Time)             │
│  8. 🏁 Session Complete                                    │
│  9. 🎮 XP Calculated & Level Updated                       │
│  10. 🎉 Results Displayed                                  │
└─────────────────────────────────────────────────────────────┘
```

### **9. DATA FLOW DIAGRAM**

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    UI       │◄───┤  RIVERPOD   │◄───┤  REPOSITORY │
│  (Widgets)  │    │  PROVIDERS  │    │   LAYER     │
└─────────────┘    └─────────────┘    └─────────────┘
                           │                   │
                           ▼                   ▼
                   ┌─────────────┐    ┌─────────────┐
                   │   DOMAIN    │    │    DATA     │
                   │   LAYER     │    │   SOURCES   │
                   │ (Entities)  │    │ (API/DB)    │
                   └─────────────┘    └─────────────┘
```

### **10. KEY CONNECTIONS & DEPENDENCIES**

#### **A. CORE DEPENDENCIES**
- **Flutter Framework** → Material Design UI
- **Riverpod** → State Management
- **GetX** → Navigation & Routing
- **Firebase** → Authentication
- **SQLite** → Local Database
- **SharedPreferences** → Settings Cache

#### **B. FEATURE DEPENDENCIES**
- **Practice Feature** → Gamification System
- **Content Management** → Difficulty System
- **User Profile** → Practice History
- **Authentication** → User Data

#### **C. DATA FLOW DEPENDENCIES**
- **UI Layer** → Riverpod Providers
- **Providers** → Domain Entities
- **Repositories** → Data Sources
- **Cache Layer** → Local Storage

## 🎨 **EXCALIDRAW IMPLEMENTATION**

To create this diagram in Excalidraw:

1. **Create Main Container**: Large rectangle for the entire app
2. **Add Feature Boxes**: Separate rectangles for each major feature
3. **Draw Connection Lines**: Arrows showing data flow and dependencies
4. **Use Color Coding**:
   - 🟦 Blue: UI/Presentation Layer
   - 🟩 Green: Domain/Business Layer
   - 🟨 Yellow: Data Layer
   - 🟪 Purple: State Management
   - 🟧 Orange: External Services

5. **Add Icons**: Use relevant icons for each component
6. **Group Related Items**: Use containers to group related functionality
7. **Add Flow Arrows**: Show the direction of data and control flow

This comprehensive diagram will help visualize your entire app architecture, making it easier to understand the relationships between different components and plan future development.
