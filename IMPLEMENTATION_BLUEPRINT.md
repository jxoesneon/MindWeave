# MindWeave Flutter Implementation Blueprint

**Objective:** Full implementation of the MindWeave binaural beats meditation app using Atomic Design principles, ensuring visual fidelity to the Stitch design system while reusing existing backend infrastructure.

**Status:** Audit Complete, Planning Phase  
**Last Updated:** 2026-04-01

---

## Executive Summary

### Current State Audit

| Aspect | Status | Assessment |
| -------- | -------- | ------------ |
| **Core Architecture** | ✅ Strong | Riverpod + Material 3, proper DI |
| **Audio Engine** | ✅ Complete | flutter_soloud, binaural generation |
| **Backend (Supabase)** | ✅ Connected | Auth, favorites, sessions |
| **Theme System** | ✅ Excellent | Full Material 3, glassmorphism |
| **Player Screen** | 🟡 Partial | Works, needs atomic refactor |
| **Library Screen** | 🟡 Partial | Basic functionality |
| **Navigation** | 🟡 Partial | Mobile OK, desktop needs work |
| **Atomic Components** | ❌ Missing | No atoms/molecules/organisms |
| **Missing Screens** | ❌ 25+ | Onboarding, Profile, Payment, etc. |
| **Testing** | 🟡 Partial | Some unit tests exist |

### Implementation Strategy

1. **Foundation First:** Atomic Design System (atoms → molecules → organisms)
2. **Reuse Maximum:** Keep audio engine, models, backend, theme
3. **Refactor Core:** Break down existing screens into atomic components
4. **Build Missing:** Implement 25+ screens from COMPONENT_INVENTORY.md
5. **Polish Last:** Animations, micro-interactions, testing

---

## Atomic Design Architecture

### Directory Structure (New)

```text
lib/
├── core/
│   ├── atoms/                    # NEW: Atomic components
│   │   ├── buttons/
│   │   │   ├── primary_button.dart
│   │   │   ├── secondary_button.dart
│   │   │   ├── icon_button.dart
│   │   │   └── icon_text_button.dart
│   │   ├── inputs/
│   │   │   ├── text_field.dart
│   │   │   ├── slider.dart
│   │   │   └── search_field.dart
│   │   ├── surfaces/
│   │   │   ├── glass_container.dart
│   │   │   ├── tonal_card.dart
│   │   │   └── bottom_sheet.dart
│   │   ├── feedback/
│   │   │   ├── snackbar.dart
│   │   │   ├── badge.dart
│   │   │   └── shimmer.dart
│   │   └── typography/
│   │       ├── display_text.dart
│   │       ├── headline_text.dart
│   │       └── body_text.dart
│   ├── molecules/                # NEW: Component combinations
│   │   ├── preset_card.dart
│   │   ├── session_card.dart
│   │   ├── band_badge.dart
│   │   ├── stat_row.dart
│   │   ├── timer_chip.dart
│   │   ├── filter_chips.dart
│   │   ├── list_tile.dart
│   │   └── empty_state.dart
│   ├── organisms/                # NEW: Complex sections
│   │   ├── player_visualizer.dart
│   │   ├── preset_grid.dart
│   │   ├── session_list.dart
│   │   ├── stats_dashboard.dart
│   │   ├── navigation_shell.dart
│   │   ├── audio_controls.dart
│   │   └── frequency_selector.dart
│   ├── templates/                # NEW: Page layouts
│   │   ├── desktop_layout.dart
│   │   ├── mobile_layout.dart
│   │   ├── modal_layout.dart
│   │   └── responsive_layout.dart
│   └── pages/                    # NEW: Screen implementations
│       ├── sanctuary/
│       ├── library/
│       ├── frequencies/
│       ├── journals/
│       ├── settings/
│       ├── profile/
│       ├── onboarding/
│       └── payment/
```text

### Design Tokens Mapping

| COMPONENT_INVENTORY Token | Flutter Implementation |
|---------------------------|----------------------|
| `surfaceContainerLowest` | `AppColors.surfaceContainerLowest` |
| `primary` | `AppColors.primary` |
| `display-large` | `AppTypography.displayLarge` |
| `space-4` | `SpacingTokens.medium` (16px) |
| `radius-lg` | `BorderRadiusTokens.large` (12px) |
| `shadow-3` | `ShadowTokens.cardHover` |

---

## Phase-by-Phase Implementation Plan

### Phase 1: Atomic Design System Foundation
**Priority:** HIGH | **Est. Time:** 2-3 sessions | **Dependencies:** None

