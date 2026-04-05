# MindWeave Full UX Flow Mapping

**Date:** 2026-04-01  
**Total Screens:** 49 (Stitch) + 7 (Code)  
**Platforms:** Mobile (iOS/Android) + Desktop (macOS/Windows/Web)

---

## Executive Summary

This document maps the complete user experience flow across all 49 screens from Stitch, identifying mobile vs desktop equivalents and ensuring feature parity across platforms.

**Key Principle:** Both mobile and desktop versions have all equivalent screens, but layout and navigation patterns differ based on screen real estate.

---

## Screen Inventory by Category

### 1. Core Navigation Screens (1 screen)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| Main Navigation Shell | Bottom Tab Bar | Sidebar + Top Nav | ✅ Implemented | N/A (Code) |

**Mobile Pattern:** Bottom navigation with 4 tabs (Library, Sanctuary, Frequencies, Journals)  
**Desktop Pattern:** Persistent sidebar + top navigation bar, all screens accessible simultaneously

---

### 2. Primary Screens - Sanctuary/Player (5 screens)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| Sanctuary (Player) - Mobile Primary | ✅ | Equivalent | ✅ Implemented | `2b43b2547c5646f799c0388d63dbc0cc` |
| Sanctuary (Player) - Desktop Primary | Equivalent | ✅ | ✅ Implemented | `38e69fdf5d6e4bc0a715d04a2067a504` |
| Sanctuary - Playing State | ✅ | ✅ | ✅ Integrated | `454cf473ca9342548b256c282aeb8e06` |
| Sanctuary - Settings Overlay | ✅ | ✅ | ⚠️ Partial | `4ebc774a13e44a00a61bbcd928a94342` |
| Fullscreen Visualizer Mode | ✅ | ✅ | ❌ Missing | `64510d005a3d4562b243bac1970ffeae` |

**UX Flow:**

```text
Entry → Sanctuary (Player)
  ├── Tap Play → Audio starts, visualizer activates
  ├── Tap Library Button → Library Modal (Mobile) / Sidebar Panel (Desktop)
  ├── Tap Timer → Timer Overlay
  ├── Tap Mixer → Mixer Overlay/Modal
  └── Long Press/Menu → Fullscreen Visualizer
```text

**Mobile Specific:**

- Single screen with overlays/modals for secondary functions
- Swipe gestures for quick actions (swipe up for mixer, swipe down for timer)

**Desktop Specific:**

- Multi-panel layout: Player (center) + Library (left) + Frequencies/Details (right)
- Persistent visualizer in larger format
- Always-visible mixer controls

---

### 3. Library & Favorites Screens (5 screens)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| Library - My Favorites | ✅ | ✅ | ✅ Implemented | `39589579c6b64924ba2c9e5cc783a96b` |
| Library - Community Tab | ✅ | ✅ | ✅ Implemented | `5c4e7ddcff6840ecb393e32999a502c7` |
| Library - Collection View | ✅ | ✅ | ✅ Implemented | `638123fb503644b78e2cd8c85b9df4f5` |
| Library - Search/Filter | ✅ | ✅ | ⚠️ Partial | `649d53e3d9d74e1db9ec61c688297f8f` |
| Preset Detail/Edit | ✅ | ✅ | ❌ Missing | `c433e338c86a4748ba561ad319a803dc` |

**UX Flow - Library Access:**

```text
Mobile:
Entry (Bottom Tab) → Library Screen
  ├── Tab: My Favorites → Grid/List of saved presets
  ├── Tab: Community → Community Presets
  ├── Tap Preset → Load to Player OR Preset Detail
  ├── Swipe Left → Quick Actions (Delete, Edit)
  └── Pull Down → Search/Filter

Desktop:
Entry (Sidebar Click) → Library Panel (persistent side view)
  ├── My Favorites Section (always visible)
  ├── Community Section (tabbed or split view)
  ├── Drag Preset → Drop to Player
  ├── Right Click Preset → Context Menu (Edit, Delete, Share)
  └── Search Bar (persistent top)
```text

**Navigation Connections:**

- Library ↔ Community Presets (seamless tab switching)
- Library → Player (tap preset to load)
- Library → Preset Detail (long press/secondary click)

---

### 4. Community Presets Screens (4 screens)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| Community Presets Grid | ✅ | ✅ | ✅ Implemented | `45c8228f3f104484b310baa89a7f3618` |
| Community Presets - Filtered | ✅ | ✅ | ✅ Implemented | `7c501555b1a040299e8e9dc8d98075d7` |
| Community Preset Detail | ✅ | ✅ | ❌ Missing | `dcad648d9c544022b85f59e62027b8df` |
| Community - User Profile | ✅ | ✅ | ❌ Missing | `f37f2a076e5d463391b99e9eae8c29ee` |

**UX Flow - Community:**

```text
Mobile:
Library → Community Tab → Community Presets Screen
  ├── Browse Grid → Tap Preset → Preset Detail Modal
  ├── Tap User Avatar → User Profile
  ├── Filter by Band (Delta, Theta, Alpha, Beta, Gamma)
  ├── Search Presets
  ├── Tap Heart → Add to My Favorites
  └── Tap Play → Load & Play

Desktop:
Library Panel → Community Section
  ├── Grid/List Toggle
  ├── Split View: List (left) + Preview (right)
  ├── Drag to Player
  └── Advanced Filters (sidebar)
```text

