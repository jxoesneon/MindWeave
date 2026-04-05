# GitHub Secrets Setup Guide for MindWeave

This guide explains how to configure GitHub secrets for secure CI/CD builds.

## Required GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions → New repository secret

Add the following secrets:

### Supabase (Required)
- `SUPABASE_URL` - Your Supabase project URL (e.g., `https://your-project.supabase.co`)
- `SUPABASE_ANON_KEY` - Your Supabase anonymous key

### hCaptcha (Required for anonymous auth)
- `HCAPTCHA_SITE_KEY` - Your hCaptcha site key from https://dashboard.hcaptcha.com

### Google Sign-In (Required for Google auth)
- `GOOGLE_WEB_CLIENT_ID` - Web client ID from Google Cloud Console
- `GOOGLE_IOS_CLIENT_ID` - iOS/macOS client ID from Google Cloud Console

### Feature Flags (Optional)
- `ENABLE_CAPTCHA` - Set to `true` or `false` (default: `true`)
- `ENABLE_GOOGLE_SIGNIN` - Set to `true` or `false` (default: `true`)

## Local Development Setup

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Fill in your actual values in `.env`:
   ```
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   HCAPTCHA_SITE_KEY=your-hcaptcha-site-key
   GOOGLE_WEB_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
   GOOGLE_IOS_CLIENT_ID=your-ios-client-id.apps.googleusercontent.com
   ```

3. Never commit `.env` to git (it's already in `.gitignore`)

## How It Works

The GitHub Actions workflow (`.github/workflows/build.yml`):
1. Creates a `.env` file from GitHub secrets during the build
2. This file is included in the app bundle via `pubspec.yaml` assets
3. The app loads environment variables at runtime using `flutter_dotenv`
4. `EnvConfig` provides type-safe access to all secrets

## Security Notes

- `.env` files are never committed to the repository (`.gitignore`)
- GitHub secrets are encrypted and only available to authorized workflows
- For production builds, use compile-time environment variables via `--dart-define`
- For local development, use the `.env` file

## Troubleshooting

If builds fail with missing secrets:
1. Check that all required secrets are set in GitHub
2. Verify secret names match exactly (case-sensitive)
3. Ensure the `.env` file is created correctly in the workflow
4. Check that `.env` is listed in `pubspec.yaml` assets
