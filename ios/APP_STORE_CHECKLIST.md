# iOS App Store release checklist

Use this before building and submitting to the App Store.

## 1. Version and build number
- [ ] Update `version` in `pubspec.yaml` (e.g. `3.0.1+2` → marketing version + build number).
- [ ] iOS uses `FLUTTER_BUILD_NAME` and `FLUTTER_BUILD_NUMBER` from `flutter build ios` / Xcode.

## 2. Build for release
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ios --release
```
- [ ] Open `ios/Runner.xcworkspace` in Xcode (not `.xcodeproj`).
- [ ] Select **Product → Scheme → Runner** and **Any iOS Device (arm64)**.
- [ ] **Signing & Capabilities**: select your Team, ensure **Automatically manage signing** is on (or set Provisioning Profile for distribution).
- [ ] **Product → Archive**.

## 3. App Store Connect
- [ ] Create/update the app in App Store Connect; bundle ID must match `org.dckap.visai` (see `ios/Runner.xcodeproj/project.pbxproj`).
- [ ] Upload the archive via **Distribute App → App Store Connect → Upload**.
- [ ] Encryption: if asked, you can answer “No” for uses non-exempt encryption (Info.plist already sets `ITSAppUsesNonExemptEncryption` = false).
- [ ] Add screenshots, description, keywords, privacy policy URL, and category.
- [ ] Submit for review.

## 4. Already configured in this project
- **Info.plist**: `ITSAppUsesNonExemptEncryption`, `NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription`, display name “Kothai App”.
- **Podfile**: iOS platform 13.0; Release optimizations (LTO, stripping, Swift `-O`).
- **Xcode Release**: `DEVELOPMENT_TEAM`, bitcode off, optimizations on.

## 5. Optional before submit
- [ ] Test on a real device (release mode).
- [ ] Confirm no debug logs or test-only code in release build.
- [ ] Verify all required device orientations in Info.plist if you change them.
