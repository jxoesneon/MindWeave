# Product Strategy & Roadmap

## Strategic Vision

**Mission:** Democratize access to scientifically-backed brainwave entrainment technology through an open-source, cross-platform application that prioritizes user wellbeing over profit.

**Vision:** Become the definitive open-source binaural beats application, setting the standard for ethical monetization, scientific accuracy, and community-driven development.

---

## Core Value Propositions

### 1. Scientific Integrity
- All frequency presets based on peer-reviewed research
- Transparent documentation of scientific sources
- No pseudoscientific claims or exaggerated benefits

### 2. True Open Source
- Full source code available under MIT license
- Community contributions welcomed and credited
- No proprietary "black box" algorithms

### 3. Ethical Monetization
- Core functionality always free
- Donation-first sustainability model
- Ads strictly optional and off-by-default

### 4. Cross-Platform Unity
- Single codebase, all major platforms
- Consistent experience across devices
- No platform lock-in

---

## Feature Roadmap

### Phase 1: Foundation (MVP) - Months 1-3

**Core Audio Engine**
- [ ] Real-time binaural beat synthesis
- [ ] Five brainwave band presets (Delta, Theta, Alpha, Beta, Gamma)
- [ ] Carrier frequency selection (100-500 Hz)
- [ ] Pure sine wave generation
- [ ] Gapless looping

**Basic UI/UX**
- [ ] Clean, minimal interface
- [ ] Frequency selector with visual band indicators
- [ ] Play/pause/stop controls
- [ ] Session timer (5, 10, 15, 20, 30, 45, 60 min)
- [ ] Dark/light theme

**Platform Basics**
- [ ] iOS support (iOS 13+)
- [ ] Android support (API 21+)
- [ ] Background audio playback
- [ ] Notification controls

**Infrastructure**
- [ ] Supabase backend setup
- [ ] Anonymous user tracking (optional)
- [ ] Remote config for feature flags
- [ ] Crash reporting (Sentry - free tier)

### Phase 2: Enhancement - Months 4-6

