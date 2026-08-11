# Visai Typing App - Complete Relational & Sequence Diagrams

## 1. RELATIONAL DIAGRAM (Entity Relationship)

```mermaid
erDiagram
    %% Core Entities
    GamificationEntity {
        List<DifficultyCriteriaEntity> difficultyCriteria
        List<LevelEntity> levels
    }
    
    DifficultyCriteriaEntity {
        String type
        int accuracy
        int wpm
        String timelimit
        double xpMultiplier
        double difficultyMultiplier
    }
    
    LevelEntity {
        String level
        int totalXp
    }
    
    TextContentEntity {
        String id
        String content
        DifficultyEnum difficulty
        int wordCount
    }
    
    PracticeConfigEntity {
        ExpertiseModeEnum mode
        DifficultyEnum difficulty
        TextLengthEnum contentLength
        TextSizeEnum contentFontSize
        bool blindMode
        bool randomize
        bool wpmEnabled
        bool accuracyEnabled
        bool timerEnabled
        bool errorsEnabled
        bool allowPauses
        bool allowTakeBacks
        bool soundEnabled
        bool soundOnError
        bool hapticEnabled
        bool hapticOnError
        bool darkMode
    }
    
    TypingSessionEntity {
        String sessionId
        String paragraphId
        int cursor
        int typed
        int correct
        int errors
        Duration elapsed
        bool isRunning
    }
    
    XPEntryEntity {
        String id
        int timestamp
        String mode
        int amount
        bool synced
        String sessionId
    }
    
    UserProfileEntity {
        String userId
        String email
        int totalXP
        int currentLevel
        String displayName
        DateTime lastActive
    }
    
    %% Enums
    DifficultyEnum {
        easy
        medium
        hard
    }
    
    PracticeStatusEnum {
        start
        pause
        stop
        resume
        showStop
        showReset
        complete
    }
    
    XpMultiplier {
        easy: 150
        medium: 250
        hard: 400
    }
    
    DifficultyMultiplier {
        easy: 1.0
        medium: 1.2
        hard: 1.5
    }
    
    %% Relationships
    GamificationEntity ||--o{ DifficultyCriteriaEntity : contains
    GamificationEntity ||--o{ LevelEntity : contains
    DifficultyCriteriaEntity ||--|| DifficultyEnum : maps_to
    PracticeConfigEntity ||--|| DifficultyEnum : uses
    PracticeConfigEntity ||--|| XpMultiplier : uses
    PracticeConfigEntity ||--|| DifficultyMultiplier : uses
    TypingSessionEntity ||--|| TextContentEntity : references
    TypingSessionEntity ||--|| PracticeConfigEntity : uses
    TypingSessionEntity ||--o{ XPEntryEntity : generates
    UserProfileEntity ||--o{ TypingSessionEntity : has
    UserProfileEntity ||--|| LevelEntity : current_level
    XPEntryEntity ||--|| DifficultyEnum : based_on
```

## 2. CLASS RELATIONSHIP DIAGRAM

