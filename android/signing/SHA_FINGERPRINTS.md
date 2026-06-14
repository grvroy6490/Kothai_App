# Visai Android SHA fingerprints (Google Sign-In / Firebase)

Register **all** profiles below in Firebase for package **`org.dckap.visai`**.  
If a build type’s SHA is missing, users on that install get **ApiException 10** / the red “add SHA-1” snackbar.

**Firebase:** [Project settings → Android app](https://console.firebase.google.com/project/visai-97c45/settings/general) → **SHA certificate fingerprints** → Add fingerprint (add SHA-1 and SHA-256 for each profile).

**Machine-readable copy:** [`sha_fingerprints.json`](sha_fingerprints.json)  
**Dart reference (same values):** [`lib/core/constants/android_signing_fingerprints.dart`](../../lib/core/constants/android_signing_fingerprints.dart)

---

## Quick reference — which SHA when?

| You are shipping… | Build command | Register this profile in Firebase |
|-------------------|---------------|-----------------------------------|
| Dev / QA on USB, `flutter run` | `flutter run` | **Debug** |
| APK/AAB you email to a client | `flutter build apk --release` or `appbundle` | **Release upload** |
| App on **Google Play** (production / internal test) | Upload AAB to Play Console | **Release upload** + **Play Store app signing** |

> Play Store users install an APK signed by **Google’s app signing key**, not only your upload key. You must add **both** upload and Play app signing SHA fingerprints.

---

## 1. Debug (local development)

**Use for:** `flutter run`, debug APK, profile builds on your machine.

| | Value |
|---|--------|
| Keystore | `~/.android/debug.keystore` |
| Alias | `AndroidDebugKey` |
| **SHA-1** | `2F:A4:F9:53:20:53:7A:6A:C0:EC:D6:03:01:D4:D2:2D:F7:9E:BB:8C` |
| **SHA-256** | `96:1D:7A:C8:6D:FE:F7:BD:39:7F:9F:16:5F:67:35:DA:F1:F6:D4:37:8E:7B:D3:D6:87:A9:43:69:CD:A1:87:D9` |

Firebase paste (SHA-1, no colons): `2fa4f95320537a6ac0ecd60301d4d22df79ebb8c`

---

## 2. Release upload (client APK / AAB you sign)

**Use for:** Release builds signed with `android/upload-keystore.jks` (see `android/key.properties`).

| | Value |
|---|--------|
| Keystore | `android/upload-keystore.jks` |
| Alias | `upload` |
| **SHA-1** | `B7:39:71:9D:26:ED:9C:7F:5C:8D:8A:0A:A3:D6:10:B3:21:92:8C:6D` |
| **SHA-256** | `AC:C2:94:C0:1F:D2:EE:2F:2F:A2:9B:E5:25:B1:E7:2A:CE:93:00:02:E5:90:8F:0B:B0:E1:68:9D:CA:13:0D:C7` |

Firebase paste (SHA-1): `b739719d26ed9c7f5c8d8a0aa3d610b321928c6d`  
This matches the Android OAuth client in `android/app/google-services.json`.

---

## 3. Play Store app signing (end users from Play)

**Use for:** Anyone who installs from Google Play when **App signing** shows **Signing by Google Play** (your screenshot).

The SHA values are **not** on the App integrity **Services** list (the screen that only shows “Signing by Google Play” as a badge). Use one of the paths below — **do not rely on that row being clickable** (Google often shows it as status-only).

### Recommended paths (use any one that works)

**A — Direct link (fastest)**  
1. Open [Google Play Console](https://play.google.com/console) and select app **Visai**.  
2. Open Google’s **Play app signing** page: [play.google.com/console/developers/app/keymanagement](https://play.google.com/console/developers/app/keymanagement)  
   - If prompted, pick the **Visai** app.  
   - You should see **App signing key certificate** and **Upload key certificate** with SHA-1 / SHA-256 copy buttons.

**B — Left menu (official path)**  
1. Select **Visai** in Play Console.  
2. Left menu: **Test and release** → **Setup** → **App signing**.  
   - Same page as (A). Older docs say “Release”; the current menu label is **Test and release**.

**C — Search**  
1. With the app selected, use the **search bar** at the top of Play Console.  
2. Search **App signing** or **key management** and open the **App signing** / **Play app signing** result.

**D — App integrity (only if A–C fail)**  
1. **Test and release** → **App integrity** (overview).  
2. Scroll **below** the Services list — some accounts show certificate fingerprints on the overview.  
3. If not, use (A) or (B); the **App signing** row on Services is often **not** a link.

### Copy fingerprints into Firebase

On the **App signing** page (from A/B/C), find:

- **App signing key certificate** ← **required for Play installs**
- **Upload key certificate** ← same as [Release upload](#2-release-upload-client-apk--aab-you-sign) if you use `upload-keystore.jks`

Use **copy** next to **SHA-1 certificate fingerprint** and **SHA-256 certificate fingerprint** for each.

1. Paste **App signing key** SHA-1/256 into [`sha_fingerprints.json`](sha_fingerprints.json) → `playStoreAppSigning`.
2. In [Firebase](https://console.firebase.google.com/project/visai-97c45/settings/general) → Android app **org.dckap.visai** → **SHA certificate fingerprints** → **Add fingerprint** for **both** Play SHAs (and upload key SHAs if missing).

### Troubleshooting

| Situation | What to do |
|-----------|------------|
| **“App signing” row on Services is not clickable** | Normal on many accounts. Use **(A)** direct link or **(B)** **Test and release → Setup → App signing**. |
| Direct link opens wrong app / 404 | Select **Visai** on the app dashboard first, then open the link again. |
| Page exists but **no certificates** | Upload at least one **AAB** to Internal testing (or higher); Google creates keys after the first signed release. |
| **App signing** / **Setup** missing in menu | Account needs **Admin** or **Release manager**, and permission **Release to production, exclude devices, and use Play app signing** ([Play help](https://support.google.com/googleplay/android-developer/answer/9842756)). Ask the account owner. |
| Only **view** access | You cannot see signing keys; ask owner to copy SHA-1/256 or add them in Firebase. |
| Using phone browser | Use **desktop** Chrome/Edge; mobile Play Console often hides setup pages. |
| Play users still fail Sign-In after upload SHA only | You added **upload** key but not **app signing** key — register **App signing key certificate** SHA from (A). |

### Register in Firebase (both keys when using Play App Signing)

| Certificate in Play Console | Who uses it | Already in this repo? |
|---------------------------|-------------|------------------------|
| **Upload key certificate** | AAB you upload; client APK you sign locally | Yes — [Release upload](#2-release-upload-client-apk--aab-you-sign) |
| **App signing key certificate** | Users who install from Play Store | **Copy from Play and add to Firebase** |

| | Value |
|---|--------|
| **SHA-1 (App signing key)** | _Paste after step 6 above_ |
| **SHA-256 (App signing key)** | _Paste after step 6 above_ |

Until **App signing key** SHA is in Firebase, **Play Store users can fail Google Sign-In** even if a sideloaded release APK works.

---

## Refresh fingerprints after keystore change

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

Look for **`Variant: debug`** and **`Variant: release`** under `:app:signingReport`, then update this file and `sha_fingerprints.json`.

---

## After adding fingerprints in Firebase

1. Wait a few minutes for Google OAuth to propagate.
2. Download fresh **`google-services.json`** (Project settings → Android app).
3. Replace `android/app/google-services.json`.
4. Rebuild and reinstall the app (uninstall old APK if testing).

```bash
flutter clean
flutter pub get
flutter build apk --release   # or appbundle for Play
```

---

## Firebase checklist (copy when setting up a new environment)

- [ ] Debug SHA-1 + SHA-256
- [ ] Release upload SHA-1 + SHA-256
- [ ] Play Store app signing SHA-1 + SHA-256 (after first Play upload)
- [ ] Downloaded updated `google-services.json`
- [ ] Tested Google Sign-In on: debug build, release APK, Play internal track

---

## iOS (no SHA)

Google Sign-In on iOS uses bundle ID `org.dckap.visai` and URL scheme in `ios/Runner/Info.plist`. No SHA registration. See `GOOGLE_SIGNIN_SETUP.md` for iOS client ID.
