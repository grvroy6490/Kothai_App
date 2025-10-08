

├─ features/                  # Vertical slices; each owns its UI + logic
│  └─ practice/
│     ├─ presentation/        # Widgets, pages, controllers/providers
│     │  ├─ pages/
│     │  ├─ widgets/
│     │  └─ providers/        # Riverpod Notifiers/Providers (UI-facing)
│     ├─ application/         # Feature-specific coordinators (optional)
│     ├─ domain/              # (optional) feature-only entities/usecases
│     └─ data/                # (optional) feature-only repo impls / sources