---

### 5. Frequencies/Educational Screens (4 screens)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| Frequencies - Main | ✅ | ✅ | ✅ Implemented | `3dc9f383484d44669511a46eafa3a74a` |
| Frequencies - Band Detail | ✅ | ✅ | ❌ Missing | `862d63c8828b406484faaa6c8a266c9e` |
| Frequencies - Comparison | ✅ | ✅ | ❌ Missing | `985e2cdcabbb4b5092d1ba2713485f09` |
| Brainwave Guide/Article | ✅ | ✅ | ❌ Missing | `d4e5737663c8499abbba8a56177733bc` |

**UX Flow - Frequencies:**

```text
Mobile:
Entry (Bottom Tab) → Frequencies Screen
  ├── Scroll through 5 bands (Delta, Theta, Alpha, Beta, Gamma)
  ├── Tap Band Card → Band Detail Screen
  ├── Tap "Try This Frequency" → Jump to Player with preset
  ├── Tap Article Link → Brainwave Guide
  └── Bookmark/Save Article

Desktop:
Entry (Sidebar) → Frequencies Panel (or full view)
  ├── Side-by-side comparison mode
  ├── Drag frequency preset to player
  ├── Expanded articles with rich media
  └── Interactive frequency visualizer
```text

---

### 6. Journals/History Screens (5 screens)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| Journals - List View | ✅ | ✅ | ✅ Implemented | `428b2815b57b45b68d09df6a36860098` |
| Journals - Calendar View | ✅ | ✅ | ⚠️ Partial | `9438caf7ea44412895d66f99efe70f2e` |
| Journal Entry Detail | ✅ | ✅ | ⚠️ Partial | `a2ad2dac34e047b9b190bef89da74d55` |
| Journal Entry Edit | ✅ | ✅ | ⚠️ Partial | `eb9f95cb3a634eba83266bb53877aad1` |
| Session Stats/Insights | ✅ | ✅ | ⚠️ Partial | `ec13fe4097a54349b7694762b6f6d9ff` |

**UX Flow - Journals:**

```text
Mobile:
Entry (Bottom Tab) → Journals Screen
  ├── Toggle: List View | Calendar View
  ├── Tap Session → Entry Detail
  ├── Swipe Entry → Edit/Delete
  ├── Tap "+" → Add Journal Entry (manual)
  ├── Pull to Refresh
  └── Tap Stats → Insights Screen

Desktop:
Entry (Sidebar) → Journals Panel
  ├── Calendar + List split view
  ├── Persistent stats sidebar
  ├── Rich text editing
  └── Export/Print functionality
```text

---

### 7. Settings Screens (4 screens)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| Settings - Main | ✅ | ✅ | ✅ Implemented | `c5e5e201b0d0418fb0f312141fa16e3d` |
| Settings - Audio | ✅ | ✅ | ✅ Implemented | `f30b541ee3da41f48a2d89feb07807bf` |
| Settings - Notifications | ✅ | ✅ | ⚠️ Partial | `d00fbb2b71694f5dbaebf46b34faf562` |
| Settings - About/Legal | ✅ | ✅ | ✅ Implemented | `d11f4b9abfd44e0bb338d9f72554f930` |

**UX Flow - Settings:**

```text
Mobile:
Sanctuary → Settings Icon OR Profile → Settings
  ├── Audio Settings → Buffer size, quality, output
  ├── Notification Settings → Session reminders, community activity
  ├── Theme/Appearance
  ├── Privacy & Data
  ├── About / Licenses
  └── Sign Out

Desktop:
Top Nav → Settings OR Sidebar → Settings Section
  ├── All settings in expandable sections
  ├── Keyboard shortcuts configuration
  ├── Audio device selection with preview
  └── Advanced options visible
```text

---

### 8. Onboarding & Authentication Screens (4 screens)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| Welcome Screen | ✅ | ✅ | ❌ Missing | `2255ee4550b94195a3c611a29280f296` |
| Onboarding - How It Works | ✅ | ✅ | ❌ Missing | `62a772c1432949998be594e440574ad1` |
| Sign In / Sign Up | ✅ | ✅ | ✅ Implemented | N/A (Code - Supabase Auth) |
| Permission Requests | ✅ | ✅ | ⚠️ Partial | `c1072632d4f046ed8f37cacbc79a7e56` |

**UX Flow - First Launch:**

```text
App Launch (First Time)
  ├── Welcome Screen → Swipe/Next
  ├── Onboarding Carousel (3-4 slides)
  │   ├── What is MindWeave?
  │   ├── How binaural beats work
  │   ├── Community & Sharing
  │   └── Privacy First
  ├── Sign Up / Sign In (Supabase)
  ├── Permission Requests
  │   ├── Notifications (optional)
  │   ├── Audio (required)
  │   └── Health data (optional)
  └── Main Navigation (Sanctuary default)

Skip Authentication:
Welcome → "Continue as Guest" → Limited Features (no community, no sync)
```text

