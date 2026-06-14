# Google Sign-In setup (Visai)

## SHA fingerprints (Android) — start here

**All build types (debug, client release, Play Store) need separate SHA-1/SHA-256 entries in Firebase.**

| Document | Purpose |
|----------|---------|
| **[android/signing/SHA_FINGERPRINTS.md](android/signing/SHA_FINGERPRINTS.md)** | Human guide: which SHA for client APK vs Play Store |
| **[android/signing/sha_fingerprints.json](android/signing/sha_fingerprints.json)** | Copy-paste values + Play Store placeholder |
| **[lib/core/constants/android_signing_fingerprints.dart](lib/core/constants/android_signing_fingerprints.dart)** | Same values in Dart (reference / error hint) |

Refresh after keystore change:

```bash
cd android && ./gradlew signingReport
```

---

## Firebase project

- **Project:** `visai-97c45`
- **Android package:** `org.dckap.visai`
- **Console:** https://console.firebase.google.com/project/visai-97c45/settings/general

### Register in Firebase (all three profiles)

1. **Debug** — local `flutter run` / USB  
   - SHA-1: `2F:A4:F9:53:20:53:7A:6A:C0:EC:D6:03:01:D4:D2:2D:F7:9E:BB:8C`

2. **Release upload** — APK/AAB you sign with `upload-keystore.jks` (share with client)  
   - SHA-1: `B7:39:71:9D:26:ED:9C:7F:5C:8D:8A:0A:A3:D6:10:B3:21:92:8C:6D`

3. **Play Store app signing** — [Play app signing](https://play.google.com/console/developers/app/keymanagement) (select app) or **Test and release → Setup → App signing** → **App signing key certificate**  
   - Paste into `sha_fingerprints.json` and add to Firebase (required for Play installs)

After adding fingerprints: download **`google-services.json`** → `android/app/google-services.json` → rebuild.

---

## Code configuration

`lib/services/authentication/authentication_service.dart`:

- **Android:** `serverClientId` = web client from `google-services.json`
- **iOS:** `clientId` = iOS OAuth client (`834995515353-4vv36b5krrkd219ofnj618m9277bmiva.apps.googleusercontent.com`)
- **iOS URL scheme:** `ios/Runner/Info.plist` → `CFBundleURLSchemes`

---

## Test checklist

- [ ] Google Sign-In on **debug** build (`flutter run`)
- [ ] Google Sign-In on **release APK** sent to client
- [ ] Google Sign-In on **Play internal / production** track
- [ ] Logout → Google Sign-In again (second attempt)

---

## Troubleshooting

| Symptom | Likely cause |
|---------|----------------|
| Red snackbar / SHA-1 message | This APK’s SHA not in Firebase — see [SHA_FINGERPRINTS.md](android/signing/SHA_FINGERPRINTS.md) |
| Works on dev phone, fails for users | Play Store uses different signing key than your upload key |
| `ApiException: 10` | Same as SHA mismatch |

Logcat: `adb logcat | findstr /i "google signin auth"`

See also: [android/get_sha_certificates.md](android/get_sha_certificates.md) (how to run `signingReport`).
