# Google Sign-In Setup Guide for MindWeave

Since gcloud CLI doesn't have permissions on the project, follow these steps to manually configure Google Sign-In:

## 1. Google Cloud Console Setup

### Enable Google Sign-In API
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select project: `mindweave-app` (or create it if it doesn't exist)
3. Navigate to **APIs & Services > Library**
4. Search for "Google Sign-In" and enable it

### Create OAuth 2.0 Credentials

#### For Android:
1. Go to **APIs & Services > Credentials**
2. Click **Create Credentials > OAuth client ID**
3. Select **Android** as application type
4. Enter package name: `org.mindweave.mindweave`
5. Get SHA-1 fingerprint:
   ```bash
   # For debug builds:
   cd android && ./gradlew signingReport
   
   # Or use keytool:
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
6. Add the SHA-1 fingerprint and create
7. Download the updated `google-services.json`
8. Replace `/android/app/google-services.json` with the new file

#### For iOS/macOS:
1. Create another OAuth client ID
2. Select **iOS** as application type (works for both iOS and macOS)
3. Enter bundle ID (check in Xcode or `ios/Runner.xcodeproj` for iOS, `macos/Runner.xcodeproj` for macOS)
4. Copy the Client ID (format: `XXXXXXXXXX-XXXXXXXXXXXXXXXX.apps.googleusercontent.com`)
5. Add to your `.env` file:
   ```
   GOOGLE_IOS_CLIENT_ID=your-client-id.apps.googleusercontent.com
   ```
6. For iOS: Download `GoogleService-Info.plist` and add to `ios/Runner/`
7. For macOS: The build script will auto-inject the Client ID from `.env` into `Info.plist`

#### For Web (if needed):
1. Create Web OAuth client ID
2. Add authorized redirect URIs from Supabase

## 2. Supabase Auth Configuration

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Select your project
3. Go to **Authentication > Providers**
4. Enable **Google** provider
5. Enter Client ID and Secret from Google Cloud Console
6. Save settings

## 3. Platform-Specific Code Changes

### Android - build.gradle
The `android/app/build.gradle.kts` should already have:
```kotlin
plugins {
    id("com.android.application")
    id("com.google.gms.google-services")  // Add this if not present
    // ... other plugins
}
```

Add to `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### macOS - Auto-injection from .env
The macOS build uses a script (`macos/Runner/inject_env.sh`) that automatically injects `GOOGLE_IOS_CLIENT_ID` from `.env` into `Info.plist` during build.

**No manual changes needed** - just ensure `.env` has:
```
GOOGLE_IOS_CLIENT_ID=your-client-id.apps.googleusercontent.com
```

### iOS - Info.plist
Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Replace `YOUR_CLIENT_ID` with the iOS client ID from Google Cloud Console.

## 4. Testing

After configuration:
1. Clean build: `flutter clean && flutter pub get`
2. Run: `flutter run`
3. Test Google Sign-In button on the login screen

## Troubleshooting

- **Error 10 (DEVELOPER_ERROR)**: SHA-1 fingerprint mismatch. Ensure debug and release fingerprints are both added.
- **User cancelled**: Normal behavior when user dismisses the sign-in dialog
- **Invalid client**: Check that the OAuth client ID matches the package name/bundle ID

## Files Modified

The following files were created/updated for Google Sign-In:
- `/lib/core/auth/google_sign_in_service.dart` - Service class
- `/lib/features/auth/auth_flow_screen.dart` - Integration with login flow
- `/pubspec.yaml` - Added google_sign_in package