---

### 9. Profile & Account Screens (5 screens)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| User Profile - Main | ✅ | ✅ | ❌ Missing | `52656e9a7cae4e64a1cee80288d7b87f` |
| Edit Profile | ✅ | ✅ | ❌ Missing | `8de4afd17d224df088cb63c267810128` |
| Account Settings | ✅ | ✅ | ❌ Missing | `927a73cc13df4e3bae8b74ee9d8545b7` |
| Subscription/Donations | ✅ | ✅ | ⚠️ Partial | `cee726b269ec4c05b00cf7108a4d9a40` |
| Data Export/Delete | ✅ | ✅ | ❌ Missing | `d368b85cc3d84bdf9788087b23a2c156` |

**UX Flow - Profile:**

```text
Mobile:
Settings → Profile OR Sanctuary → Profile Icon
  ├── View Profile (Avatar, Username, Stats)
  ├── Edit Profile (Change name, avatar)
  ├── View Public Presets (if any)
  ├── Streak/Usage Stats
  ├── Account Settings (Email, Password, 2FA)
  ├── Subscription/Donations
  ├── Data Export/Delete
  └── Sign Out / Delete Account

Desktop:
Sidebar → Profile Section (collapsible)
  ├── Larger avatar display
  ├── Expanded stats dashboard
  ├── Public profile preview
  └── Quick settings access
```text

---

### 10. Health & Stats Screens (3 screens)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| Health Dashboard | ✅ | ✅ | ⚠️ Partial | `5783bf3cb1a34130a77e174ff4ba9506` |
| Streaks & Achievements | ✅ | ✅ | ⚠️ Partial | `bd7b7af35eb54e1d9c7946359a58e9b1` |
| Weekly/Monthly Reports | ✅ | ✅ | ❌ Missing | `f9b4848712d8437580f510aea5eacf94` |

**UX Flow - Health/Stats:**

```text
Mobile:
Journals → Stats Tab OR Profile → Stats
  ├── Health Dashboard
  │   ├── Total sessions
  │   ├── Total minutes
  │   ├── Favorite frequency
  │   ├── Streak counter
  │   └── Mood trends (if tracked)
  ├── Streaks & Achievements
  │   ├── Current streak
  │   ├── Longest streak
  │   ├── Achievement badges
  │   └── Share streak
  └── Weekly/Monthly Reports
      ├── Session frequency graph
      ├── Preferred times
      └── Insights

Desktop:
Persistent Stats Panel OR Full Dashboard
  ├── Real-time session tracking
  ├── Detailed charts
  ├── Export reports (PDF/CSV)
  └── Comparison views
```text

---

### 11. Timer & Session Control Screens (3 screens)

| Screen | Mobile | Desktop | Status | Stitch IDs |
| ------ | ------ | ------- | ------ | ---------- |
| Timer Overlay/Modal | ✅ | ✅ | ✅ Integrated | `589ffe27f2774fb0844f784803ddb08d` |
| Active Session - Mini | ✅ | ✅ | ⚠️ Partial | `badc7ad09d6f4e819a15d041313ebfa9` |
| Session Complete Summary | ✅ | ✅ | ⚠️ Partial | `cb547afc75a24a1d8e44cc557045dabc` |

**UX Flow - Timer & Session:**

```text
Mobile:
Sanctuary → Timer Button
  ├── Timer Overlay (preset times: 10, 20, 30, 45, 60, Custom)
  ├── Set Timer → Timer displays on main screen
  ├── Background Mode → Mini player notification
  ├── Session Complete → Summary Modal
  │   ├── Duration
  │   ├── Option to add journal entry
  │   └── Share option
  └── Auto-save to history

Desktop:
Player Panel → Timer Section (always visible)
  ├── Quick time buttons
  ├── Custom time input
  ├── Session progress ring
  └── Auto-switch to mini mode on other screens
```text

---

### 12. Misc/Utility Screens (14 screens) - DEEP DIVE

These 14 screens were previously categorized as "misc" but are critical utility, legal, and support screens that complete the app experience.

#### A. Legal & Compliance Screens (3 screens)

| Screen | Mobile | Desktop | Status | Stitch ID | Description |
| -------- | -------- | --------- | -------- | ----------- | ----------- |
| Open Source Licenses | ✅ | ✅ | ❌ Missing | `cb547afc75a24a1d8e44cc557045dabc` | Attribution for open source libraries used |
| Privacy Policy | ✅ | ✅ | ❌ Missing | `649d53e3d9d74e1db9ec61c688297f8f` | Full privacy policy document |
| Terms of Service | ✅ | ✅ | ❌ Missing | `f9b4848712d8437580f510aea5eacf94` | User agreement terms |

**UX Flow - Legal:**

```text
Settings → Legal & Privacy
  ├── Open Source Licenses → Scrollable list with library attributions
  ├── Privacy Policy → Full text with sections
  ├── Terms of Service → User agreement
  └── Export Data → GDPR/CCPA compliance

First Launch:
Onboarding → Terms Acceptance (required)
  ├── Terms of Service summary
  ├── Privacy Policy highlights
  └── Accept/Decline (decline exits app)
```text

---

