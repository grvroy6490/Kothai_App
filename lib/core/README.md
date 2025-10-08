

├─ core/                      # Cross-cutting building blocks (no feature knowledge)
│  ├─ config/                 # Env, constants, feature flags
│  ├─ errors/                 # AppException, Failure types
│  ├─ routing/                # GoRouter / routes + typed params
│  ├─ theme/                  # ThemeData, ColorScheme, typography
│  ├─ utils/                  # Pure helpers (formatters, guards, extensions)
│  └─ widgets/                # Tiny reusable UI atoms (ButtonX, Gap, AppIcon)