```mermaid
classDiagram
    %% Presentation Layer
    class PracticePage {
        +TextEditingController controller
        +FocusNode focusNode
        +GamificationEntity gamificationData
        +build() Widget
    }
    
    class PracticeEditorPage {
        +TextEditingController controller
        +FocusNode focusNode
        +GamificationEntity gamificationData
        +build() Widget
    }
    
    class MainMetricsBar {
        +String paragraph
        +DifficultyCriteriaEntity difficulty
        +build() Widget
    }
    
    class BottomNavigationBarWidget {
        +build() Widget
    }
    
    %% Controllers/Providers
    class PracticeConfigController {
        +PracticeConfig state
        +setDifficulty(DifficultyEnum)
        +toggleWpm()
        +toggleAccuracy()
        +toggleTimer()
    }
    
    class TextContentController {
        +TextContent? state
        +build() TextContent?
    }
    
    class GamificationController {
        +GamificationEntity? state
        +build() GamificationEntity?
    }
    
    class SelectNavNotifier {
        +int state
        +set(int index)
        +routeFor(int index) String
    }
    
    %% Domain Entities
    class GamificationEntity {
        +List~DifficultyCriteriaEntity~ difficultyCriteria
        +List~LevelEntity~ levels
        +fromJson(Map) GamificationEntity
        +toJson() Map
    }
    
    class DifficultyCriteriaEntity {
        +String type
        +int accuracy
        +int wpm
        +String timelimit
        +double xpMultiplier
        +double difficultyMultiplier
    }
    
    class TextContentEntity {
        +String id
        +String content
        +DifficultyEnum difficulty
        +int wordCount
    }
    
    class PracticeConfigEntity {
        +ExpertiseModeEnum mode
        +DifficultyEnum difficulty
        +bool wpmEnabled
        +bool accuracyEnabled
        +bool timerEnabled
        +copyWith() PracticeConfigEntity
    }
    
    %% Data Sources
    class GamificationLocalSourceFetcher {
        +fetch() Future~GamificationEntity?~
    }
    
    class GamificationRepoImpl {
        +GamificationDataFetcher fetcher
        +GamificationCache cache
        +getGamificationData() Future~GamificationEntity?~
        +preloadGamificationData() Future~void~
    }
    
    class GamificationCache {
        +SharedPrefsService prefs
        +write(GamificationEntity) Future~void~
        +read() Future~GamificationEntity?~
    }
    
    class AppDatabase {
        +open() Future~Database~
        +typing_sessions table
        +xp_entries table
    }
    
    %% Services
    class AuthService {
        +FirebaseAuth auth
        +FirebaseFirestore db
        +signIn(String email, String password)
        +signUp(String email, String password)
    }
    
    class SharedPrefsService {
        +setString(String key, String value)
        +getString(String key) String?
        +remove(String key)
    }
    
    %% Relationships
    PracticePage --> PracticeEditorPage : contains
    PracticePage --> MainMetricsBar : uses
    PracticePage --> BottomNavigationBarWidget : uses
    PracticeEditorPage --> MainMetricsBar : uses
    
    PracticePage --> PracticeConfigController : watches
    PracticePage --> TextContentController : watches
    PracticePage --> GamificationController : watches
    
    PracticeConfigController --> PracticeConfigEntity : manages
    TextContentController --> TextContentEntity : manages
    GamificationController --> GamificationEntity : manages
    
    GamificationEntity --> DifficultyCriteriaEntity : contains
    GamificationEntity --> LevelEntity : contains
    
    GamificationRepoImpl --> GamificationLocalSourceFetcher : uses
    GamificationRepoImpl --> GamificationCache : uses
    GamificationCache --> SharedPrefsService : uses
    
    AppDatabase --> TypingSessionEntity : stores
    AppDatabase --> XPEntryEntity : stores
```

## 3. SEQUENCE DIAGRAMS

### 3.1 App Initialization Sequence

```mermaid
sequenceDiagram
    participant User
    participant App
    participant SplashPage
    participant AppInitializer
    participant GamificationController
    participant TextContentController
    participant PracticeConfigController
    participant Database
    participant SharedPrefs
    
    User->>App: Launch App
    App->>SplashPage: Show Splash
    SplashPage->>AppInitializer: Initialize Services
    AppInitializer->>Database: Open Database
    AppInitializer->>SharedPrefs: Load Settings
    AppInitializer->>GamificationController: Preload Gamification Data
    GamificationController->>Database: Load from Cache
    AppInitializer->>TextContentController: Preload Content
    TextContentController->>Database: Load Content
    AppInitializer->>PracticeConfigController: Load Practice Settings
    PracticeConfigController->>SharedPrefs: Load Config
    AppInitializer-->>SplashPage: Initialization Complete
    SplashPage->>App: Navigate to Main Layout
    App->>User: Show Main Interface
```

### 3.2 Practice Session Start Sequence

```mermaid
sequenceDiagram
    participant User
    participant PracticePage
    participant PracticeEditorPage
    participant PracticeConfigController
    participant TextContentController
    participant GamificationController
    participant MainMetricsBar
    participant Database
    
    User->>PracticePage: Open Practice Tab
    PracticePage->>PracticeConfigController: Watch Practice Config
    PracticePage->>TextContentController: Watch Text Content
    PracticePage->>GamificationController: Watch Gamification Data
    PracticeConfigController->>Database: Load Practice Settings
    TextContentController->>Database: Load Text Content
    GamificationController->>Database: Load Gamification Data
    PracticePage->>PracticeEditorPage: Create Editor with Data
    PracticeEditorPage->>MainMetricsBar: Display Metrics
    MainMetricsBar->>PracticeConfigController: Get Difficulty Criteria
    MainMetricsBar->>TextContentController: Get Text Content
    MainMetricsBar-->>User: Show Word Count & Average Time
    PracticeEditorPage-->>User: Show Practice Interface
```