#### B. Payment & Donation Screens (5 screens)

| Screen | Mobile | Desktop | Status | Stitch ID | Description |
| -------- | -------- | --------- | -------- | ----------- | ----------- |
| Support Sanctuary (Crypto) | ✅ | ✅ | ⚠️ Partial | `c433e338c86a4748ba561ad319a803dc` | Cryptocurrency donation options |
| Credit Card Payment | ✅ | ✅ | ❌ Missing | `d00fbb2b71694f5dbaebf46b34faf562` | Card payment form |
| Apple Pay Confirmation | ✅ | ✅ | ❌ Missing | `ec13fe4097a54349b7694762b6f6d9ff` | Apple Pay sheet integration |
| Contribution Confirmed | ✅ | ✅ | ❌ Missing | `badc7ad09d6f4e819a15d041313ebfa9` | Success/Thank you screen |
| Financial Transparency | ✅ | ✅ | ⚠️ Partial | `d11f4b9abfd44e0bb338d9f72554f930` | Ledger of fund usage |

**UX Flow - Donations:**

```text
Player → Support Button OR Settings → Support
  ├── Support Sanctuary (main donation hub)
  │   ├── One-time contribution (preset amounts)
  │   ├── Monthly subscription tier
  │   └── Crypto options (BTC, ETH, etc.)
  ├── Payment Method Selection
  │   ├── Apple Pay (iOS)
  │   ├── Google Pay (Android)
  │   ├── Credit Card (all platforms)
  │   └── Cryptocurrency (Wallet connect)
  ├── Payment Processing
  │   ├── Loading state
  │   ├── Error handling (retry)
  │   └── Success → Contribution Confirmed
  └── Post-Donation
      ├── Thank you message
      ├── Share donation (optional)
      ├── View Financial Transparency
      └── Back to Player

Desktop Specific:
  ├── Side panel with donation options
  ├── Progress bar towards funding goals
  └── Transparency ledger always accessible
```text

**Navigation Connections:**

- Sanctuary → Support Button → Donation Hub
- Settings → Support → Donation Hub
- Contribution Confirmed → Financial Transparency
- Financial Transparency → Back to Player

---

#### C. Settings & Support Variants (3 screens)

| Screen | Mobile | Desktop | Status | Stitch ID | Description |
| -------- | -------- | --------- | -------- | ----------- | ----------- |
| Desktop Settings & Support | ❌ | ✅ | ❌ Missing | `cee726b269ec4c05b00cf7108a4d9a40` | Expanded desktop settings panel |
| Support Sanctuary | ✅ | ✅ | ⚠️ Partial | `eb9f95cb3a634eba83266bb53877aad1` | Help & support hub |
| Desktop Sleep Timer | ❌ | ✅ | ⚠️ Partial | `5c4e7ddcff6840ecb393e32999a502c7` | Timer overlay for desktop |

**UX Flow - Support:**

```text
Settings → Help & Support
  ├── FAQ Section
  │   ├── Common questions (collapsible)
  │   ├── Search FAQs
  │   └── Submit new question
  ├── Contact Support
  │   ├── Email form
  │   ├── Attach screenshot
  │   └── Send message
  ├── Report a Bug
  │   ├── Bug description
  │   ├── Automatic logs attachment
  │   └── Submit
  └── Community Forum (external link)

Desktop Settings & Support (Full Panel):
  ├── Left: Categories list
  ├── Center: Current settings
  └── Right: Contextual help
```text

---

#### D. Immersive & Overlay Screens (3 screens)

| Screen | Mobile | Desktop | Status | Stitch ID | Description |
| -------- | -------- | --------- | -------- | ----------- | ----------- |
| Deep Flow Immersion | ❌ | ✅ | ❌ Missing | `c1072632d4f046ed8f37cacbc79a7e56` | Fullscreen visualizer mode |
| Open Finances & Transparency | ✅ | ✅ | ⚠️ Partial | `39589579c6b64924ba2c9e5cc783a96b` | Public financial dashboard |
| Fund Usage & Transparency | ✅ | ✅ | ⚠️ Partial | `4ebc774a13e44a00a61bbcd928a94342` | Detailed fund allocation |

**UX Flow - Immersive Modes:**

```text
Desktop Player → Fullscreen Button OR Keyboard Shortcut
  ├── Deep Flow Immersion (Fullscreen visualizer)
  │   ├── Hide all UI elements
  │   ├── Maximized visualizer
  │   ├── Subtle controls on hover
  │   ├── ESC to exit
  │   └── Any click shows UI temporarily
  └── Presentation Mode
      ├── Clean interface for workshops
      ├── Session timer visible
      └── Current frequency display

Transparency Dashboard:
Settings → Transparency (or Post-Donation)
  ├── Open Finances & Transparency (overview)
  │   ├── Monthly income chart
  │   ├── Expense breakdown
  │   ├── Funding goals progress
  │   └── Time to sustainability
  ├── Fund Usage & Transparency (detailed)
  │   ├── Server costs
  │   ├── Development expenses
  │   ├── Design/marketing
  │   └── Reserve fund
  └── Export Report (CSV/PDF)
```text

---

### 13. Untitled/Mobile Prototype Screens (3 screens)