**Advanced Audio**
- [ ] Isochronic tones option
- [ ] Background music mixing (user's own music)
- [ ] Volume automation/fading
- [ ] Custom frequency input (decimal precision)
- [ ] Stereo balance control

**User Experience**
- [ ] Save favorite presets
- [ ] Session history
- [ ] Quick-start widgets (home screen)
- [ ] Onboarding tutorial

**Donation System**
- [ ] In-app donation flow
- [ ] GitHub Sponsors integration
- [ ] Open Collective link
- [ ] "Supporter" badge recognition
- [ ] Transparent funding goals display

**Community**
- [ ] Share presets (export/import)
- [ ] Community preset repository
- [ ] In-app preset browser

### Phase 3: Advanced Features - Months 7-9

**Visualization**
- [ ] Real-time waveform display
- [ ] Brainwave band visualization
- [ ] Session progress indicator
- [ ] Breathing guide overlay

**Smart Features**
- [ ] Time-based recommendations (sleep time = Delta)
- [ ] Session scheduling
- [ ] Smart alarms (wake during light phase)
- [ ] Usage statistics (local only)

**Integrations**
- [ ] Apple HealthKit (Mindful Minutes)
- [ ] Google Fit integration
- [ ] Shortcuts/Siri integration (iOS)
- [ ] Tasker integration (Android)

**Accessibility**
- [ ] VoiceOver/TalkBack support
- [ ] Dynamic text sizing
- [ ] High contrast mode
- [ ] Reduced motion option

### Phase 4: Scale & Refinement - Months 10-12

**Advanced Audio**
- [ ] Multi-layer frequency sessions
- [ ] Frequency ramping (smooth transitions)
- [ ] Export session audio (WAV/MP3)
- [ ] Advanced EQ controls

**Social Features**
- [ ] User accounts (optional)
- [ ] Cloud sync for presets
- [ ] Community ratings for presets
- [ ] Curated preset collections

**Monetization Decision Point**
- [ ] Evaluate donation sustainability
- [ ] If needed: implement dormant ad system
- [ ] Premium features consideration (only if community approves)

**Enterprise/Professional**
- [ ] Therapist/practitioner dashboard
- [ ] Client session tracking
- [ ] White-label option
- [ ] API access

---

## UX Strategy: Frictionless Donations

### Design Principles

1. **No Interruption:** Donation prompts never interrupt sessions
2. **No Guilt:** Messaging focuses on community support, not obligation
3. **No Paywall:** All features free; donations purely voluntary
4. **Transparency:** Clear communication of how funds are used

### Donation Touchpoints

| Location | Timing | Approach |
|----------|--------|----------|
| Settings | User-initiated | "Support the Project" section with options |
| Post-Session | After 10+ sessions | Gentle "Enjoying the app?" message |
| About Page | User-initiated | Full transparency on costs and goals |
| Anniversary | Yearly | "One year of free sessions" celebration + ask |

### Donation Options

**One-Time:**
- $3 (Coffee)
- $5 (Lunch)
- $10 (Dinner)
- $25 (Sponsor)
- Custom amount

**Recurring (Monthly):**
- $2 (Supporter)
- $5 (Advocate)
- $10 (Champion)
- $25 (Patron)

### Recognition System

| Level | Threshold | Recognition |
|-------|-----------|-------------|
| Contributor | Any donation | In-app badge |
| Supporter | $10+ total | Badge + name in credits |
| Advocate | $50+ total | Above + early feature access |
| Champion | $100+ total | Above + input on roadmap |
| Patron | $500+ total | All above + personal thank you |

---

## Ad System Strategy: The Dormant Model

### Core Philosophy

Ads are a **safety valve**, not a revenue strategy. They exist to ensure sustainability if donations are insufficient, but are never enabled without community transparency.

### Technical Architecture

```
Remote Config (Supabase)
├── ads_enabled_globally: false
├── ads_enabled_per_user: false
├── ad_user_percentage: 0
└── ad_network_config: {...}
```

### Ad Toggle States

| State | Description | Trigger |
|-------|-------------|---------|
| **Dormant (Default)** | No ads, no ad code loaded | Initial state |
| **Enabled (Global)** | All users see ads | Financial necessity |
| **Enabled (Partial)** | Percentage of users see ads | A/B testing or gradual rollout |
| **User Opt-In** | User chooses to enable ads | User wants to support without donating |

### Ad Implementation Rules

1. **Off by Default:** Fresh installs have ads completely disabled
2. **No Pre-loading:** Ad SDKs only initialize if enabled via remote config
3. **Non-Intrusive:** Only banner ads in non-session screens
4. **No Session Interruption:** Never show ads during active binaural sessions
5. **Transparent:** Clear UI indication when ads are enabled
6. **Reversible:** Users can disable ads (if not globally forced)

### Ad Network Selection

**Primary: Google AdMob**
- Flutter official plugin
- Highest fill rates
- Reliable payments
- Free to integrate

**Fallback: Unity Ads**
- Alternative if AdMob issues
- Good for audio apps
- Competitive CPM

### User Communication

**If Ads Become Necessary:**
```
"To keep Binaural Beats free for everyone, we've enabled 
non-intrusive ads. These never appear during your sessions. 
You can disable ads anytime by becoming a supporter."
```

---

## Backend Admin Dashboard Requirements

### Dashboard Access

**Authentication:**
- Supabase Auth with MFA
- Role-based access (Admin, Viewer)
- Audit logging

### Dashboard Features

#### 1. Remote Config Management

| Setting | Type | Description |
|---------|------|-------------|
| `ads_enabled_globally` | Boolean | Master ad toggle |
| `ads_user_percentage` | Integer | % of users with ads (0-100) |
| `ad_banner_enabled` | Boolean | Banner ad toggle |
| `ad_interstitial_enabled` | Boolean | Interstitial ad toggle |
| `ad_interstitial_frequency` | Integer | Show every N sessions |
| `min_sessions_before_ads` | Integer | Delay before showing ads |
| `donation_prompt_enabled` | Boolean | Show donation asks |
| `donation_prompt_frequency` | Integer | Show every N sessions |

#### 2. Analytics Overview

**Metrics:**
- Daily/Monthly Active Users (DAU/MAU)
- Session count and duration
- Frequency band popularity
- Donation conversion rate
- Ad impression revenue (if enabled)

#### 3. User Management

**Features:**
- Search users by ID
- View user session history
- Manually enable/disable ads for user
- Export user data (GDPR compliance)

#### 4. Preset Management

**Features:**
- Add/edit community presets
- Feature/hide presets
- View preset usage stats
- Moderate user submissions

### Dashboard UI Mockup

```
┌─────────────────────────────────────────────────────────────┐
│  Binaural Beats Admin Dashboard                    [Logout] │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   DAU: 1.2K │  │  Donations  │  │  Ad Revenue │         │
│  │   ↑ 12%     │  │   $245/mo   │  │   $0 (off)  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
├─────────────────────────────────────────────────────────────┤
│  [Remote Config] [Analytics] [Users] [Presets] [Settings]   │
├─────────────────────────────────────────────────────────────┤
│  Remote Configuration                                       │
│  ─────────────────────────────────────────────────────────  │
│  ☑ Enable Ads Globally                    [Save Changes]    │
│  ☐ Enable Ads for Percentage of Users                       │
│     Percentage: [____] 0-100%                               │
│  ☑ Enable Donation Prompts                                  │
│     Frequency: Every [10] sessions                          │
│  ─────────────────────────────────────────────────────────  │
│  Last Updated: 2026-03-28 14:32 UTC by admin@example.com    │
└─────────────────────────────────────────────────────────────┘
```

---

## Success Metrics & KPIs

### User Engagement

| Metric | Target (6mo) | Target (12mo) |
|--------|--------------|---------------|
| Monthly Active Users | 5,000 | 20,000 |
| Average Session Duration | 15 min | 18 min |
| Sessions per user/week | 3 | 4 |
| Day 7 Retention | 25% | 35% |
| Day 30 Retention | 15% | 25% |

### Financial Sustainability

| Metric | Target (6mo) | Target (12mo) |
|--------|--------------|---------------|
| Monthly Donations | $200 | $500 |
| Donation Conversion Rate | 1.5% | 2.5% |
| Average Donation | $8 | $10 |
| Operating Costs | $25 | $50 |
| Net Sustainability | +$175 | +$450 |

### Community Health

| Metric | Target (6mo) | Target (12mo) |
|--------|--------------|---------------|
| GitHub Stars | 300 | 1,500 |
| Contributors | 5 | 15 |
| Community Presets | 50 | 200 |
| App Store Rating | 4.5 | 4.7 |

---

## Risk Assessment & Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Insufficient donations | Medium | High | Dormant ad system ready |
| Flutter audio limitations | Low | High | FFI fallback to C++ |
| Negative reviews | Low | Medium | Responsive support, rapid fixes |
| Scope creep | Medium | Medium | Strict MVP focus |
| Platform policy changes | Low | Medium | Stay updated, adaptable |

---

## Conclusion

This product strategy prioritizes user trust, scientific integrity, and sustainable open-source development. The combination of frictionless donations and a dormant ad system creates a responsible path to long-term viability while maintaining the app's core values.

**Key Decisions:**
1. Supabase for backend (generous free tier, open source)
2. Flutter for cross-platform (single codebase, excellent audio libraries)
3. Donation-first with dormant ads (ethical monetization)
4. Community-driven feature prioritization (open source values)