#### Step 1.1: Create Spacing & Border Tokens
```dart
// lib/core/tokens/spacing_tokens.dart
class SpacingTokens {
  static const double xsmall = 4;    // space-1
  static const double small = 8;     // space-2
  static const double medium = 16;   // space-4
  static const double large = 24;    // space-6
  static const double xlarge = 32;   // space-8
}
```text

#### Step 1.2: Create Border Radius Tokens
```dart
// lib/core/tokens/border_radius_tokens.dart
class BorderRadiusTokens {
  static const double sm = 4;    // radius-sm
  static const double md = 8;    // radius-md
  static const double lg = 12;   // radius-lg
  static const double xl = 16;   // radius-xl
  static const double full = 9999; // radius-full
}
```text

#### Step 1.3: Create Shadow Tokens
```dart
// lib/core/tokens/shadow_tokens.dart
class ShadowTokens {
  static BoxShadow get cardRest => BoxShadow(
    color: AppColors.primary.withAlpha(25),
    blurRadius: 10,
    spreadRadius: 0,
  );
  static BoxShadow get cardHover => BoxShadow(
    color: AppColors.primary.withAlpha(51),
    blurRadius: 20,
    spreadRadius: 2,
  );
}
```text

#### Step 1.4: Create Atoms
- `MwPrimaryButton` - Gradient fill, pill shape
- `MwSecondaryButton` - Ghost border
- `MwIconButton` - Circular, ripple effect
- `MwTextField` - Ghost border on focus
- `MwSlider` - Aura glow on thumb
- `MwChip` - Pill shape, tonal background
- `MwCard` - Tonal nesting, soft corners
- `MwGlassContainer` - Glass morphism
- `MwTonalContainer` - Surface hierarchy

**Verification:**
- All atoms render correctly in Storybook-like widget tests
- Match design tokens from COMPONENT_INVENTORY.md
- Work in both light and dark themes

---

### Phase 2: Molecules & Organisms
**Priority:** HIGH | **Est. Time:** 2-3 sessions | **Dependencies:** Phase 1

#### Step 2.1: Create Molecules
- `PresetCard` - Cover image, title, band badge, hover overlay
- `SessionCard` - Date, preset name, duration, mood rating
- `BandBadge` - Color-coded chip (Delta/Theta/Alpha/Beta/Gamma)
- `StatRow` - Icon + label + value
- `TimerChip` - Quick duration selector
- `FilterChips` - Horizontal scrollable chips
- `MwListTile` - Leading icon, title, subtitle, trailing action
- `EmptyState` - Illustration + CTA

#### Step 2.2: Create Organisms
- `PlayerVisualizer` - Frequency visualization with animation
- `PresetGrid` - Responsive grid with hover states
- `SessionList` - Grouped by date with dividers
- `StatsDashboard` - Metrics cards + charts
- `AudioControls` - Play/pause + sliders section
- `FrequencySelector` - Brainwave band tabs

**Verification:**
- Each molecule/organism is reusable across screens
- Implements all states (default, hover, active, disabled, loading)
- Responsive behavior works on mobile and desktop

---

### Phase 3: Navigation Shell Refactor
**Priority:** HIGH | **Est. Time:** 1-2 sessions | **Dependencies:** Phase 1-2

#### Step 3.1: Desktop Navigation Shell
```dart
// lib/core/organisms/navigation/desktop_shell.dart
class DesktopShell extends ConsumerWidget {
  final Widget leftPanel;    // Library/Community
  final Widget centerPanel;  // Player (fixed width)
  final Widget rightPanel;   // Frequencies/Journal
  
  // Draggable panel widths
  // Collapsible sidebars
  // Top app bar with search
}
```text

#### Step 3.2: Mobile Navigation Shell
```dart
// lib/core/organisms/navigation/mobile_shell.dart
class MobileShell extends ConsumerStatefulWidget {
  // Bottom tab bar (existing, needs atomic refactor)
  // IndexedStack for state preservation
}
```text

#### Step 3.3: Router Integration
- Implement go_router for deep linking
- Route definitions matching UX_FLOW_MAPPING.md
- Nested navigation for desktop

**Verification:**
- Navigation works on both mobile and desktop
- State preserved across tab switches
- Deep links work correctly

---

### Phase 4: Sanctuary/Player Refactor
**Priority:** HIGH | **Est. Time:** 2-3 sessions | **Dependencies:** Phase 1-3

#### Step 4.1: Refactor Existing Player
**Keep:**
- Audio engine integration (flutter_soloud)
- State management (Riverpod)
- Visualizer logic

**Refactor:**
- Extract `_FrequencyVisualizer` → `PlayerVisualizer` organism
- Extract `_PlaybackControls` → `AudioControls` organism
- Extract `_ControlSlider` → `MwSlider` atom
- Extract `_PresetCard` → `PresetCard` molecule
- Extract `_NoiseMixer` → `AudioControls` organism

