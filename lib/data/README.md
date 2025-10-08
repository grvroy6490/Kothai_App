

├─ data/                      # I/O layer (does NOT import presentation)
│  ├─ sources/                # Remote/Local sources (http, shared_prefs, db)
│  │  ├─ remote/              # API clients, DTOs, endpoints
│  │  └─ local/               # Cache, Hive/Prefs, files
│  ├─ repositories/           # Concrete repo impls (compose sources)
│  └─ mappers/                # DTO <-> Entity mapping