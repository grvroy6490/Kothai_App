# Push notifications — store & console setup

Visai uses **local notifications** (daily reminder, streak, badges, level-up) and **Firebase Cloud Messaging** (product updates) on Android and iOS.

---

## Android scheduled notifications (required)

`flutter_local_notifications` v16+ requires these in the **app** `AndroidManifest.xml` (already added):

- `RECEIVE_BOOT_COMPLETED`
- `SCHEDULE_EXACT_ALARM` (for reliable daily/streak times)
- `ScheduledNotificationReceiver` + `ScheduledNotificationBootReceiver`

Without the receivers, scheduled reminders are accepted by the plugin but **never fire**.

Quick local check: More → Settings → Debug → **Fire in 1 min**, then background the app.

1. **Firebase Console** → project `visai-97c45`
   - Confirm the Android app `org.dckap.visai` exists and `google-services.json` matches the Play signing + upload keystore SHA-1 / SHA-256 (Project settings → Your apps → Android).
   - Add both **upload** and **Play App Signing** certificate fingerprints if you use Play App Signing.

2. **Cloud Messaging API**
   - Firebase Console → Project settings → Cloud Messaging.
   - Ensure **Firebase Cloud Messaging API (V1)** is enabled (Google Cloud Console → APIs & Services).

3. **Android notification permission (Play policy)**
   - Target SDK 33+: the app already declares `POST_NOTIFICATIONS` and requests it at runtime when the user enables notifications.
   - In Play Console, complete the **Data safety** form: declare that the app collects device IDs / push tokens if you store FCM tokens (we write `fcmTokens` on `users/{uid}`).

4. **Testing before release**
   - Install a release or internal-testing build.
   - Enable **Notifications** + **Product updates** in More → Settings.
   - Firebase Console → Messaging → Create campaign → send a test to the device FCM token (log token in debug) or to topic `announcements`.

5. **Play Console listing**
   - No separate “push” capability toggle is required on Play; ensure privacy policy mentions push/reminders if you collect tokens or send marketing pushes.

---

## Apple App Store / APNs (iOS)

1. **Apple Developer → Certificates, Identifiers & Profiles**
   - App ID `org.dckap.visai` → enable **Push Notifications**.
   - Create an **APNs Auth Key** (.p8) (Keys → + → Apple Push Notifications service), note Key ID and Team ID.
   - Or create legacy APNs certificates (not recommended if you can use .p8).

2. **Firebase Console → Project settings → Cloud Messaging → Apple app configuration**
   - Upload the **APNs Authentication Key** (.p8) with Key ID + Team ID for bundle `org.dckap.visai`.
   - Confirm iOS app exists with matching bundle ID (options already in `firebase_options.dart`).

3. **Xcode (Mac)**
   - Open `ios/Runner.xcworkspace`.
   - Runner target → **Signing & Capabilities** → add **Push Notifications**.
   - Add **Background Modes** → check **Remote notifications** (also set in `Info.plist` as `UIBackgroundModes`).
   - Confirm `Runner/Runner.entitlements` has `aps-environment`:
     - `development` for debug / TestFlight sandbox devices while developing.
     - For **App Store / TestFlight production**, Xcode normally switches to `production` when archiving with a Distribution profile; verify after archive.
   - Run `cd ios && pod install` after pulling `firebase_messaging`.

4. **Optional: `GoogleService-Info.plist`**
   - Download from Firebase and place under `ios/Runner/` if you prefer native plist over Dart `firebase_options.dart` (FlutterFire already configures iOS via Dart).

5. **App Store Connect**
   - No separate push entitlement checkbox beyond enabling Push on the App ID and uploading APNs key to Firebase.
   - Privacy Nutrition Labels: declare data used for app functionality / notifications if applicable.
   - If you send marketing/product updates, disclose that in privacy policy and keep the in-app **Product updates** toggle (already implemented).

6. **Testing**
   - Real device required (simulator has limited push support).
   - Grant notification permission; enable Product updates; send an FCM test from Firebase Console.

---

## Sending a remote “product update”

- Topic subscribed by the app when product updates are on: `announcements`.
- Optional data keys for deep link: `payload` or `route` with values:
  - `practice`
  - `achievement_gallery`
  - `streak_board`
  - `xp_milestones`

Example (Firebase Console → Messaging → topic `announcements`):

- Notification title/body for system tray.
- Custom data: `payload` = `practice`.

---

## Firestore note

Signed-in users store FCM tokens on:

```text
users/{uid}.fcmTokens: string[]
users/{uid}.fcmTokenUpdatedAt
users/{uid}.platform
```

Update **Firestore security rules** so only the signed-in user can write their own `fcmTokens` field (merge into existing `users/{uid}` rules).
