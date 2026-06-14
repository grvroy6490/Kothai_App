# Android signing reference

| File | Use |
|------|-----|
| [SHA_FINGERPRINTS.md](SHA_FINGERPRINTS.md) | **Main guide** — debug vs client APK vs Play Store |
| [sha_fingerprints.json](sha_fingerprints.json) | Copy-paste into Firebase / team records |
| [print-sha.bat](print-sha.bat) / [print-sha.sh](print-sha.sh) | Re-run Gradle `signingReport` for app module |

**Play Store SHA:** [Play app signing](https://play.google.com/console/developers/app/keymanagement) (select Visai) or **Test and release → Setup → App signing** → copy **App signing key certificate** SHA-1/256. The App integrity Services row is often not clickable.

After updating Play Store SHAs, edit `playStoreAppSigning` in `sha_fingerprints.json` and `lib/core/constants/android_signing_fingerprints.dart`.
