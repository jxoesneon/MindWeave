# MindWeave Screen Implementation Comparison

## Executive Summary

This document compares the **existing implementation** against the **PRD requirements** and expected Stitch prototype. The goal is to identify gaps and plan the wiring-up of the prototype.

---

## Part 1: Flutter Mobile App Screens

### Current Implementation Status

| Screen | File Location | Status | Notes |
|--------|---------------|--------|-------|
| **Player/Sanctuary** | `lib/features/home/player_screen.dart` | ✅ **IMPLEMENTED** | Main player with visualizer, frequency controls |
| **Library** | `lib/features/favorites/library_screen.dart` | ✅ **IMPLEMENTED** | Favorites grid/list view |
| **Frequencies** | `lib/features/frequencies/frequencies_screen.dart` | ✅ **IMPLEMENTED** | Frequency browser, custom input |
| **Session History** | `lib/features/history/session_history_screen.dart` | ✅ **IMPLEMENTED** | Past sessions list |
| **Settings** | `lib/features/settings/settings_screen.dart` | ✅ **IMPLEMENTED** | App settings, donations, about |
| **Community Presets** | `lib/features/community/` (controller only) | ⚠️ **PARTIAL** | Controller exists, no screen |
| **Health Integration** | `lib/features/health/` (controller only) | ⚠️ **PARTIAL** | Controller exists, no dedicated screen |
| **Streaks** | `lib/features/streaks/` (controller only) | ⚠️ **PARTIAL** | Controller exists, no dedicated screen |

### Missing Screens (per PRD)

| Screen | PRD Section | Priority | Gap Analysis |
|--------|-------------|----------|--------------|
| **Journals/Notes** | 6.2 Screen Requirements | P2 | Not implemented - users can't add session notes |
| **Preset Detail/Edit** | US-2.1 | P1 | Library screen lacks edit/delete functionality |
| **Donation Screen** | US-3.1, 6.2 | P0 | Settings has donation section but not full screen |
| **Onboarding** | N/A | P1 | No onboarding flow for new users |
| **Stats Dashboard (Mobile)** | US-2.2 | P2 | No personal stats visualization in app |

### Navigation Structure Gaps

**Current:** Single `PlayerScreen` as home, navigation via `Navigator.push()`
**Required (PRD):** 
- Tab-based navigation: Library | Sanctuary | Frequencies | Journals
- Bottom nav or drawer for mobile
- Desktop has top navigation bar

---

## Part 2: Admin Dashboard (React + Vite)

### Current Implementation Status

| Page | File Location | Status | Notes |
|------|---------------|--------|-------|
| **Login** | `src/pages/Login.tsx` | ✅ **IMPLEMENTED** | Supabase auth |
| **Dashboard Home** | `src/pages/Dashboard.tsx` | ✅ **IMPLEMENTED** | Overview stats |
| **Analytics** | `src/pages/Analytics.tsx` | ✅ **IMPLEMENTED** | DAU/MAU, charts, metrics |
| **Users** | `src/pages/Users.tsx` | ✅ **IMPLEMENTED** | User list, search |
| **User Details** | `src/pages/UserDetails.tsx` | ✅ **IMPLEMENTED** | Individual user view |
| **Presets** | `src/pages/Presets.tsx` | ✅ **IMPLEMENTED** | Community preset management |
| **Remote Config** | `src/pages/RemoteConfig.tsx` | ✅ **IMPLEMENTED** | Feature flags, parameters |
| **Audit Log** | `src/pages/AuditLog.tsx` | ✅ **IMPLEMENTED** | Change history |
| **System Health** | `src/pages/SystemHealth.tsx` | ✅ **IMPLEMENTED** | Status monitoring |
| **Login History** | `src/pages/LoginHistory.tsx` | ✅ **IMPLEMENTED** | Security audit |
| **Ad Performance** | `src/pages/AdPerformance.tsx` | ✅ **IMPLEMENTED** | Monetization metrics |
| **Not Found** | `src/pages/NotFound.tsx` | ✅ **IMPLEMENTED** | 404 page |

### Dashboard Gaps

| Feature | PRD Reference | Status | Notes |
|---------|---------------|--------|-------|
| **Role-based Access** | BD-003 | ❌ **MISSING** | Only basic admin check, no viewer role |
| **MFA Support** | BD-002 | ❌ **MISSING** | No multi-factor auth UI |
| **Session Timeout UI** | BD-004 | ⚠️ **PARTIAL** | No visible timeout warning |
| **CSV Export** | US-4.2 | ❌ **MISSING** | Analytics can't export to CSV |
| **Real-time User Count** | Analytics Module | ⚠️ **PARTIAL** | No WebSocket/real-time updates |

