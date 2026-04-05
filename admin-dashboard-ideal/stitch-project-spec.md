# MindWeave Admin Dashboard - Stitch Project Specification

## Project Name: mindweave-admin-dashboard
## Template: React + TypeScript + Tailwind CSS
## Dark Mode: Enabled by default

---

## EXACT DESIGN SYSTEM (From Stitch Export)

### Tailwind Config - Colors

```javascript

colors: {
  // Primary - Cyan/Turquoise
  "primary": "#2fd9f4",
  "primary-container": "#000608",
  "primary-fixed": "#a2eeff",
  "primary-fixed-dim": "#2fd9f4",
  "on-primary": "#00363e",
  "on-primary-container": "#008395",
  "on-primary-fixed": "#001f25",
  "on-primary-fixed-variant": "#004e5a",
  "surface-tint": "#2fd9f4",
  "inverse-primary": "#006877",
  
  // Secondary - Purple/Violet
  "secondary": "#d0bcff",
  "secondary-container": "#571bc1",
  "secondary-fixed": "#e9ddff",
  "secondary-fixed-dim": "#d0bcff",
  "on-secondary": "#3c0091",
  "on-secondary-container": "#c4abff",
  "on-secondary-fixed": "#23005c",
  "on-secondary-fixed-variant": "#5516be",
  
  // Tertiary - Gold
  "tertiary": "#e9c349",
  "tertiary-container": "#080500",
  "tertiary-fixed": "#ffe088",
  "tertiary-fixed-dim": "#e9c349",
  "on-tertiary": "#3c2f00",
  "on-tertiary-container": "#917400",
  "on-tertiary-fixed": "#241a00",
  "on-tertiary-fixed-variant": "#574500",
  
  // Surfaces
  "background": "#131315",
  "surface": "#131315",
  "surface-dim": "#131315",
  "surface-bright": "#3a393a",
  "surface-container-lowest": "#0e0e0f",
  "surface-container-low": "#1c1b1d",
  "surface-container": "#201f21",
  "surface-container-high": "#2a2a2b",
  "surface-container-highest": "#353436",
  "surface-variant": "#353436",
  
  // Content
  "on-surface": "#e5e1e3",
  "on-surface-variant": "#c8c5ca",
  "on-background": "#e5e1e3",
  "inverse-surface": "#e5e1e3",
  "inverse-on-surface": "#313032",
  
  // Outlines
  "outline": "#919095",
  "outline-variant": "#47464a",
  
  // Error
  "error": "#ffb4ab",
  "error-container": "#93000a",
  "on-error": "#690005",
  "on-error-container": "#ffdad6"
}
```text

### Tailwind Config - Font Family
```javascript
fontFamily: {
  "headline": ["Space Grotesk"],
  "body": ["Inter"],
  "label": ["Space Grotesk"]
}
```text

### Tailwind Config - Border Radius
```javascript
borderRadius: {
  "DEFAULT": "0.125rem",  // 2px
  "lg": "0.25rem",        // 4px
  "xl": "0.5rem",         // 8px
  "full": "0.75rem"       // 12px
}
```text

### Google Fonts to Load
- Space Grotesk (weights: 300, 400, 500, 600, 700)
- Inter (weights: 300, 400, 500, 600)

---

## PAGES TO CREATE

### 1. Dashboard (Home)
**Route**: `/`
**Description**: Admin dashboard with overview statistics

**Components**:
- Stats Grid (7 cards):
  - Total Users (with Users icon)
  - Active Today (with Activity icon)
  - Active This Month (with TrendingUp icon)
  - Total Sessions (with Clock icon)
  - Avg Session Duration (with Clock icon)
  - Active Now - Realtime (with Radio icon)
  - Donations (with Heart icon)