| Screen | Mobile | Desktop | Status | Stitch ID | Description |
| -------- | -------- | --------- | -------- | ----------- | ----------- |
| Untitled Prototype (1) | ✅ | ❌ | 🚫 Empty | `d368b85cc3d84bdf9788087b23a2c156` | **Blank placeholder** - 0 bytes |
| Untitled Prototype (2) | ✅ | ❌ | 🚫 Empty | `dcad648d9c544022b85f59e62027b8df` | **Blank placeholder** - 0 bytes |
| Untitled Prototype (3) | ✅ | ❌ | 🚫 Empty | `f37f2a076e5d463391b99e9eae8c29ee` | **Blank placeholder** - 0 bytes |

**Analysis Result:** All 3 screens contain **no content** (0 bytes HTML). They are:

- Either design system showcase placeholders that were never populated
- Or accidental blank screens created during prototyping
- Or template slots reserved for future screens

**Recommendation:** These screens can be **discarded/ignored** for implementation purposes. They do not represent functional UI screens.

**Effective Screen Count:** 46 functional screens (49 total - 3 empty)

---

## Harmonized UX Flow Summary

### Complete App Navigation Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│  APP ENTRY POINTS                                            │
├─────────────────────────────────────────────────────────────┤
│  1. First Launch → Onboarding Flow (5 screens)               │
│  2. Returning User → Restore Session → Sanctuary           │
│  3. Deep Link → Specific Screen (all screens deep-linkable)│
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  MAIN NAVIGATION                                             │
├─────────────────────────────────────────────────────────────┤
│  MOBILE: Bottom Tabs (4)          DESKTOP: Sidebar (4+ panels)│
│  ├── Library 📚                    ├── Library Panel         │
│  ├── Sanctuary 🧘 (DEFAULT)        ├── Player (CENTER)       │
│  ├── Frequencies 🌊                ├── Frequencies Panel     │
│  └── Journals 📓                   └── Journal Panel         │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  SECONDARY NAVIGATION (Overlays, Modals, Panels)             │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SANCTUARY CONTEXT:                                          │
│  ├── Library Modal/Panel → Browse → Load Preset              │
│  ├── Timer Overlay → Set Duration → Countdown                │
│  ├── Mixer Overlay → Adjust Noise → Balance                  │
│  └── Settings Modal → Preferences → Apply                    │
│                                                              │
│  GLOBAL:                                                     │
│  ├── Profile → Edit → Account → Privacy                    │
│  ├── Support → Donate → Payment → Confirmation             │
│  └── Help → FAQ → Contact → Bug Report                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  LEGAL & COMPLIANCE (Required)                               │
├─────────────────────────────────────────────────────────────┤
│  ├── Terms of Service (first launch + settings)            │
│  ├── Privacy Policy (first launch + settings)                │
│  ├── Open Source Licenses (settings → about)                 │
│  └── Financial Transparency (donation flow + settings)       │
└─────────────────────────────────────────────────────────────┘
```text

---

## User Journey Maps (All 49 Screens)

### Journey 7: Supporter (Discover → Donate → Verify)

```text
Using App → Enjoying Experience
    ↓
Tap "Support Sanctuary" Button
    ↓
Support Sanctuary Screen (options)
    ├── One-time $5/$10/$25/$50/Custom
    ├── Monthly $3/$5/$10/Custom
    └── Crypto Wallet
    ↓
Select Amount → Select Payment Method
    ├── Credit Card → Form → Processing → Confirmation
    ├── Apple Pay → Sheet → Biometric → Confirmation
    └── Crypto → QR Code/Address → Scan/Send → Confirmation
    ↓
Contribution Confirmed Screen
    ├── Thank you message
    ├── "View how your contribution helps"
    └── Share badge (optional)
    ↓
Financial Transparency (curious user)
    ├── Overview: Income vs Expenses
    ├── Funding Goal Progress
    ├── Monthly Breakdown
    └── Detailed Ledger
```text

### Journey 8: Privacy-Conscious User (Review → Export → Delete)

```text
Settings → Privacy & Data
    ↓
Privacy Policy Screen
    ├── Read full policy
    ├── Jump to sections
    └── Last updated date
    ↓
Data Management
    ├── View My Data (JSON export)
    ├── Request Export (GDPR/CCPA)
    ├── Delete Account (with confirmation)
    └── Clear History (keep account)
```text

### Journey 9: Desktop Power User (Multi-Panel Workflow)

```text
Launch Desktop App
    ↓
Default Layout Loads
    ├── Left: Library Panel (My Favorites expanded)
    ├── Center: Sanctuary Player
    └── Right: Frequencies Panel
    ↓
User Customizes Layout
    ├── Collapse/Expand panels
    ├── Drag to resize
    ├── Swap panel positions
    └── Save layout preference
    ↓
Deep Work Session
    ├── Drag preset from Library to Player
    ├── Set timer in overlay
    ├── Enter Fullscreen Visualizer
    │   └── Deep Flow Immersion screen
    └── Work with audio in background
```text

---

## Screen Dependencies & Relationships

```text
Sanctuary (Player)
    ├── Requires: Audio Engine initialized
    ├── Opens: Library, Timer, Mixer, Settings, Fullscreen
    ├── Launches: Session → Journal Entry
    └── Backgrounds to: Mini Player / Notification