---

## Part 3: Feature Completeness Matrix

### Core Audio Experience (Epic 1)

| Requirement | Status | Implementation Location |
|-------------|--------|------------------------|
| Five preset categories visible | ✅ | `player_screen.dart` |
| Tap to play (< 2s startup) | ✅ | `AudioService` + `SoLoud` |
| Background audio | ✅ | `audio_service.dart` |
| **Notification controls** | ❌ | Not implemented |
| Carrier frequency slider (100-500Hz) | ✅ | `player_screen.dart` |
| Visual recommended range indicator | ✅ | Slider with markers |
| **Save custom to preset** | ❌ | Not implemented |
| Timer presets | ✅ | `player_screen.dart` |
| **Custom timer input** | ❌ | Only presets, no custom |
| **Gentle fade-out** | ⚠️ | Basic fade, needs tuning |
| **Alarm sound** | ❌ | Not implemented |
| Music library access | ✅ | `AudioService` |
| Independent volume controls | ✅ | `player_screen.dart` |
| **Remember last music selection** | ❌ | Not persisted |

### Session Management (Epic 2)

| Requirement | Status | Implementation Location |
|-------------|--------|------------------------|
| View saved presets | ✅ | `library_screen.dart` |
| Quick-play from saved | ✅ | `library_screen.dart` |
| **Save current settings as named** | ❌ | Not implemented |
| **Edit/delete saved presets** | ❌ | Not implemented |
| Session history list | ✅ | `session_history_screen.dart` |
| Session duration displayed | ✅ | History screen |
| Frequency shown | ✅ | History screen |
| **Repeat session from history** | ❌ | Not implemented |
| **Export preset as shareable code** | ❌ | Not implemented |
| **Import preset from code** | ❌ | Not implemented |

### Donation System (Epic 3)

| Requirement | Status | Implementation Location |
|-------------|--------|------------------------|
| **Donation option in Settings** | ⚠️ | Section exists, not wired |
| Multiple amount options | ❌ | Not implemented |
| One-time and monthly | ❌ | Not implemented |
| **Apple Pay / Google Pay** | ❌ | Not implemented |
| **RevenueCat integration** | ❌ | Not implemented |
| Supporter badge | ❌ | Not implemented |
| Transparent cost breakdown | ❌ | Not implemented |
| Monthly funding goal display | ❌ | Not implemented |

### Admin & Remote Config (Epic 4)

| Requirement | Status | Implementation Location |
|-------------|--------|------------------------|
| Toggle ads remotely | ✅ | `RemoteConfigService` |
| Set user percentage | ✅ | `RemoteConfigPage` |
| Apply within 15 min | ✅ | `RemoteConfigService` |
| Audit log of changes | ✅ | `AuditLog.tsx` |
| DAU/MAU metrics | ✅ | `Analytics.tsx` |
| Session duration metrics | ✅ | `Analytics.tsx` |
| Popular frequency bands | ✅ | `Analytics.tsx` |
| **Donation conversion rates** | ❌ | Not tracked |
| **Export data to CSV** | ❌ | Not implemented |

---

## Part 4: UI/UX Implementation Gaps

### Design System Compliance

