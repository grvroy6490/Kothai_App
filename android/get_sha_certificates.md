# How to Generate SHA Certificates for Google Sign-In

You need SHA-1 and SHA-256 certificates to register in Firebase Console for Google Sign-In to work.

## Method 1: Using Gradle (Easiest - Recommended)

Run this command from the project root:

```bash
cd android
./gradlew signingReport
```

Or on Windows:
```bash
cd android
gradlew.bat signingReport
```

This will show SHA-1 and SHA-256 for both debug and release builds.

## Method 2: Using keytool (Manual)

### For Debug Keystore (Development)

**Windows:**
```bash
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Mac/Linux:**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### For Release Keystore (Production)

If you have a release keystore file:

```bash
keytool -list -v -keystore path/to/your/keystore.jks -alias your-key-alias
```

You'll be prompted for the keystore password.

## Method 3: Using Flutter Command

From the project root:

```bash
flutter build apk --debug
```

Then check the build output or use:
```bash
cd android
./gradlew signingReport
```

## What to Look For

After running any of the above commands, look for output like:

```
Certificate fingerprints:
     SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
     SHA256: 11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00
```

## Register in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (kothai-2425)
3. Go to **Project Settings** (gear icon) > **Your apps**
4. Click on your Android app
5. Scroll down to **SHA certificate fingerprints**
6. Click **Add fingerprint**
7. Paste your SHA-1 and SHA-256 certificates
8. Click **Save**

**Important:** You need to add BOTH:
- Debug SHA-1 and SHA-256 (for development/testing)
- Release SHA-1 and SHA-256 (for production builds)

## Quick Windows Command

If you're on Windows and want a quick copy-paste command:

```cmd
cd android && gradlew.bat signingReport
```

Look for the output section that shows SHA-1 and SHA-256 fingerprints.