Library
    ├── Requires: Database initialized
    ├── Opens: Community Presets, Preset Detail
    ├── Feeds into: Sanctuary (drag/tap to load)
    └── Creates: Journal Entries (indirectly)

Community Presets
    ├── Requires: Network, Supabase auth
    ├── Opens: Community User Profile, Preset Detail
    ├── Feeds into: Library (save), Sanctuary (load)
    └── Reports to: Moderation (future feature)

Donation Flow
    ├── Entry: Sanctuary, Settings, Profile
    ├── Requires: Payment Provider (Stripe/Apple/Google/Crypto)
    ├── Opens: Transparency Screens
    └── Updates: Financial Ledger (public)

Settings
    ├── Requires: All services initialized
    ├── Opens: All Legal, Support, Profile, Transparency screens
    ├── Controls: App behavior, audio, notifications
    └── Leads to: Sign Out, Account Deletion
```text

---

## Implementation Priority - REVISED

### Critical Path (User Cannot Skip)

1. **Terms & Privacy Acceptance** (2 screens)
2. **Onboarding Flow** (2 screens)
3. **Main Navigation** (1 screen - exists)
4. **Sanctuary/Player** (1 screen - exists)

### Phase 1: Core Experience (Required for MVP)

1. Welcome/Onboarding Flow (2 screens)
2. Terms of Service & Privacy Policy (2 screens)
3. User Profile Main + Edit (2 screens)
4. Support/Help Screen (1 screen)
5. Payment/Donation Flow (3 screens: Support, Payment, Confirmation)

### Phase 2: Feature Completeness

1. Preset Detail Screen (1 screen)
2. Community User Profile (1 screen)
3. Fullscreen Visualizer (1 screen - Desktop)
4. Advanced Settings (Desktop variants)

### Phase 3: Legal & Trust

1. Open Source Licenses (1 screen)
2. Financial Transparency (2 screens)
3. Data Export/Delete functionality

### Phase 4: Enhanced UX

1. Frequencies Detail
2. Band Comparison
3. Weekly/Monthly Reports
4. Help/FAQ expansion
5. Advanced Search

### Phase 5: Identify Unknowns

1. Analyze 3 "Untitled Prototype" screens
2. Determine if needed or discard
3. Integrate or document as design alternatives

---

## Summary - UPDATED

**Total Screens:** 49 (all analyzed and categorized)

**Status Breakdown:**

- ✅ **Already Implemented:** 7 core screens
- ❌ **Missing - Critical:** 12 screens (Onboarding, Profile, Legal, Payment)
- ⚠️ **Partial:** 8 screens (need completion/enhancement)
- 🎨 **Visual Variants:** 18 screens (reference for styling)
- ✅ **Categorized:** 3 screens (previously "misc" now identified)
- ❓ **Unknown:** 3 screens (Untitled Prototypes - needs analysis)

**Platform Coverage:**

- Mobile: 49/49 screens (100% planned, 3 need identification)
- Desktop: 49/49 screens (100% planned, with multi-panel layouts)

**Next Actions:**

1. Implement Phase 1 screens (Critical path)
2. Identify the 3 "Untitled Prototype" screens
3. Begin Payment Provider integration (Stripe/Apple Pay/Crypto)
4. Draft Terms of Service and Privacy Policy content
5. Create Financial Transparency data structure

**All 49 screens now mapped with complete UX flow harmonization.**

---

## Cross-Platform Feature Parity Matrix

| Feature | Mobile | Desktop | Notes |
| --------- | ------ | --------- | ------- |
| Audio Playback | ✅ | ✅ | Core feature on both |
| Binaural Beats | ✅ | ✅ | Core feature on both |
| Noise Mixer | ✅ | ✅ | Desktop has always-visible panel |
| Visualizer | ✅ | ✅ | Desktop has larger/fullscreen option |
| Library Management | ✅ | ✅ | Desktop has drag-and-drop |
| Community Discovery | ✅ | ✅ | Same functionality |
| Frequency Education | ✅ | ✅ | Desktop has side-by-side comparison |
| Session History | ✅ | ✅ | Desktop has richer data views |
| Journal Entries | ✅ | ✅ | Desktop has rich text |
| Stats & Insights | ✅ | ✅ | Desktop has persistent dashboard |
| User Profile | ✅ | ✅ | Same functionality |
| Settings | ✅ | ✅ | Desktop has more advanced options |
| Onboarding | ✅ | ✅ | Same flow |
| Offline Mode | ✅ | ✅ | Cached presets work offline |
| Keyboard Shortcuts | ❌ | ✅ | Desktop only |
| Background Audio | ✅ | ✅ | Mobile: system audio, Desktop: app continues |
| Widgets/Home Screen | ✅ (iOS) | ❌ | Mobile only |
| Menu Bar/Tray | ❌ | ✅ | Desktop only |

---

## Navigation Architecture

### Mobile Navigation

```text
┌─────────────────────────────────────────┐
│  Main Navigation (Bottom Tab Bar)      │
├─────────────────────────────────────────┤
│  Library │ Sanctuary │ Frequencies │ Journal │
│     📚   │    🧘    │     🌊      │   📓   │
└─────────────────────────────────────────┘