| Requirement | Status | Gap |
|-------------|--------|-----|
| Dark mode foundation (#0D0D0F) | ✅ | `AppColors` implemented |
| Purple primary (#7B68EE) | ✅ | `AppColors.primary` |
| Turquoise secondary (#00D9C0) | ✅ | `AppColors.secondary` |
| Glass-morphism effects | ✅ | `glassGradient` helper |
| Tonal layering | ✅ | Surface container hierarchy |
| **Space Grotesk + Inter typography** | ⚠️ | Inter loaded, Space Grotesk? |
| Desktop layout (1024px+) | ❌ | Only mobile layouts |
| **Responsive breakpoints** | ❌ | No tablet/desktop adaptation |

### Screen Layout Gaps (from PRD wireframes)

#### Main Player Screen

| Element | Mobile | Desktop | Status |
|---------|--------|---------|--------|
| Visualizer (Circle) | Required | Required | ✅ Implemented |
| Frequency band buttons | Required | Required | ✅ Implemented |
| Carrier slider | Required | Required | ✅ Implemented |
| Volume slider | Required | Required | ✅ Implemented |
| Timer display | Required | Required | ✅ Implemented |
| Play/Pause button | Required | Required | ✅ Implemented |
| **Bottom action bar** | [Timer][Music][Save][Share] | Same | ⚠️ Save/Share not functional |
| **Desktop: Left sidebar** | N/A | Quick Presets | ❌ Not implemented |
| **Desktop: Right sidebar** | N/A | Audio Mixer | ❌ Not implemented |
| **Desktop: Top nav** | N/A | Library/Sanctuary/Frequencies/Journals | ❌ Not implemented |

#### Library Screen

| Element | Mobile | Desktop | Status |
|---------|--------|---------|--------|
| Filter chips | N/A | Required | ❌ Not implemented |
| 2-column grid | N/A | Required | ❌ Single column only |
| Quick actions (play/fav/more) | Basic | Required | ⚠️ Play works, more options missing |
| Usage stats | N/A | Required | ❌ Not implemented |
| Community panel | N/A | Right sidebar | ❌ Not implemented |
| Create CTA | Basic | Prominent | ⚠️ Basic button only |

---

## Part 5: Technical Implementation Status

### State Management (Riverpod)

| Component | Status | Location |
|-----------|--------|----------|
| `AudioController` | ✅ | `core/audio/` |
| `FavoritesController` | ✅ | `features/favorites/` |
| `CommunityPresetsController` | ✅ | `features/community/` |
| `SettingsProvider` | ✅ | `features/settings/` |
| `SessionProvider` | ⚠️ | Partial - needs history tracking |
| `RemoteConfigController` | ✅ | `core/services/` |
| `HealthController` | ✅ | `features/health/` |
| `StreakController` | ✅ | `features/streaks/` |

### Services

| Service | Status | Notes |
|---------|--------|-------|
| `AudioService` (SoLoud) | ✅ | Binaural generation working |
| `SupabaseService` | ✅ | Auth, database, realtime |
| `RemoteConfigService` | ✅ | Feature flags |
| `AnalyticsService` (PostHog) | ✅ | Event tracking |
| `HealthService` | ✅ | Apple HealthKit / Google Fit |
| **AdService (AdMob)** | ❌ | Not implemented |
| **DonationService (RevenueCat)** | ❌ | Not implemented |
| **SharingService** | ❌ | Not implemented |
| **NotificationService** | ❌ | Not implemented |

---

## Part 6: Recommendations for Prototype Wiring

### Priority 1: Core Missing Features

1. **Navigation Structure**
   - Implement tab-based navigation (Library | Sanctuary | Frequencies | Journals)
   - Add bottom navigation bar for mobile

2. **Session Persistence**
   - Wire up "Save current settings as preset"
   - Add preset edit/delete functionality

3. **Donation Flow**
   - Integrate RevenueCat for IAP
   - Build dedicated donation screen

### Priority 2: Desktop Layouts

1. **Responsive Breakpoints**
   - Implement 1024px+ desktop layout
   - Three-column Sanctuary layout
   - Two-column Library grid

2. **Sidebars**
   - Left: Quick presets + favorites
   - Right: Audio mixer + session timer

### Priority 3: Social Features

1. **Community Presets Screen**
   - Build the missing community screen
   - Trending/featured presets

2. **Sharing**
   - Preset export/import via codes
   - Native share sheet integration

### Priority 4: Enhancement

1. **Notifications**
   - Background playback controls
   - Session complete notification

2. **Journals**
   - New screen for session notes
   - Mood/symptom tracking

---

## Appendix: File Mapping

### Flutter App Entry Points

| Route/Screen | File | Widget Class |
|--------------|------|--------------|
| Home/Player | `lib/features/home/player_screen.dart` | `PlayerScreen` |
| Library | `lib/features/favorites/library_screen.dart` | `LibraryScreen` |
| Frequencies | `lib/features/frequencies/frequencies_screen.dart` | `FrequenciesScreen` |
| History | `lib/features/history/session_history_screen.dart` | `SessionHistoryScreen` |
| Settings | `lib/features/settings/settings_screen.dart` | `SettingsScreen` |

### Dashboard Entry Points

| Route | File | Component |
|-------|------|-----------|
| `/` | `src/pages/Dashboard.tsx` | `Dashboard` |
| `/analytics` | `src/pages/Analytics.tsx` | `Analytics` |
| `/users` | `src/pages/Users.tsx` | `Users` |
| `/users/:userId` | `src/pages/UserDetails.tsx` | `UserDetails` |
| `/presets` | `src/pages/Presets.tsx` | `Presets` |
| `/config` | `src/pages/RemoteConfig.tsx` | `RemoteConfig` |
| `/audit` | `src/pages/AuditLog.tsx` | `AuditLog` |
| `/health` | `src/pages/SystemHealth.tsx` | `SystemHealth` |
| `/login-history` | `src/pages/LoginHistory.tsx` | `LoginHistory` |
| `/ads` | `src/pages/AdPerformance.tsx` | `AdPerformance` |

---

*Document generated: April 1, 2026*
*Next step: Wire up Stitch prototype based on this comparison*