### 3.3 Typing Session Progress Sequence

```mermaid
sequenceDiagram
    participant User
    participant PracticeEditorPage
    participant TextEditingController
    participant MainMetricsBar
    participant PracticeConfigController
    participant TextContentController
    participant Database
    
    User->>PracticeEditorPage: Start Typing
    PracticeEditorPage->>TextEditingController: Listen to Text Changes
    User->>TextEditingController: Type Character
    TextEditingController->>PracticeEditorPage: Text Changed
    PracticeEditorPage->>MainMetricsBar: Update Metrics
    MainMetricsBar->>PracticeConfigController: Get Current Settings
    MainMetricsBar->>TextContentController: Get Text Content
    MainMetricsBar-->>User: Update WPM/Accuracy/Time
    PracticeEditorPage->>Database: Track Session Progress
    Database-->>PracticeEditorPage: Session Updated
    PracticeEditorPage-->>User: Show Real-time Progress
```

### 3.4 Practice Session Complete Sequence

```mermaid
sequenceDiagram
    participant User
    participant PracticeEditorPage
    participant PracticeCompletePage
    participant GamificationController
    participant XPCalculation
    participant Database
    participant LevelSystem
    participant MainMetricsBar
    
    User->>PracticeEditorPage: Complete Typing
    PracticeEditorPage->>Database: Save Session Data
    Database-->>PracticeEditorPage: Session Saved
    PracticeEditorPage->>PracticeCompletePage: Navigate to Complete
    PracticeCompletePage->>GamificationController: Get Gamification Data
    GamificationController->>Database: Load Gamification Rules
    PracticeCompletePage->>XPCalculation: Calculate XP
    XPCalculation->>Database: Get Session Stats
    XPCalculation->>GamificationController: Get Difficulty Multipliers
    XPCalculation->>XPCalculation: Calculate: (Correct Chars ÷ 5) × XP Multiplier × Difficulty Multiplier
    XPCalculation->>Database: Save XP Entry
    XPCalculation->>LevelSystem: Check Level Up
    LevelSystem->>Database: Get Current User Level
    LevelSystem->>Database: Get Level Thresholds
    LevelSystem->>Database: Update User Level
    LevelSystem-->>PracticeCompletePage: Level Up Notification
    PracticeCompletePage-->>User: Show Results & XP Earned
    PracticeCompletePage->>MainMetricsBar: Update Level Indicator
    MainMetricsBar-->>User: Show Updated Level Progress
```

### 3.5 Settings Change Sequence

```mermaid
sequenceDiagram
    participant User
    participant PracticeSettingsPage
    participant PracticeConfigController
    participant TextContentController
    participant MainMetricsBar
    participant Database
    participant SharedPrefs
    
    User->>PracticeSettingsPage: Open Settings
    PracticeSettingsPage->>PracticeConfigController: Watch Current Config
    PracticeConfigController->>SharedPrefs: Load Settings
    PracticeConfigController-->>PracticeSettingsPage: Current Settings
    PracticeSettingsPage-->>User: Show Settings UI
    
    User->>PracticeSettingsPage: Change Difficulty
    PracticeSettingsPage->>PracticeConfigController: setDifficulty()
    PracticeConfigController->>SharedPrefs: Save New Settings
    PracticeConfigController->>TextContentController: Invalidate Content
    TextContentController->>Database: Load New Content
    TextContentController-->>MainMetricsBar: Content Updated
    MainMetricsBar->>PracticeConfigController: Get New Difficulty Criteria
    MainMetricsBar-->>User: Show Toast & Updated Metrics
    
    User->>PracticeSettingsPage: Toggle WPM Setting
    PracticeSettingsPage->>PracticeConfigController: toggleWpm()
    PracticeConfigController->>SharedPrefs: Save Setting
    PracticeConfigController-->>MainMetricsBar: Setting Updated
    MainMetricsBar-->>User: Update UI (No Toast)
```

### 3.6 Randomize Content Sequence