#### Step 4.2: Desktop Player Layout
- Three-panel layout per COMPONENT_INVENTORY.md
- Left: Frequency presets list
- Center: Main player with visualizer
- Right: Controls & mixer

#### Step 4.3: Mobile Player Layout
- Stack-based layout
- Bottom sheet for library
- Modal for timer picker

**Verification:**
- Audio playback works
- Visualizer animates
- All controls functional
- Matches design screenshots

---

### Phase 5: Library & Community Screens
**Priority:** HIGH | **Est. Time:** 2 sessions | **Dependencies:** Phase 1-3

#### Step 5.1: Library Screen
**Existing:** `lib/features/favorites/library_screen.dart`

**Refactor:**
- Use `PresetCard` molecule
- Use `FilterChips` molecule
- Add `EmptyState` molecule
- Add desktop grid layout
- Add detail panel (desktop)

#### Step 5.2: Community Presets Screen
**New Implementation**
- Grid of community presets
- Search bar
- Filter by tags
- Sort options (trending, newest, most played)
- Author avatars + social metrics

**Verification:**
- Favorites load from Supabase
- Community presets fetch correctly
- Search and filter work
- Save to favorites works

---

### Phase 6: Frequencies & Education
**Priority:** HIGH | **Est. Time:** 1-2 sessions | **Dependencies:** Phase 1-3

#### Step 6.1: Frequencies Explorer
**Existing:** `lib/features/frequencies/frequencies_screen.dart`

**Enhance:**
- Sticky band selector (Delta/Theta/Alpha/Beta/Gamma)
- Educational content sections
- Benefit cards
- Brainwave chart
- Preset recommendations
- Play sample button

#### Step 6.2: Science of Binaural Beats Article
- Long-form educational content
- Interactive diagrams
- Research citations

**Verification:**
- All 5 brainwave bands documented
- Educational content accurate
- Interactive elements work

---

### Phase 7: Journals & Session History
**Priority:** HIGH | **Est. Time:** 2 sessions | **Dependencies:** Phase 1-3

#### Step 7.1: Session History Screen
**Existing:** `lib/features/history/session_history_screen.dart`

**Enhance:**
- Calendar view (GitHub-style grid)
- List view with grouping
- Stats sidebar (desktop)
- Mood ratings
- Session detail panel
- Export functionality

#### Step 7.2: Journal Entry
- Notes text area
- Mood selector (emoji)
- Quick tags
- Save/edit functionality

**Verification:**
- Sessions load from Supabase
- Calendar shows session dots
- Export generates file

---

### Phase 8: Settings & Profile
**Priority:** MEDIUM | **Est. Time:** 2 sessions | **Dependencies:** Phase 1-3

#### Step 8.1: Settings Screen
**Existing:** `lib/features/settings/settings_screen.dart`

**Enhance:**
- Three-panel layout (desktop)
- Settings categories sidebar
- Audio settings section
- Notification settings
- Appearance settings
- Contextual help panel

#### Step 8.2: Profile Screen (NEW)
- Profile header (avatar, name, member since)
- Stats row (sessions, hours, streak)
- Achievements section
- Public presets (if creator)
- Activity feed

#### Step 8.3: Edit Profile (NEW)
- Avatar upload
- Display name field
- Bio field
- Privacy toggles

**Verification:**
- Settings persist
- Profile updates to Supabase
- Avatar upload works

---

### Phase 9: Onboarding & Auth
**Priority:** MEDIUM | **Est. Time:** 2 sessions | **Dependencies:** Phase 1-3

#### Step 9.1: Welcome Screen (NEW)
- Gradient background with particles
- Logo + tagline
- Feature highlights
- Get Started / Sign In buttons

#### Step 9.2: Onboarding Flow (NEW)
- 4-slide carousel
- What are binaural beats?
- Brainwave bands explanation
- Your journey tracking
- Community (optional)

#### Step 9.3: Permission Requests (NEW)
- Notification permission
- Audio permission (required)
- Health data permission (optional)

**Verification:**
- First launch shows onboarding
- Permissions requested appropriately
- Can skip/complete flow

---

### Phase 10: Health Stats & Streaks
**Priority:** MEDIUM | **Est. Time:** 2 sessions | **Dependencies:** Phase 1-3, 8

#### Step 10.1: Health Dashboard (NEW)
- Key metrics row (sessions, hours, streak)
- Frequency bar chart
- Session line chart
- AI insights card

#### Step 10.2: Streaks & Achievements (NEW)
- Current streak (large card)
- GitHub-style calendar grid
- Achievements grid (locked/unlocked)
- Category tabs (All/Sessions/Exploration/Community)

