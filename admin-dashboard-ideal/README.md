# MindWeave Admin Dashboard - Quick Start Guide

## Project Summary

This folder contains everything needed to build the ideal MindWeave Admin Dashboard in **Google Stitch**.

---

## What Was Gathered

### From Existing Codebase

1. **Dashboard Structure** (`/dashboard` folder)
   - 10 admin pages with full functionality
   - Supabase integration for auth and data
   - Tailwind CSS styling
   - Recharts for analytics

2. **Design System** (from Flutter main app)
   - **Colors**: Purple primary (#7B68EE), Turquoise secondary (#00D9C0)
   - **Dark Mode**: #0D0D0F background with tonal surface hierarchy
   - **Typography**: Space Grotesk headlines, Inter body
   - **Brainwave Bands**: Delta (blue), Theta (purple), Alpha (slate), Beta (orange), Gamma (red)

3. **Key Features to Port**:
   - User management with GDPR export
   - Real-time analytics (DAU/MAU)
   - Frequency band usage tracking
   - Preset management
   - Remote config
   - Audit logging
   - System health monitoring
   - Login history
   - Ad performance

---

## Files in This Folder

| File | Purpose |
|------|---------|
| `design-system-spec.md` | Complete design tokens, colors, typography, spacing |
| `construction-blueprint.md` | Step-by-step implementation guide (6 phases) |
| `package.json` | Initial project dependencies |

---

## How to Create the Stitch Project

Since the Stitch MCP server doesn't expose tools directly, you'll need to create the project using one of these methods:

### Option 1: Via Stitch Web Interface

1. Go to [Google Stitch](https://stitch.withgoogle.com/)
2. Click "Create Project"
3. Choose **React + TypeScript + Tailwind**
4. Project name: `mindweave-admin-dashboard`
5. Import the design system from the Flutter app (refer to `design-system-spec.md`)

### Option 2: Via Stitch CLI (if available)

```bash
# Install Stitch CLI (if available)
npm install -g @google/stitch-cli

# Create project
stitch create mindweave-admin-dashboard --template react-ts-tailwind

# Or use the blueprint skill
/blueprint mindweave-admin-dashboard "Create admin dashboard with MindWeave design system"
```text

### Option 3: Via Claude Code with Blueprint Skill
```text
/blueprint mindweave-admin-dashboard "Build MindWeave admin dashboard following design-system-spec.md"
```text

---

## Key Design Tokens for Stitch

### Primary Colors (Dark Mode)
```css
--background: #0D0D0F;
--surface: #131315;
--surface-container-low: #1B1B1D;
--primary: #7B68EE;
--secondary: #00D9C0;
--on-surface: #E5E1E4;
--on-surface-variant: #C9C4D6;
--outline-variant: #474554;
```text

### Brainwave Band Colors
```css
--delta: #4A90D9;
--theta: #9B59B6;
--alpha: #7B68EE;
--beta: #E67E22;
--gamma: #E74C3C;
```text

### Fonts
- **Headlines**: Space Grotesk (Google Fonts)
- **Body**: Inter (Google Fonts)

---

## Project Structure (Recommended)

```text
my-app/
├── app/
│   ├── (auth)/login/page.tsx
│   ├── (dashboard)/
│   │   ├── layout.tsx          # Sidebar + main content
│   │   ├── page.tsx            # Dashboard (stats)
│   │   ├── users/page.tsx      # User management
│   │   ├── users/[id]/page.tsx # User details
│   │   ├── analytics/page.tsx  # Charts
│   │   ├── presets/page.tsx    # Preset management
│   │   ├── config/page.tsx     # Remote config
│   │   ├── audit/page.tsx      # Audit log
│   │   ├── health/page.tsx     # System health
│   │   ├── login-history/      # Login history
│   │   └── ads/page.tsx        # Ad performance
│   └── layout.tsx
├── components/
│   ├── layout/Sidebar.tsx
│   ├── layout/TopBar.tsx
│   ├── data/StatCard.tsx
│   ├── data/DataTable.tsx
│   ├── data/ChartContainer.tsx
│   └── ...
├── hooks/
│   ├── useAuth.ts
│   ├── useAnalytics.ts
│   ├── useUsers.ts
│   └── ...
├── lib/
│   ├── supabase.ts
│   ├── theme.ts
│   └── utils.ts
└── types/
    └── database.ts
```text

---

## Supabase Integration

The dashboard connects to Supabase for:
- **Auth**: Admin login with role checking
- **Database**: Users, sessions, presets, donations
- **Realtime**: Active user count
- **Analytics**: Views for DAU/MAU

### Required Tables/Views
- `users` - User accounts
- `sessions` - Session history
- `presets` - Binaural presets
- `donations` - Donation records
- `user_roles` - Admin/viewer roles
- `audit_logs` - Admin actions
- `remote_config` - Feature flags

---

## Next Steps

1. **Create Stitch Project** using one of the methods above
2. **Import Design System** - Copy color tokens from `design-system-spec.md`
3. **Configure Fonts** - Add Space Grotesk and Inter
4. **Build Pages** - Follow the 6-phase plan in `construction-blueprint.md`
5. **Connect Supabase** - Add env vars and client setup
6. **Test & Deploy**

---

## Design Principles (MindWeave Ethos)

1. **Tonal Surfaces**: Use the surface container hierarchy, not flat grays
2. **No Hard Borders**: Use tonal separation with subtle outlineVariant
3. **Purple + Turquoise**: Primary actions in purple, success in turquoise
4. **Space Grotesk Headlines**: Geometric, editorial feel
5. **Inter Body**: Human-readable, clean
6. **Soft Corners**: 16px for buttons, 20px for cards
7. **Aura Glows**: Purple glow on hover/active, not shadows
8. **Dark First**: Design for dark mode (#0D0D0F background)

---

## Resources

- **Existing Dashboard**: `/dashboard` folder in the main repo
- **Flutter Theme**: `/lib/core/theme/` for reference
- **Icons**: Lucide React (already specified)
- **Charts**: Recharts
- **UI Components**: shadcn/ui via Stitch

---

## Questions?

Refer to the detailed specifications:
- **Design System**: `design-system-spec.md` (600+ lines)
- **Construction Plan**: `construction-blueprint.md` (700+ lines)