- Frequency Bands Section (5 columns):
  - Delta (Blue #4A90D9) - Deep Sleep
  - Theta (Purple #9B59B6) - Meditation
  - Alpha (Slate #7B68EE) - Relaxation
  - Beta (Orange #E67E22) - Focus
  - Gamma (Red #E74C3C) - Peak Performance

### 2. Users
**Route**: `/users`
**Description**: User management with search and pagination

**Components**:
- Search bar (debounced 300ms)
- Users table with columns:
  - User ID (truncated)
  - Anonymous status
  - Device type
  - App version
  - Created date
  - Last active
  - Actions (View, Export, Delete)
- Pagination (10/20/50 per page)

### 3. User Details
**Route**: `/users/:userId`
**Description**: Individual user profile

**Components**:
- User info card
- Sessions history table
- GDPR export button

### 4. Analytics
**Route**: `/analytics`
**Description**: Detailed charts and metrics

**Components**:
- Date range selector
- DAU Chart (Line chart, 30 days)
- MAU Chart (Bar chart, 6 months)
- Session Duration Distribution
- Band Usage (Bar + Pie charts)
- Donation Metrics
- Export to CSV button

### 5. Presets
**Route**: `/presets`
**Description**: Manage binaural beat presets

**Components**:
- Presets table
- Edit modal with:
  - Name input
  - Band dropdown (Delta/Theta/Alpha/Beta/Gamma)
  - Beat frequency
  - Carrier frequency
  - Official/Featured toggles

### 6. Remote Config
**Route**: `/config`
**Description**: Feature flags and app settings

**Components**:
- Config table
- Add/Edit config modal
- Value types: string, number, boolean, JSON

### 7. Audit Log
**Route**: `/audit`
**Description**: Admin action history

**Components**:
- Filter by entity type
- Filter by action type
- Date range filter
- Changes diff view

### 8. System Health
**Route**: `/health`
**Description**: System status monitoring

**Components**:
- Status cards (API, Database, Realtime)
- Response time metrics
- Error rate chart

### 9. Login History
**Route**: `/login-history`
**Description**: Admin login activity

**Components**:
- Login attempts table
- IP addresses
- Session management

### 10. Ad Performance
**Route**: `/ads`
**Description**: Ad metrics and revenue

**Components**:
- Metrics cards (Impressions, Clicks, CTR, Revenue)
- Performance charts
- Placements table

---

## LAYOUT COMPONENTS

### Sidebar
- Width: 256px (16rem)
- Background: surface-container-low (#1c1b1d)
- Navigation items:
  - Dashboard (LayoutDashboard icon)
  - Analytics (BarChart3 icon)
  - Users (Users icon)
  - Presets (Music icon)
  - Remote Config (Settings icon)
  - Audit Log (FileText icon)
  - System Health (Activity icon)
  - Login History (Shield icon)
  - Ad Performance (DollarSign icon)
- Active state: primary/20 background, primary text
- Bottom: User email, Sign out button

### Top Bar
- Breadcrumbs
- Theme toggle (dark/light)
- Rate limit display

### Page Container
- Padding: 24px (p-6)
- Max width: 1400px
- Background: surface-container-lowest (#0e0e0f)

---

## UI COMPONENTS

### Stat Card
```text
- Background: surface-container (#201f21)
- Border radius: 0.5rem (rounded-xl)
- Padding: 1.5rem (p-6)
- Layout: Flex row, space-between
- Icon container: primary/10 background, rounded-lg
- Title: text-on-surface-variant, text-sm
- Value: text-on-surface, text-2xl, font-bold
- Subtitle: text-on-surface-variant, text-xs
```text

### Data Table
```text
- Header: bg-background, text-on-surface-variant
- Row: hover:bg-surface-container-high
- Border: border-outline-variant
- Cell padding: px-4 py-3
- Font: text-sm
```text

### Button Variants
```text
// Primary
bg-primary text-on-primary hover:bg-primary-fixed-dim

// Secondary
bg-secondary-container text-on-secondary-container

// Ghost
text-on-surface-variant hover:bg-surface-container

// Danger
text-error hover:bg-error-container
```text

### Input
```text
- bg-surface-container-lowest
- border border-outline-variant
- focus:border-primary
- rounded-xl (0.5rem)
- h-12 (48px)
```text

---

## CHARTS (Using Recharts)

### Colors for Charts
- Primary: #2fd9f4 (cyan)
- Secondary: #d0bcff (purple)
- Grid: #333333
- Axis: #666666
- Tooltip BG: #201f21

### Chart Types
- DAU: Line chart, stroke #2fd9f4
- MAU: Bar chart, fill #2fd9f4
- Band Distribution: Bar chart with band colors
- Pie Chart: Band colors
- Donations: Dual bar chart (amount + count)

---

## AUTHENTICATION

### Login Page
- Email input
- Password input
- Sign in button (primary)
- Error display

### Protected Routes
- Check Supabase auth
- Verify admin role
- Session timeout warning (8 seconds)

---

## SUPABASE INTEGRATION

### Required Tables/Views
- `users` - User accounts
- `sessions` - Session history  
- `presets` - Binaural presets
- `donations` - Donation records
- `user_roles` - Admin/viewer roles
- `audit_logs` - Admin actions
- `remote_config` - Feature flags
- `analytics_daily_active` - View for DAU
- `analytics_monthly_active` - View for MAU

---

## DEPENDENCIES

```json
{
  "dependencies": {
    "next": "^15.x",
    "react": "^19.x",
    "react-dom": "^19.x",
    "@supabase/supabase-js": "^2.x",
    "recharts": "^2.x",
    "lucide-react": "^0.x",
    "date-fns": "^3.x",
    "sonner": "^1.x",
    "class-variance-authority": "^0.x",
    "clsx": "^2.x",
    "tailwind-merge": "^2.x"
  }
}
```text

---

## IMPLEMENTATION NOTES

1. **Dark Mode First**: All colors are for dark mode. Light mode optional.
2. **Tonal Surfaces**: Use surface container hierarchy, not flat grays
3. **No Hard Borders**: Use outline-variant for subtle separation
4. **Glass Morphism**: Use glass-panel class for overlays
5. **Glow Effects**: Use cyan-glow and violet-glow classes
6. **Fonts**: Space Grotesk for headlines, Inter for body
7. **Icons**: Lucide React
8. **Charts**: Recharts with custom tooltip styling
9. **Real-time**: Supabase realtime for "Active Now" counter
10. **Responsive**: Sidebar collapses on mobile