#### Step 10.3: Weekly/Monthly Reports (NEW)
- Month selector
- Comparison cards
- Daily breakdown chart
- Export PDF button

**Verification:**
- Health data syncs
- Streaks calculate correctly
- Charts render properly

---

### Phase 11: Payment & Legal
**Priority:** MEDIUM | **Est. Time:** 2-3 sessions | **Dependencies:** Phase 1-3

#### Step 11.1: Support Sanctuary (NEW)
- Funding goal banner
- One-time contribution chips
- Monthly support tier cards
- Cryptocurrency selector
- QR code display

#### Step 11.2: Credit Card Payment (NEW)
- Card form (number, expiry, CVV)
- Order summary
- Secure badge
- Apple Pay / Google Pay buttons

#### Step 11.3: Contribution Confirmed (NEW)
- Success animation
- Thank you message
- Impact statement
- Share buttons

#### Step 11.4: Legal Screens (NEW)
- Privacy Policy
- Terms of Service
- Open Source Licenses
- Table of contents (sticky)
- Effective date banner

**Verification:**
- Payments process correctly
- Receipts generated
- Legal content accurate

---

### Phase 12: Timer & Session Management
**Priority:** MEDIUM | **Est. Time:** 1-2 sessions | **Dependencies:** Phase 1-3

#### Step 12.1: Timer Overlay (NEW)
- Bottom sheet (mobile) / Popover (desktop)
- Quick duration chips
- Custom duration picker
- Fade options toggles
- Active timer display

#### Step 12.2: Active Session Mini Player (NEW)
- Collapsed mode (mini bar)
- Expanded mode (notification style)
- Progress ring
- Time remaining

#### Step 12.3: Session Complete (NEW)
- Success modal
- Duration display
- Mood check-in
- Notes prompt
- Quick tags

**Verification:**
- Timer counts down correctly
- Audio fades at end
- Session saves to history

---

## Backend Reuse Strategy

### Existing Supabase Tables (Confirmed Working)
| Table | Status | Reuse Plan |
|-------|--------|------------|
| `user_sessions` | ✅ | Keep as-is |
| `public_favorites` | ✅ | Keep as-is |
| `donations` | ✅ | Keep as-is |
| `subscription_tiers` | ✅ | Keep as-is |
| `profiles` | ✅ | Extend for new fields |

### Existing Repository Layer
| File | Status | Action |
|------|--------|--------|
| `favorites_repository.dart` | ✅ | Keep, extend |
| `session_repository.dart` | ✅ | Keep |
| `presets_provider.dart` | ✅ | Keep |

### Required Backend Extensions
- Profiles table: Add avatar_url, bio, privacy_settings
- Achievements table: New table for gamification
- Payment webhooks: Stripe/Apple Pay/Google Pay integration

---

## Testing Strategy

### Unit Tests (Keep Existing)
- `binaural_calculator_test.dart`
- `brainwave_preset_test.dart`
- `favorites_repository_test.dart`

### Widget Tests (New)
- Atom components render correctly
- Molecules handle all states
- Organisms integrate properly

### Integration Tests (Enhance)
- `audio_controller_test.dart` - Audio playback flow
- `favorites_controller_test.dart` - CRUD operations
- `session_history_test.dart` - Session recording flow

### Golden Tests (New)
- Screenshot comparison for key screens
- Match design system exactly

---

## Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Audio engine conflicts | HIGH | Keep existing, extensive testing |
| Performance with 50+ screens | MEDIUM | Lazy loading, code splitting |
| Design drift | MEDIUM | Golden tests, design review |
| Supabase rate limits | LOW | Implement caching |
| Platform differences | MEDIUM | Responsive layouts, platform checks |

---

## Success Criteria

- [ ] All 46 functional screens implemented
- [ ] Atomic Design system with 20+ atoms
- [ ] 30+ molecules
- [ ] 15+ organisms
- [ ] 80%+ widget test coverage for atoms/molecules
- [ ] All integration tests passing
- [ ] Visual match to Stitch designs (golden tests)
- [ ] Audio engine fully functional
- [ ] Backend integration working
- [ ] iOS/Android/Desktop builds passing

---

## Next Steps

1. **Start Phase 1:** Create atomic design tokens and atoms
2. **Create widget showcase:** Storybook-like preview of components
3. **Parallel tracks:** UI components + Screen implementations
4. **Daily verification:** Run existing tests, ensure no regressions
5. **Weekly review:** Compare against COMPONENT_INVENTORY.md

---

**Document Version:** 1.0  
**Owner:** Implementation Team  
**Review Cycle:** Weekly during implementation
