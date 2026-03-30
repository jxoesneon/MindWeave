# MindWeave - Open Source Brainwave Entrainment App

**Version:** 1.0  
**Date:** March 28, 2026  
**Status:** Draft for Review  

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [User Personas](#2-user-personas)
3. [Epics & User Stories](#3-epics--user-stories)
4. [Functional Requirements](#4-functional-requirements)
5. [Non-Functional Requirements](#5-non-functional-requirements)
6. [UI/UX Requirements](#6-uiux-requirements)
7. [Donation System Requirements](#7-donation-system-requirements)
8. [Ad Management Requirements](#8-ad-management-requirements)
9. [Backend Dashboard Requirements](#9-backend-dashboard-requirements)
10. [Appendices](#10-appendices)

---

## 1. Executive Summary

### Product Overview

Binaural Beats is an open-source, cross-platform mobile application that generates scientifically-accurate binaural beats for brainwave entrainment. The app enables users to enhance focus, improve sleep, reduce stress, and achieve meditative states through precisely generated audio frequencies.

### Key Differentiators

- **100% Open Source:** MIT licensed, community-driven development
- **Scientifically Accurate:** All presets based on peer-reviewed research
- **Truly Free:** Core functionality never paywalled
- **Ethical Monetization:** Donation-first with dormant ad system
- **Cross-Platform:** iOS, Android from single Flutter codebase

### Target Platforms

| Platform | Minimum Version | Target Version |
|----------|-----------------|----------------|
| iOS | 13.0 | 17.0+ |
| Android | API 21 (5.0) | API 34+ |
| macOS (future) | 11.0 | 14.0+ |
| Windows (future) | 10 | 11 |

---

## 2. User Personas

### Persona 1: Mindful Maria

**Demographics:** 32, yoga instructor, urban  
**Goals:** Enhance meditation practice, help students relax  
**Pain Points:** Subscription fatigue, wants offline access  
**Tech Comfort:** High  
**Quote:** *"I want something that just works without another monthly fee."*

**Behaviors:**
- Uses meditation apps 4-5x per week
- Values scientific backing
- Prefers simple, beautiful interfaces
- Willing to donate to tools she values

**Needs:**
- Quick access to Theta frequencies
- Session timer for guided classes
- Background playback reliability
- No interruptions during practice

### Persona 2: Focused Felix

**Demographics:** 24, software developer, remote worker  
**Goals:** Maintain deep focus during coding sessions  
**Pain Points:** Easily distracted, caffeine dependency  
**Tech Comfort:** Very High  
**Quote:** *"I need something I can customize and that won't spy on me."*

**Behaviors:**
- Uses productivity tools daily
- Listens to music while working
- Values open source and privacy
- Active on GitHub, contributes to OSS

**Needs:**
- Beta frequency focus presets
- Long session support (2+ hours)
- Low CPU/battery usage
- Custom frequency input

### Persona 3: Seeking Sarah

**Demographics:** 45, experiencing insomnia, suburban  
**Goals:** Fall asleep faster, improve sleep quality  
**Pain Points:** Tried medications, wants natural solution  
**Tech Comfort:** Medium  
**Quote:** *"I just want to press a button and drift off to sleep."*

**Behaviors:**
- Uses phone before bed
- Prefers simple, large buttons
- Needs clear instructions
- Values free options

**Needs:**
- One-tap sleep preset
- Automatic fade-out
- Sleep timer
- Gentle, calming UI

---

## 3. Epics & User Stories

### Epic 1: Core Audio Experience

**US-1.1:** As a user, I want to play a binaural beat preset so that I can begin my session quickly.

**Acceptance Criteria:**
- [ ] Five preset categories visible on main screen
- [ ] Tap to play with < 2 second startup
- [ ] Audio plays in background
- [ ] Notification shows current frequency

**US-1.2:** As a user, I want to customize the carrier frequency so that I can fine-tune my experience.

**Acceptance Criteria:**
- [ ] Carrier frequency slider (100-500 Hz)
- [ ] Real-time preview of changes
- [ ] Save custom setting to preset
- [ ] Visual indicator of recommended range (180-250 Hz)

**US-1.3:** As a user, I want to set a session timer so that my session ends automatically.

**Acceptance Criteria:**
- [ ] Timer presets: 5, 10, 15, 20, 30, 45, 60 minutes
- [ ] Custom timer input
- [ ] Visual countdown during session
- [ ] Gentle fade-out at end
- [ ] Optional alarm sound

**US-1.4:** As a user, I want to mix binaural beats with my own music so that I can enjoy both simultaneously.

**Acceptance Criteria:**
- [ ] Access music library (iOS/Android)
- [ ] Independent volume controls
- [ ] Binaural volume: 20-40% recommended range
- [ ] Remember last music selection

### Epic 2: Session Management

**US-2.1:** As a user, I want to save my favorite frequency combinations so that I can quickly return to them.

**Acceptance Criteria:**
- [ ] Save current settings as named preset
- [ ] View saved presets in grid/list
- [ ] Edit/delete saved presets
- [ ] Quick-play from saved list

**US-2.2:** As a user, I want to see my session history so that I can track my usage patterns.

**Acceptance Criteria:**
- [ ] List of past sessions with date/time
- [ ] Session duration displayed
- [ ] Frequency used shown
- [ ] Option to repeat session

**US-2.3:** As a user, I want to share my custom presets with others so that I can help the community.

**Acceptance Criteria:**
- [ ] Export preset as shareable code/link
- [ ] Import preset from shared code
- [ ] Share via standard system share sheet
- [ ] Preview before importing

### Epic 3: Donation & Support

**US-3.1:** As a grateful user, I want to donate to support development so that the app remains free.

**Acceptance Criteria:**
- [ ] Donation option in Settings
- [ ] Multiple amount options ($3, $5, $10, $25, custom)
- [ ] One-time and monthly options
- [ ] Multiple payment methods (Apple Pay, Google Pay, card)
- [ ] Thank you confirmation

**US-3.2:** As a donor, I want recognition for my contribution so that I feel appreciated.

**Acceptance Criteria:**
- [ ] In-app "Supporter" badge
- [ ] Name in "Supporters" section (optional)
- [ ] Special app icon option (if implemented)
- [ ] Early access to beta features (optional)

**US-3.3:** As a user, I want to understand how donations are used so that I can trust the project.

**Acceptance Criteria:**
- [ ] Transparent breakdown of costs
- [ ] Monthly funding goal display
- [ ] Current donation status
- [ ] Link to Open Collective/GitHub Sponsors

### Epic 4: Admin & Remote Configuration

**US-4.1:** As an admin, I want to enable/disable ads remotely so that I can respond to funding needs without app updates.

**Acceptance Criteria:**
- [ ] Toggle ads on/off via dashboard
- [ ] Set percentage of users affected
- [ ] Changes apply within 15 minutes
- [ ] Audit log of changes

**US-4.2:** As an admin, I want to view usage analytics so that I can understand user behavior.

**Acceptance Criteria:**
- [ ] Daily/monthly active users
- [ ] Session duration metrics
- [ ] Popular frequency bands
- [ ] Donation conversion rates
- [ ] Export data to CSV

---

## 4. Functional Requirements

### 4.1 Audio Engine Requirements

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| AU-001 | Generate pure sine wave binaural beats | P0 | Core functionality |
| AU-002 | Support five brainwave bands (Delta, Theta, Alpha, Beta, Gamma) | P0 | Scientific accuracy |
| AU-003 | Carrier frequency range: 100-500 Hz | P0 | User customization |
| AU-004 | Beat frequency precision: ±0.01 Hz | P0 | Scientific accuracy |
| AU-005 | Sample rate: 44.1 kHz minimum | P0 | Audio quality |
| AU-006 | Background audio playback | P0 | Essential UX |
| AU-007 | Gapless looping | P1 | Seamless experience |
| AU-008 | Volume fade in/out | P1 | Smooth transitions |
| AU-009 | Isochronic tone option | P2 | Alternative modality |
| AU-010 | Audio visualization (FFT) | P2 | Visual feedback |

### 4.2 Session Requirements

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| SE-001 | Session timer with presets | P0 | Core functionality |
| SE-002 | Custom timer input | P1 | Flexibility |
| SE-003 | Session pause/resume | P1 | User control |
| SE-004 | Save favorite presets | P1 | Personalization |
| SE-005 | Session history tracking | P2 | User insight |
| SE-006 | Export session audio | P3 | Advanced feature |

### 4.3 Platform Integration Requirements

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| PI-001 | Background playback on iOS/Android | P0 | Essential |
| PI-002 | Notification controls (play/pause/stop) | P0 | Standard UX |
| PI-003 | Control Center integration (iOS) | P1 | Native feel |
| PI-004 | Media session integration (Android) | P1 | Native feel |
| PI-005 | Do Not Disturb awareness | P1 | Respect user settings |
| PI-006 | Apple HealthKit Mindful Minutes | P2 | Health integration |
| PI-007 | Google Fit integration | P2 | Health integration |

---

## 5. Non-Functional Requirements

### 5.1 Performance Requirements

| ID | Requirement | Target | Critical |
|----|-------------|--------|----------|
| PF-001 | App launch time | < 3 seconds | Yes |
| PF-002 | Audio startup latency | < 500ms | Yes |
| PF-003 | UI responsiveness | 60 FPS | No |
| PF-004 | Battery usage | < 5% per hour | Yes |
| PF-005 | Memory footprint | < 150 MB | No |
| PF-006 | Offline functionality | 100% | Yes |

### 5.2 Security & Privacy Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| SC-001 | No personal data collection without consent | P0 |
| SC-002 | Anonymous analytics only | P0 |
| SC-003 | GDPR compliance | P0 |
| SC-004 | CCPA compliance | P1 |
| SC-005 | Secure donation processing | P0 |
| SC-006 | No audio data leaves device | P0 |

### 5.3 Reliability Requirements

| ID | Requirement | Target |
|----|-------------|--------|
| RL-001 | Crash-free rate | > 99.5% |
| RL-002 | Audio playback stability | No interruptions |
| RL-003 | Background playback persistence | > 99% |
| RL-004 | Remote config update time | < 15 minutes |

### 5.4 Accessibility Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| AC-001 | Screen reader support (VoiceOver/TalkBack) | P1 |
| AC-002 | Dynamic text sizing | P1 |
| AC-003 | High contrast mode | P2 |
| AC-004 | Reduced motion support | P2 |
| AC-005 | Minimum touch target: 44x44 pt | P0 |

---

## 6. UI/UX Requirements

### 6.1 Design Principles

1. **Calm & Minimal:** Interface should not compete with the experience
2. **Immediate Action:** Core function accessible in one tap
3. **Clear Feedback:** Always show what's playing and for how long
4. **Respectful:** Never interrupt a session

### 6.2 Screen Requirements

#### Main Player Screen

```
┌─────────────────────────────────────┐
│  [Settings]    Binaural Beats   [?] │
├─────────────────────────────────────┤
│                                     │
│         ┌─────────────┐             │
│         │             │             │
│         │  Visualizer │             │
│         │   (Circle)  │             │
│         │             │             │
│         └─────────────┘             │
│                                     │
│      Currently Playing: Alpha       │
│         10.0 Hz | 250 Hz            │
│                                     │
│  [Delta] [Theta] [Alpha] [Beta] [Γ] │
│                                     │
│  Carrier: [========●====] 250 Hz    │
│  Volume:  [======●======]  70%      │
│                                     │
│      Session: 15:00 remaining       │
│                                     │
│        [  ⏸ PAUSE  ]                │
│                                     │
│  [Timer] [Music] [Save] [Share]     │
└─────────────────────────────────────┘
```

#### Presets Screen

```
┌─────────────────────────────────────┐
│  ← Back        My Presets      [+]  │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐    │
│  │ 🌙 Deep Sleep    2Hz | 200Hz│    │
│  │ Used 12 times               │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ 🧘 Meditation    6Hz | 220Hz│    │
│  │ Used 8 times                │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ 💻 Focus Mode   14Hz | 300Hz│    │
│  │ Used 24 times               │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

#### Settings / Donation Screen

```
┌─────────────────────────────────────┐
│  ← Back        Support Us           │
├─────────────────────────────────────┤
│                                     │
│     🙏 Thank You for Using          │
│        Binaural Beats!              │
│                                     │
│  This app is free because of        │
│  supporters like you.               │
│                                     │
│  ┌─────────────────────────────┐    │
│  │   Monthly Goal: $500        │    │
│  │   [████████░░░░░░░░] 60%    │    │
│  │   Current: $300 from 45     │
│  │           supporters        │    │
│  └─────────────────────────────┘    │
│                                     │
│  Support with a one-time gift:      │
│  [ $3 ] [ $5 ] [ $10 ] [ $25 ]      │
│                                     │
│  Or become a monthly supporter:     │
│  [ $2/mo ] [ $5/mo ] [ $10/mo ]     │
│                                     │
│  [💳 Donate with Apple Pay]         │
│                                     │
│  [Other Payment Options]            │
│                                     │
│  [View Our Open Collective]         │
│  [See How Funds Are Used]           │
└─────────────────────────────────────┘
```

### 6.3 Color Palette

**Dark Mode (Default):**
- Background: #0D0D0F
- Surface: #1A1A1F
- Primary: #7B68EE (Medium Slate Blue)
- Secondary: #00D9C0 (Turquoise)
- Text Primary: #FFFFFF
- Text Secondary: #A0A0A0
- Accent Delta: #4A90D9
- Accent Theta: #9B59B6
- Accent Alpha: #7B68EE
- Accent Beta: #E67E22
- Accent Gamma: #E74C3C

**Light Mode:**
- Background: #F5F5F7
- Surface: #FFFFFF
- Primary: #5A4FCF
- Secondary: #00B8A3
- Text Primary: #1A1A1F
- Text Secondary: #6E6E73

---

## 7. Donation System Requirements

### 7.1 Payment Providers

| Provider | Methods | Fees | Integration |
|----------|---------|------|-------------|
| GitHub Sponsors | Card | 0% | Link out |
| Open Collective | Card, PayPal, Bank | 5-10% | Link out |
| RevenueCat | Apple Pay, Google Pay | 1% | In-app |
| Stripe | Card, Apple Pay, Google Pay | 2.9% + $0.30 | In-app |

### 7.2 In-App Purchase Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| DN-001 | One-time donation SKUs | P0 |
| DN-002 | Subscription donation SKUs | P1 |
| DN-003 | Receipt validation | P0 |
| DN-004 | Restore purchases | P1 |
| DN-005 | Transaction history | P2 |

### 7.3 Recognition Tiers

| Tier | Amount | Benefits |
|------|--------|----------|
| Contributor | Any | Badge |
| Supporter | $10+ | Badge + Name in credits |
| Advocate | $50+ | Above + Beta access |
| Champion | $100+ | Above + Roadmap input |
| Patron | $500+ | All + Personal thank you |

---

## 8. Ad Management Requirements

### 8.1 Ad Network Configuration

**Primary: Google AdMob**

| Ad Type | Implementation | Placement |
|---------|---------------|-----------|
| Banner | Bottom of non-session screens | Settings, About, History |
| Interstitial | Every N app opens | Not during sessions |
| Rewarded | Optional user opt-in | Unlock premium features (if any) |

### 8.2 Remote Config Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `ads_enabled_globally` | Boolean | false | Master ad toggle |
| `ads_user_percentage` | Integer | 0 | % of users with ads |
| `ads_banner_enabled` | Boolean | false | Show banner ads |
| `ads_interstitial_enabled` | Boolean | false | Show interstitials |
| `ads_interstitial_frequency` | Integer | 10 | Sessions between ads |
| `ads_min_sessions_before_first` | Integer | 5 | Delay first ad |
| `donation_prompt_enabled` | Boolean | true | Show donation asks |
| `donation_prompt_frequency` | Integer | 10 | Sessions between prompts |

### 8.3 User Experience Rules

1. **Never show ads during active binaural sessions**
2. **Never show ads in the first 5 minutes of app usage**
3. **Always respect "Remove Ads" purchase if implemented**
4. **Clear UI indicator when ads are enabled**
5. **Easy access to "Why am I seeing ads?" explanation**

---

## 9. Backend Dashboard Requirements

### 9.1 Authentication

| ID | Requirement | Priority |
|----|-------------|----------|
| BD-001 | Supabase Auth integration | P0 |
| BD-002 | Multi-factor authentication | P1 |
| BD-003 | Role-based access (Admin/Viewer) | P1 |
| BD-004 | Session timeout (30 min) | P1 |
| BD-005 | Audit logging | P1 |

### 9.2 Dashboard Modules

#### Remote Config Module
- View all config parameters
- Edit values with validation
- Schedule changes
- View change history
- Rollback to previous versions

#### Analytics Module
- Real-time user count
- DAU/MAU charts
- Session duration distribution
- Frequency band popularity
- Donation metrics
- Ad performance (if enabled)

#### User Management Module
- Search users by ID
- View user session history
- Manually toggle ads for user
- Export user data
- Delete user data (GDPR)

#### Preset Management Module
- View community presets
- Add official presets
- Feature/hide presets
- Moderate user submissions
- View preset usage stats

### 9.3 Dashboard Tech Stack

| Component | Technology | Reason |
|-----------|------------|--------|
| Frontend | React + Tailwind CSS | Rapid development |
| Backend API | Supabase | Existing infrastructure |
| Charts | Recharts | React-native |
| Auth | Supabase Auth | Unified with app |
| Hosting | Vercel (free tier) | Cost-effective |

---

## 10. Appendices

### Appendix A: Glossary

| Term | Definition |
|------|------------|
| Binaural Beat | Auditory illusion created by presenting two slightly different frequencies to each ear |
| Carrier Frequency | The base frequency sent to each ear (e.g., 200 Hz and 210 Hz) |
| Beat Frequency | The perceived difference between carrier frequencies (e.g., 10 Hz) |
| Brainwave Entrainment | The brain's electrical activity synchronizing to an external rhythmic stimulus |
| Isochronic Tones | Regular beats of a single tone, created by turning a tone on and off rapidly |

### Appendix B: Reference Documents

- [Neuroscience & Audio Research](../research/neuroscience_audio_research.md)
- [Market Analysis](../research/market_analysis.md)
- [Product Strategy](../research/product_strategy.md)
- [Technical Specifications](../tech_specs/technical_specifications.md)

### Appendix C: Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-03-28 | Product Team | Initial release |

---

**Document Approval:**

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Product Manager | TBD | | |
| Tech Lead | TBD | | |
| Stakeholder | TBD | | |