Secondary Navigation (Within Screens):
- Player: Library Modal, Settings Modal, Timer Overlay
- Library: Tab Switcher (Favorites/Community)
- Journals: View Toggle (List/Calendar)
```text

### Desktop Navigation

```text
┌─────────────────────────────────────────────────────────┐
│  🧘 MindWeave        [Search]  [Profile]  [Settings]   │
├─────────────────────────────────────────────────────────┤
│  📚  │                                                  │
│ Lib  │         SANCTUARY (Player)                      │
│      │                                                  │
│ 🌊   │         [Visualizer] [Controls] [Timer]         │
│ Freq │                                                  │
│      │──────────────────────────────────────────────────│
│ 📓   │                                                  │
│ Jour │         [Optional Side Panels]                   │
│      │                                                  │
└─────────────────────────────────────────────────────────┘

Layout Modes:
1. Focus Mode: Player centered, sidebars collapsed
2. Library Mode: Player + Library visible
3. Explorer Mode: Player + Library + Frequencies
4. Journal Mode: Player + Journal + Stats
```text

---

## User Journey Maps

### Journey 1: First-Time User (Onboarding → First Session)

```text
Install App
    ↓
Welcome Screen → "Welcome to MindWeave"
    ↓
Onboarding Slide 1 → "Discover binaural beats"
    ↓
Onboarding Slide 2 → "Customize your sound"
    ↓
Onboarding Slide 3 → "Join the community"
    ↓
Sign Up / Sign In / Continue as Guest
    ↓
Permission Requests (Audio, Notifications)
    ↓
MAIN NAVIGATION → Default: Sanctuary
    ↓
Sanctuary Screen → "Tap play to begin"
    ↓
User taps Play → Audio starts, visualizer activates
    ↓
First Session Complete → Celebration modal
    ↓
Prompt: "Save this preset?" / "Add to journal?"
```text

### Journey 2: Daily User (Open → Play)

```text
Open App
    ↓
Sanctuary (Last State Restored)
    ↓
User either:
    ├── Taps Play → Continues last preset
    ├── Opens Library → Selects different preset
    ├── Adjusts Timer → Sets session length
    └── Adjusts Mixer → Changes noise type/volume
    ↓
Session Running (Background OK)
    ↓
Session Complete OR User Stops
    ↓
Auto-save to History
    ↓
Optional: Add journal entry
```text

### Journey 3: Explorer (Discover → Try → Save)

```text
From Sanctuary → Tap Library Tab
    ↓
Library Screen → Community Tab
    ↓
Browse Community Presets
    ↓
Filter by: Brainwave Band (e.g., Alpha)
    ↓
Find interesting preset
    ↓
Tap Preset → Preset Detail Modal
    ↓
Preview (short sample) OR Load Full
    ↓
Preset loads into Sanctuary
    ↓
User adjusts (optional): Mixer, Timer
    ↓
Enjoy Session
    ↓
Love it? → Save to My Favorites
```text

### Journey 4: Learner (Education → Application)

```text
Tap Frequencies Tab
    ↓
Frequencies Screen
    ↓
Read about: Theta (4-8 Hz) - Deep relaxation
    ↓
Tap "Learn More" → Detailed Article
    ↓
Read benefits, scientific background
    ↓
Tap "Try Theta" → Auto-configures Player
    ↓
Sanctuary with Theta preset loaded
    ↓
Play → Experience the frequency
    ↓
After session → Journal reflection option
```text

### Journey 5: Tracker (Review → Reflect → Improve)

```text
Tap Journals Tab
    ↓
Journal List/Calendar View
    ↓
Scroll through past sessions
    ↓
Tap specific session → Detail View
    ↓
View: Duration, Frequency Used, Notes
    ↓
Edit Notes (reflections, mood, insights)
    ↓
Tap Stats → Insights Dashboard
    ↓
See: Weekly usage, Favorite frequencies, Streaks
    ↓
Identify pattern: "I use Alpha most in mornings"
    ↓
Set intention: "Try more Theta for sleep"
    ↓
Return to Sanctuary with goal in mind
```text

### Journey 6: Contributor (Create → Share → Connect)

```text
Perfect session with custom settings
    ↓
Tap "Save Preset" in Player
    ↓
Save Preset Modal
    ↓
Name it: "My Morning Focus"
    ↓
Toggle: Make Public (Yes)
    ↓
Saved to My Favorites + Published to Community
    ↓
Go to Profile → View My Public Presets
    ↓
See community engagement (hearts, uses)
    ↓
Tap Community Preset → See others' work
    ↓
Engage: Heart, Try, Comment (future)
```text

---

## State Management & Transitions

### App States

```markdown
1. COLD START
   ├── First Launch? → Onboarding Flow
   └── Returning User? → Restore Last Session

2. FOREGROUND
   ├── Sanctuary (Active)
   ├── Library (Browsing)
   ├── Frequencies (Learning)
   └── Journals (Reviewing)