```mermaid
sequenceDiagram
    participant User
    participant PracticeRandomizePage
    participant TextContentController
    participant ContentRepository
    participant Database
    participant MainMetricsBar
    participant PracticeEditorPage
    
    User->>PracticeRandomizePage: Click Randomize Button
    PracticeRandomizePage->>TextContentController: Invalidate Content
    TextContentController->>ContentRepository: Get Randomized Content
    ContentRepository->>Database: Fetch New Content
    Database-->>ContentRepository: New Content
    ContentRepository-->>TextContentController: Content Updated
    TextContentController-->>MainMetricsBar: Content Changed
    MainMetricsBar->>TextContentController: Get New Content
    MainMetricsBar-->>User: Show Toast "New text ready"
    PracticeRandomizePage->>PracticeEditorPage: Navigate Back
    PracticeEditorPage->>MainMetricsBar: Display New Content
    MainMetricsBar-->>User: Show Updated Word Count & Time
```

## 4. DATA FLOW DIAGRAM

```mermaid
flowchart TD
    %% User Interactions
    User[👤 User] --> UI[📱 UI Layer]
    
    %% UI Layer
    UI --> PracticePage[Practice Page]
    UI --> SettingsPage[Settings Page]
    UI --> ProfilePage[Profile Page]
    
    %% Controllers
    PracticePage --> PracticeConfigController[Practice Config Controller]
    PracticePage --> TextContentController[Text Content Controller]
    PracticePage --> GamificationController[Gamification Controller]
    
    SettingsPage --> PracticeConfigController
    ProfilePage --> GamificationController
    
    %% Domain Layer
    PracticeConfigController --> PracticeConfig[Practice Config Entity]
    TextContentController --> TextContent[Text Content Entity]
    GamificationController --> Gamification[Gamification Entity]
    
    %% Repository Layer
    PracticeConfigController --> PracticeRepo[Practice Repository]
    TextContentController --> ContentRepo[Content Repository]
    GamificationController --> GamificationRepo[Gamification Repository]
    
    %% Data Sources
    PracticeRepo --> SharedPrefs[Shared Preferences]
    ContentRepo --> Database[(SQLite Database)]
    GamificationRepo --> LocalSource[Local JSON Source]
    GamificationRepo --> Cache[Gamification Cache]
    
    %% External Services
    Cache --> SharedPrefs
    Database --> TypingSessions[(Typing Sessions Table)]
    Database --> XPEntries[(XP Entries Table)]
    
    %% Data Flow Back
    SharedPrefs --> PracticeConfigController
    Database --> TextContentController
    Cache --> GamificationController
    
    %% UI Updates
    PracticeConfigController --> MainMetricsBar[Main Metrics Bar]
    TextContentController --> MainMetricsBar
    GamificationController --> LevelIndicator[Level XP Indicator]
    
    MainMetricsBar --> UI
    LevelIndicator --> UI
    
    %% Styling
    classDef userClass fill:#e1f5fe
    classDef uiClass fill:#f3e5f5
    classDef controllerClass fill:#fff3e0
    classDef entityClass fill:#e8f5e8
    classDef repoClass fill:#fce4ec
    classDef dataClass fill:#fff8e1
    
    class User userClass
    class UI,PracticePage,SettingsPage,ProfilePage uiClass
    class PracticeConfigController,TextContentController,GamificationController controllerClass
    class PracticeConfig,TextContent,Gamification entityClass
    class PracticeRepo,ContentRepo,GamificationRepo repoClass
    class SharedPrefs,Database,LocalSource,Cache,TypingSessions,XPEntries dataClass
```

## 5. COMPONENT INTERACTION DIAGRAM

