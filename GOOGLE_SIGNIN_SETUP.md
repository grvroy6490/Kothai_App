# Google Sign-In Setup Guide

## Issue Fixed
The Google Sign-In configuration has been updated to use the web client ID from `google-services.json`. However, you need to add SHA certificates to Firebase Console for Google Sign-In to work properly.

## SHA Certificates (Debug Build)

Your debug keystore SHA certificates are:

**SHA-1:**
```
2F:A4:F9:53:20:53:7A:6A:C0:EC:D6:03:01:D4:D2:2D:F7:9E:BB:8C
```

**SHA-256:**
```
96:1D:7A:C8:6D:FE:F7:BD:39:7F:9F:16:5F:67:35:DA:F1:F6:D4:37:8E:7B:D3:D6:87:A9:43:69:CD:A1:87:D9
```

## Steps to Add SHA Certificates to Firebase Console

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Select your project: **visai-97c45**

2. **Navigate to Project Settings**
   - Click the gear icon (⚙️) next to "Project Overview"
   - Select **Project Settings**

3. **Go to Your Apps Section**
   - Scroll down to **Your apps** section
   - Find your Android app: **org.dckap.visai**
   - Click on it

4. **Add SHA Certificates**
   - Scroll down to **SHA certificate fingerprints** section
   - Click **Add fingerprint**
   - Paste the SHA-1 certificate: `2F:A4:F9:53:20:53:7A:6A:C0:EC:D6:03:01:D4:D2:2D:F7:9E:BB:8C`
   - Click **Add fingerprint** again
   - Paste the SHA-256 certificate: `96:1D:7A:C8:6D:FE:F7:BD:39:7F:9F:16:5F:67:35:DA:F1:F6:D4:37:8E:7B:D3:D6:87:A9:43:69:CD:A1:87:D9`
   - Click **Save**

5. **Download Updated google-services.json** (Optional)
   - After adding SHA certificates, Firebase may generate a new OAuth client
   - You can download the updated `google-services.json` if needed
   - However, the current configuration should work with the web client ID

## Code Changes Made

### Updated `lib/services/authentication/authentication_service.dart`

The `GoogleSignIn` instance now explicitly uses the web client ID:

```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
  // Use the web client ID from google-services.json for server-side authentication
  serverClientId: '834995515353-o2str0l8rbpfkf0gmnrejjj0eii4883k.apps.googleusercontent.com',
);
```

This ensures that:
- Google Sign-In can authenticate with Firebase Auth
- The ID token is properly validated server-side
- The authentication flow works correctly

## Testing

After adding the SHA certificates:

1. **Clean and rebuild the app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test Google Sign-In:**
   - Open the app
   - Go to Login page
   - Click "Sign in with Google"
   - Select a Google account
   - Verify that sign-in completes successfully

## Troubleshooting

### If Google Sign-In still doesn't work:

1. **Verify SHA certificates are added:**
   - Check Firebase Console > Project Settings > Your apps > Android app
   - Ensure both SHA-1 and SHA-256 are listed

2. **Check package name:**
   - Verify `applicationId` in `android/app/build.gradle.kts` matches Firebase app: `org.dckap.visai`

3. **Verify google-services.json:**
   - Ensure `google-services.json` is in `android/app/` directory
   - Check that `package_name` matches: `org.dckap.visai`

4. **Check for errors in logcat:**
   ```bash
   adb logcat | grep -i "google\|signin\|auth"
   ```

5. **Clear app data and retry:**
   - Uninstall the app
   - Reinstall and try again

## For Release Build

When you create a release build, you'll need to:

1. **Generate release SHA certificates:**
   ```bash
   cd android
   ./gradlew signingReport
   ```
   (Look for the release variant SHA certificates)

2. **Add release SHA certificates to Firebase Console:**
   - Follow the same steps above
   - Add both SHA-1 and SHA-256 for the release keystore

## Additional Notes

- The web client ID (`serverClientId`) is required for Firebase Auth to validate the ID token server-side
- SHA certificates are required for Google Sign-In to work on Android
- Both debug and release SHA certificates should be added if you plan to test both builds
