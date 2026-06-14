/// Android signing certificate fingerprints for Firebase / Google Sign-In.
///
/// Register **every** profile in Firebase Console (package [packageName]).
/// Source of truth: [android/signing/sha_fingerprints.json] and
/// [android/signing/SHA_FINGERPRINTS.md].
///
/// Not used at runtime for auth — reference for developers and support.
abstract final class AndroidSigningFingerprints {
  static const String packageName = 'org.dckap.visai';

  static const String firebaseProjectId = 'visai-97c45';

  /// Debug — `flutter run`, USB testing (~/.android/debug.keystore).
  static const String debugSha1 =
      '2F:A4:F9:53:20:53:7A:6A:C0:EC:D6:03:01:D4:D2:2D:F7:9E:BB:8C';

  static const String debugSha256 =
      '96:1D:7A:C8:6D:FE:F7:BD:39:7F:9F:16:5F:67:35:DA:F1:F6:D4:37:8E:7B:D3:D6:87:A9:43:69:CD:A1:87:D9';

  /// Release upload — client APK/AAB (`android/upload-keystore.jks`).
  static const String releaseUploadSha1 =
      'B7:39:71:9D:26:ED:9C:7F:5C:8D:8A:0A:A3:D6:10:B3:21:92:8C:6D';

  static const String releaseUploadSha256 =
      'AC:C2:94:C0:1F:D2:EE:2F:2F:A2:9B:E5:25:B1:E7:2A:CE:93:00:02:E5:90:8F:0B:B0:E1:68:9D:CA:13:0D:C7';

  /// Play Store — Play Console → Setup → App signing (or /developers/app/keymanagement).
  /// Update when you enable Play App Signing or rotate keys.
  static const String playStoreAppSigningSha1 = 'PASTE_FROM_PLAY_CONSOLE';

  static const String playStoreAppSigningSha256 = 'PASTE_FROM_PLAY_CONSOLE';

  /// Short message shown when Android returns DEVELOPER_ERROR (SHA mismatch).
  static const String googleSignInShaMismatchHint =
      'Google Sign-In failed: this APK’s signing certificate is not registered '
      'in Firebase. Add the correct SHA-1 for this build type (debug, release '
      'upload, or Play Store app signing). See android/signing/SHA_FINGERPRINTS.md';
}
