# Fix iOS Release Build Signing Errors

Your project is set to use **team `VJ9835AFHW`** and **bundle ID `org.dckap.visai`**. The build fails because Xcode has no Apple account or no provisioning profile for that bundle ID.

## Step 1: Add your Apple ID in Xcode

1. Open **Xcode** (not VS Code).
2. Menu: **Xcode → Settings…** (or **Preferences…** on older Xcode).
3. Go to the **Accounts** tab.
4. Click **+** (bottom left) → **Apple ID** → sign in with the Apple ID that has access to team **VJ9835AFHW** (or your own Apple Developer account).
5. After signing in, select the account and ensure the correct **Team** is listed (e.g. **VJ9835AFHW** or your team name). If you don’t see a team, that Apple ID may not be in the Apple Developer Program or wasn’t invited to that team.

## Step 2: Open the iOS project in Xcode and set signing

1. In Terminal (from the project root):
   ```bash
   open ios/Runner.xcworkspace
   ```
2. In Xcode:
   - Select the **Runner** project (blue icon) in the left sidebar.
   - Select the **Runner** target (under TARGETS).
   - Open the **Signing & Capabilities** tab.
3. Ensure **Automatically manage signing** is checked.
4. Under **Team**, choose the team that matches **VJ9835AFHW** (or your team).  
   - If the list says “No accounts” or “Add an account”, go back to Step 1.
   - If your team is a **personal/free** Apple ID, the bundle ID must be **unique** and may need to be changed (e.g. to something like `org.dckap.visai.dev` or with your own prefix).
5. If Xcode shows **“Failed to create provisioning profile”** or **“No profiles for org.dckap.visai”**:
   - **Paid Apple Developer Program:** In [developer.apple.com](https://developer.apple.com/account) → **Certificates, Identifiers & Profiles** → **Identifiers**, add an App ID with bundle ID **org.dckap.visai** (or change the project’s bundle ID in Xcode to one you already created).
   - **Free Apple ID:** Use a bundle ID that’s unique to you (e.g. `com.yourname.visai`). Change it in Xcode under **Signing & Capabilities** (and update **Bundle Identifier** in the **General** tab if needed). Note: with a free account you can’t use some capabilities (e.g. Push) and the app may need to be re-installed when the profile expires.

## Step 3: Build again

From the project root:

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ios --release
```

Or in Xcode: **Product → Build** (⌘B). To run on a device: choose your device and click Run.

## Summary

| Error | What to do |
|-------|------------|
| **No Accounts** | Add your Apple ID in **Xcode → Settings → Accounts**. |
| **No profiles for 'org.dckap.visai'** | Sign in with an account that has team **VJ9835AFHW** and ensure an App ID (and profile) exists for **org.dckap.visai**, or change the bundle ID to one your account can use. |

The project already has **CODE_SIGN_STYLE = Automatic** and **DEVELOPMENT_TEAM = VJ9835AFHW** for Release; once the correct account is added and the team/profile are valid, signing should succeed.