```mermaid
graph TB
    %% Main App Components
    subgraph "App Layer"
        App[App]
        SplashPage[Splash Page]
        MainLayout[Main Layout]
    end
    
    subgraph "Feature Modules"
        subgraph "Practice Feature"
            PracticePage[Practice Page]
            PracticeEditor[Practice Editor]
            PracticeSettings[Practice Settings]
            PracticeComplete[Practice Complete]
            PracticeRandomize[Practice Randomize]
        end
        
        subgraph "Authentication Feature"
            LoginPage[Login Page]
            SignupPage[Signup Page]
            AuthService[Auth Service]
        end
        
        subgraph "Profile Feature"
            ProfilePage[Profile Page]
            UserStats[User Statistics]
        end
    end
    
    subgraph "State Management"
        subgraph "Riverpod Providers"
            PracticeConfigProvider[Practice Config Provider]
            TextContentProvider[Text Content Provider]
            GamificationProvider[Gamification Provider]
            NavigationProvider[Navigation Provider]
            ThemeProvider[Theme Provider]
        end
    end
    
    subgraph "Domain Layer"
        subgraph "Entities"
            PracticeConfig[Practice Config]
            TextContent[Text Content]
            Gamification[Gamification]
            DifficultyCriteria[Difficulty Criteria]
            Level[Level Entity]
        end
        
        subgraph "Enums"
            DifficultyEnum[Difficulty Enum]
            PracticeStatus[Practice Status]
            XpMultiplier[XP Multiplier]
        end
    end
    
    subgraph "Data Layer"
        subgraph "Repositories"
            PracticeRepo[Practice Repository]
            ContentRepo[Content Repository]
            GamificationRepo[Gamification Repository]
        end
        
        subgraph "Data Sources"
            Database[(SQLite Database)]
            SharedPrefs[Shared Preferences]
            LocalJSON[Local JSON Assets]
        end
    end
    
    %% Connections
    App --> SplashPage
    SplashPage --> MainLayout
    MainLayout --> PracticePage
    MainLayout --> ProfilePage
    
    PracticePage --> PracticeEditor
    PracticePage --> PracticeSettings
    PracticePage --> PracticeComplete
    PracticePage --> PracticeRandomize
    
    PracticePage --> PracticeConfigProvider
    PracticePage --> TextContentProvider
    PracticePage --> GamificationProvider
    
    PracticeConfigProvider --> PracticeConfig
    TextContentProvider --> TextContent
    GamificationProvider --> Gamification
    
    PracticeConfig --> DifficultyEnum
    Gamification --> DifficultyCriteria
    Gamification --> Level
    
    PracticeConfigProvider --> PracticeRepo
    TextContentProvider --> ContentRepo
    GamificationProvider --> GamificationRepo
    
    PracticeRepo --> SharedPrefs
    ContentRepo --> Database
    GamificationRepo --> LocalJSON
    GamificationRepo --> SharedPrefs
    
    %% Styling
    classDef appClass fill:#e3f2fd
    classDef featureClass fill:#f1f8e9
    classDef stateClass fill:#fff3e0
    classDef domainClass fill:#fce4ec
    classDef dataClass fill:#f3e5f5
    
    class App,SplashPage,MainLayout appClass
    class PracticePage,PracticeEditor,PracticeSettings,PracticeComplete,PracticeRandomize,LoginPage,SignupPage,AuthService,ProfilePage,UserStats featureClass
    class PracticeConfigProvider,TextContentProvider,GamificationProvider,NavigationProvider,ThemeProvider stateClass
    class PracticeConfig,TextContent,Gamification,DifficultyCriteria,Level,DifficultyEnum,PracticeStatus,XpMultiplier domainClass
    class PracticeRepo,ContentRepo,GamificationRepo,Database,SharedPrefs,LocalJSON dataClass
```

## 6. KEY RELATIONSHIPS SUMMARY

### **Core Relationships:**
1. **PracticePage** → **PracticeEditorPage** → **MainMetricsBar**
2. **PracticeConfigController** → **PracticeConfigEntity** → **SharedPreferences**
3. **TextContentController** → **TextContentEntity** → **Database**
4. **GamificationController** → **GamificationEntity** → **Local JSON + Cache**
5. **XP Calculation** → **Session Data** → **Level System** → **UI Update**

### **Data Flow Patterns:**
1. **User Action** → **Controller** → **Repository** → **Data Source** → **Entity** → **UI Update**
2. **Settings Change** → **Provider Update** → **Cache Save** → **UI Refresh**
3. **Session Complete** → **XP Calculation** → **Level Check** → **Database Save** → **UI Notification**

### **Dependency Hierarchy:**
1. **UI Layer** depends on **State Management**
2. **State Management** depends on **Domain Layer**
3. **Domain Layer** depends on **Data Layer**
4. **Data Layer** depends on **External Services**

This comprehensive diagram set provides a complete view of your Visai Typing App's architecture, relationships, and interaction flows.
