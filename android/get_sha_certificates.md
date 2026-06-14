# Generate SHA certificates

**Full guide (debug / client / Play Store):** [signing/SHA_FINGERPRINTS.md](signing/SHA_FINGERPRINTS.md)

## Quick command

From project root:

```bash
cd android
./gradlew signingReport
```

Windows:

```cmd
cd android
gradlew.bat signingReport
```

Under **`:app:signingReport`**, read:

- **`Variant: debug`** → register in Firebase for local dev
- **`Variant: release`** → register for client release APK/AAB

Play Store installs need the **App signing key** SHA from Play Console (not from Gradle). See [signing/SHA_FINGERPRINTS.md](signing/SHA_FINGERPRINTS.md#3-play-store-app-signing-end-users-from-play).

## Register in Firebase

1. [Firebase Console](https://console.firebase.google.com/) → project **visai-97c45**
2. Project settings → Android app **org.dckap.visai**
3. **SHA certificate fingerprints** → Add fingerprint (SHA-1 and SHA-256 for each profile)