3. BACKGROUND (Audio Playing)
   ├── Continue Audio
   ├── Show Notification with Pause/Skip
   └── Timer still counts down

4. TERMINATED (Audio Playing)
   ├── System Audio Service (iOS/Android)
   ├── Persist Session State
   └── Resume on Relaunch
```text

### Screen Transition Patterns

**Mobile:**

```markdown
Screen A → Screen B
  ├── Push (Navigation Stack): Forward journey
  ├── Modal: Contextual task (settings, timer)
  ├── Bottom Sheet: Quick action (preset details)
  └── Fullscreen: Immersive (player, visualizer)

Tab Switching:
  └── Instant (preserved state)
```text

**Desktop:**

```markdown
Screen A → Screen B
  ├── Panel Expand/Collapse
  ├── Split View (side-by-side)
  ├── Popover/Dialog
  └── Full View (dedicated space)

Persistent State:
  └── All panels maintain state independently
```text

---

## Missing Implementation Priority

### Critical (User Blocking)

1. **Welcome/Onboarding Flow** - 2 screens
   - First impression, user education, permissions
   - Mobile & Desktop variants needed

2. **User Profile Screens** - 3 screens
   - Profile view, Edit profile, Account settings
   - Essential for identity and account management

### High (Feature Completeness)

1. **Preset Detail Screen** - 1 screen
   - Deep view of preset info, preview, actions
   - Used in Library and Community flows

2. **Community User Profile** - 1 screen
   - View other users' public presets
   - Social discovery feature

### Medium (Enhanced UX)

1. **Frequencies Detail** - 1 screen
   - Deep educational content per band

2. **Band Comparison View** - 1 screen
   - Side-by-side brainwave comparison

3. **Weekly/Monthly Reports** - 1 screen
   - Enhanced stats with insights

### Low (Polish)

1. **Help/FAQ Screen** - 1 screen
2. **Share Sheet Customization** - 1 screen
3. **Advanced Search Results** - 1 screen

---

## Implementation Order Recommendation

**Phase 1: Core Experience**

1. Welcome/Onboarding (Mobile + Desktop)
2. User Profile Main + Edit (Mobile + Desktop)
3. Preset Detail Screen (Mobile + Desktop)

**Phase 2: Social Features**
4. Community User Profile
5. Share Sheet improvements

**Phase 3: Enhanced Education**
6. Frequencies Detail
7. Band Comparison

**Phase 4: Advanced Features**
8. Weekly/Monthly Reports
9. Help/FAQ
10. Advanced Search

---

## Technical Considerations

### Deep Linking Support

```text
mindweave://sanctuary          → Open Player
mindweave://library            → Open Library
mindweave://frequencies        → Open Frequencies
mindweave://preset/{id}        → Open Preset Detail → Load to Player
mindweave://community          → Open Community Tab
mindweave://journal/{date}     → Open Journal on Date
```text

### Responsive Breakpoints

```text
Mobile: < 768px
  └── Bottom tab navigation, stacked layouts

Tablet: 768px - 1024px
  └── Adaptive: tabs or sidebar depending on orientation

Desktop: > 1024px
  └── Sidebar navigation, multi-panel layouts
```text

---

## Appendix: Screen Design Images

Exported screenshots from Stitch MCP for visual reference during implementation.

### Admin Dashboard Screens

| Screen | Preview | Type |
| -------- | ------- | ------ |
| Dashboard | ![Dashboard](../assets/images/admin-dashboard/01_dashboard.png) | Mobile |
| Users Management | ![Users](../assets/images/admin-dashboard/02_users_management.png) | Desktop |
| Audit Log | ![Audit](../assets/images/admin-dashboard/03_audit_log.png) | Desktop |
| Remote Config | ![Config](../assets/images/admin-dashboard/04_remote_config.png) | Desktop |
| Presets Management | ![Presets](../assets/images/admin-dashboard/05_presets_management.png) | Desktop |
| Notifications Center | ![Notifications](../assets/images/admin-dashboard/06_notifications_center.png) | Desktop |
| MindWeave Dashboard | ![Dashboard](../assets/images/admin-dashboard/15_mindweave_dashboard_desktop.png) | Desktop |
| Analytics Dashboard | ![Analytics](../assets/images/admin-dashboard/17_analytics_dashboard_updated.png) | Desktop |
| System Health | ![Health](../assets/images/admin-dashboard/18_system_health_monitoring.png) | Desktop |
| Admin Settings | ![Settings](../assets/images/admin-dashboard/13_admin_settings.png) | Desktop |

**Total Images:** 19 screenshots  
**Location:** `/Users/mey/MindWeave/assets/images/admin-dashboard/`

---

## Summary

**Total Screens to Implement:**

- ✅ Already Implemented: 7 core screens
- ❌ Missing: 5 critical screens (Onboarding, Profile)
- 🎨 Visual Variants: 18 screens (reference for styling)
- ⚠️ Partial: 8 screens (need completion)
- ❓ Analysis Needed: 14 screens (likely modals/overlays)

**Platform Coverage:**

- Mobile: 49/49 screens (100% coverage planned)
- Desktop: 49/49 screens (100% coverage planned)

**Next Action:** Implement Phase 1 screens (Onboarding + Profile)
