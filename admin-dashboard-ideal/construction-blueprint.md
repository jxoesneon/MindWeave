# MindWeave Admin Dashboard - Construction Blueprint

## Project: mindweave-admin-dashboard-stitch

---

## Phase 1: Project Initialization

### Step 1.1: Initialize Stitch Project

**Objective**: Create a new Google Stitch project with the MindWeave admin dashboard.

**Prerequisites**:

- Stitch CLI or MCP access configured
- Google account with Stitch access
- Project name: `mindweave-admin-dashboard`

**Tasks**:

1. Create new Stitch project via MCP or CLI
2. Configure project settings (React + TypeScript + Tailwind)
3. Set up project structure

**Exit Criteria**:

- Project created successfully
- Default hello-world page renders
- Git repository initialized

---

## Phase 2: Design System Implementation

### Step 2.1: Configure Tailwind Theme

**Objective**: Implement the MindWeave design system colors, typography, and spacing.

**Files to Create/Edit**:

- `tailwind.config.ts` - Extended color palette
- `src/styles/globals.css` - CSS variables for theming
- `src/lib/theme.ts` - Theme utilities

**Design Tokens to Implement**:

#### Colors (Dark Mode Primary)

```typescript
// Add to tailwind config
colors: {
  background: '#0D0D0F',
  surface: {
    DEFAULT: '#131315',
    dim: '#131315',
    bright: '#39393B',
    container: {
      lowest: '#0E0E10',
      low: '#1B1B1D',
      DEFAULT: '#201F21',
      high: '#2A2A2C',
      highest: '#353437',
    },
    variant: '#353437',
  },
  primary: {
    DEFAULT: '#7B68EE',
    container: '#907EFF',
    fixed: '#E5DEFF',
    'fixed-dim': '#C8BFFF',
  },
  secondary: {
    DEFAULT: '#00D9C0',
    container: '#00D9C0',
    fixed: '#4FFBE1',
    'fixed-dim': '#1ADEC5',
  },
  content: {
    DEFAULT: '#E5E1E4',
    variant: '#C9C4D6',
  },
  outline: {
    DEFAULT: '#928E9F',
    variant: '#474554',
  },
  bands: {
    delta: '#4A90D9',
    theta: '#9B59B6',
    alpha: '#7B68EE',
    beta: '#E67E22',
    gamma: '#E74C3C',
  },
}
```text

#### Font Configuration
```typescript
fontFamily: {
  headline: ['Space Grotesk', 'sans-serif'],
  body: ['Inter', 'sans-serif'],
}
```text

#### Spacing Scale
```typescript
spacing: {
  '18': '4.5rem',
  '22': '5.5rem',
}
```text

#### Border Radius
```typescript
borderRadius: {
  '2xl': '1rem',
  '3xl': '1.25rem',
  '4xl': '1.5rem',
}
```text

**Verification**:
- Colors render correctly in dev tools
- Fonts load from Google Fonts or local
- Theme toggle works between dark/light

---

### Step 2.2: Create Base Components
**Objective**: Build reusable UI components following the design system.

**Components to Create** (in priority order):

#### Layout Components
1. **Sidebar** (`src/components/layout/Sidebar.tsx`)
   - Fixed 256px width
   - Navigation items with icons
   - Active state styling
   - Collapsible on mobile

2. **TopBar** (`src/components/layout/TopBar.tsx`)
   - Breadcrumbs
   - User menu
   - Theme toggle
   - Rate limit display

3. **PageContainer** (`src/components/layout/PageContainer.tsx`)
   - Consistent padding
   - Max width constraint
   - Responsive behavior

#### Data Display Components
4. **StatCard** (`src/components/data/StatCard.tsx`)
   - Icon + title + value + subtitle
   - Hover state with aura glow
   - Loading skeleton state

5. **DataTable** (`src/components/data/DataTable.tsx`)
   - Sortable columns
   - Pagination
   - Row actions
   - Empty state

6. **ChartContainer** (`src/components/data/ChartContainer.tsx`)
   - Consistent chart wrapper
   - Title + icon
   - Loading state
   - Responsive sizing

#### Form Components
7. **SearchInput** (`src/components/forms/SearchInput.tsx`)
   - Debounced input (300ms)
   - Clear button
   - Icon left

8. **DateRangePicker** (`src/components/forms/DateRangePicker.tsx`)
   - Start/end date inputs
   - Preset ranges
   - Validation

9. **ConfirmDialog** (`src/components/forms/ConfirmDialog.tsx`)
   - Title + message
   - Confirm/Cancel actions
   - Danger variant styling

#### Feedback Components
10. **LoadingSpinner** (`src/components/feedback/LoadingSpinner.tsx`)
    - Centered spinner
    - Size variants

11. **Toast** (use Sonner with custom styling)
    - Success: Secondary color (turquoise)
    - Error: Error color (red)
    - Info: Primary color (purple)

**Exit Criteria**:
- All components render in Storybook (if used)
- Components match design spec visually
- TypeScript types defined
- Props interfaces documented

---

## Phase 3: Page Implementation

### Step 3.1: Dashboard Page
**Objective**: Create the main dashboard with statistics overview.

**Route**: `/`

**Features**:
1. **Stats Grid** (7 stat cards)
   - Total Users
   - Active Today
   - Active This Month
   - Total Sessions
   - Avg Session Duration
   - Active Now (realtime)
   - Donations

2. **Frequency Bands Section**
   - 5-column layout
   - Color-coded by band
   - Percentage display
   - Session count

**Data Integration**:
- Connect to Supabase analytics views
- Realtime subscriptions for "Active Now"

**Exit Criteria**:
- All stats display correctly
- Realtime counter updates
- Responsive layout works

---

### Step 3.2: Users Page
**Objective**: User management interface with search and actions.

**Route**: `/users`

**Features**:
1. **Search & Filters**
   - Debounced search (300ms)
   - Filter by device type
   - Filter by anonymous status

2. **Users Table**
   - Columns: ID, Anonymous, Device, Version, Created, Last Active, Actions
   - Pagination (10/20/50 per page)
   - Sortable columns

3. **Row Actions**
   - View details → `/users/:id`
   - Export data (GDPR)
   - Delete (with confirmation)

**Exit Criteria**:
- Search filters results
- Pagination works
- Actions functional

---

### Step 3.3: User Details Page
**Objective**: Individual user profile and session history.

**Route**: `/users/:userId`

**Features**:
1. **User Info Card**
   - ID, device type, app version
   - Created date, last active
   - GDPR export button

2. **Sessions Table**
   - Session history
   - Frequency bands used
   - Duration, completion status

3. **Favorites (if applicable)**
   - Saved presets

**Exit Criteria**:
- User data loads correctly
- Sessions display in table
- Export function works

---

### Step 3.4: Analytics Page
**Objective**: Detailed charts and metrics visualization.

**Route**: `/analytics`

**Features**:
1. **Date Range Filter**
   - Start/end date pickers
   - Preset buttons (7d, 30d, 90d)

2. **Charts** (using Recharts)
   - DAU Line Chart (30 days)
   - MAU Bar Chart (6 months)
   - Session Duration Distribution
   - Band Usage Bar Chart
   - Band Usage Pie Chart
   - Donation Metrics (dual axis)

3. **Export Button**
   - CSV export of all data

**Exit Criteria**:
- All charts render correctly
- Date filtering works
- Export generates valid CSV

---

### Step 3.5: Presets Page
**Objective**: Manage official binaural beat presets.

**Route**: `/presets`

**Features**:
1. **Presets Table**
   - Name, Band, Beat Freq, Carrier, Usage Count
   - Official/Featured toggles
   - Edit action

2. **Edit Modal**
   - All preset fields editable
   - Band selection dropdown
   - Frequency validation

**Exit Criteria**:
- Presets load and display
- Toggles persist changes
- Edit saves correctly

---

### Step 3.6: Remote Config Page
**Objective**: Manage feature flags and app settings.

**Route**: `/config`

**Features**:
1. **Config Table**
   - Key, Value, Type, Description
   - Last updated info

2. **Add/Edit Config**
   - Key input
   - Value by type (string/number/boolean/JSON)
   - Description

3. **Change History**
   - Recent changes list
   - Who/when/what

**Exit Criteria**:
- Configs display correctly
- Changes persist to Supabase
- Type validation works

---

### Step 3.7: Audit Log Page
**Objective**: View admin action history.

**Route**: `/audit`

**Features**:
1. **Filter Bar**
   - Entity type filter
   - Action type filter
   - Date range

2. **Audit Table**
   - Timestamp, Admin, Action, Entity, Changes
   - Diff view for value changes

**Exit Criteria**:
- Logs display chronologically
- Filters work correctly
- Diff shows before/after

---

### Step 3.8: System Health Page
**Objective**: Monitor system status and performance.

**Route**: `/health`

**Features**:
1. **Status Cards**
   - API Status
   - Database Connection
   - Realtime Subscriptions
   - Response Times

2. **Error Rate Chart**
   - Last 24 hours
   - Error count over time

3. **Quick Actions**
   - Test connections
   - View logs

**Exit Criteria**:
- Status indicators accurate
- Charts render correctly
- Actions functional

---

### Step 3.9: Login History Page
**Objective**: View admin login activity.

**Route**: `/login-history`

**Features**:
1. **Login Table**
   - Admin email, Time, IP, User Agent, Status
   - Failed attempts highlighted

2. **Session Management**
   - Active sessions list
   - Revoke session action

**Exit Criteria**:
- Logins display correctly
- IP and user agent shown
- Revoke function works

---

### Step 3.10: Ad Performance Page
**Objective**: Track ad metrics and revenue.

**Route**: `/ads`

**Features**:
1. **Metrics Cards**
   - Impressions, Clicks, CTR, Revenue

2. **Performance Charts**
   - Impressions over time
   - CTR by placement
   - Revenue trend

3. **Placements Table**
   - Placement name, Fill rate, eCPM

**Exit Criteria**:
- Metrics display correctly
- Charts render
- Data updates

---

## Phase 4: Authentication & Security

### Step 4.1: Auth Integration
**Objective**: Implement Supabase authentication.

**Files**:
- `src/lib/supabase.ts` - Client setup
- `src/hooks/useAuth.ts` - Auth state management
- `src/components/auth/LoginForm.tsx` - Login UI
- `src/components/auth/ProtectedRoute.tsx` - Route guard

**Features**:
1. **Login Page**
   - Email/password form
   - Error handling
   - Loading states

2. **Session Management**
   - Auto-refresh tokens
   - Session timeout warning
   - Extend session option

3. **Role Checking**
   - Admin role verification
   - Viewer role support
   - Redirect on unauthorized

**Exit Criteria**:
- Login works with valid credentials
- Invalid credentials show error
- Protected routes enforce auth
- Session timeout works

---

### Step 4.2: Security UI Patterns
**Objective**: Implement security-related UI components.

**Components**:
1. **RateLimitDisplay** - Show remaining API calls
2. **SessionWarning** - Modal before timeout
3. **ConfirmDelete** - Danger-styled confirmation
4. **GDPRNotice** - Privacy notices for exports

**Exit Criteria**:
- Rate limit visible in sidebar
- Timeout warning appears
- Delete confirmations styled correctly

---

## Phase 5: Data Integration

### Step 5.1: Supabase Client Setup
**Objective**: Configure Supabase connection and types.

**Files**:
- `src/lib/supabase.ts` - Client + types
- `src/types/database.ts` - TypeScript interfaces

**Types to Define**:
```typescript
interface User {
  id: string;
  created_at: string;
  last_active: string;
  is_anonymous: boolean;
  device_type: string;
  app_version: string;
}

interface Session {
  id: string;
  user_id: string;
  started_at: string;
  ended_at: string | null;
  duration_seconds: number | null;
  preset_id: string;
  beat_frequency: number;
  carrier_frequency: number;
  completed: boolean;
}

interface Preset {
  id: string;
  name: string;
  description: string;
  band: 'Delta' | 'Theta' | 'Alpha' | 'Beta' | 'Gamma';
  beat_frequency: number;
  default_carrier: number;
  is_official: boolean;
  is_featured: boolean;
  usage_count: number;
}

interface Donation {
  id: string;
  user_id: string;
  created_at: string;
  amount: number;
  currency: string;
  provider: string;
}
```text

**Exit Criteria**:
- Types compile correctly
- Client connects to Supabase
- Environment variables configured

---

### Step 5.2: Custom Hooks
**Objective**: Create data fetching hooks with caching and realtime.

**Hooks to Create**:
1. `useAnalytics()` - Dashboard stats
2. `useUsers()` - User list with pagination
3. `useUser(id)` - Single user details
4. `useSessions(userId?)` - Session history
5. `usePresets()` - Preset management
6. `useRealtimeUsers()` - Live active user count
7. `useDonations()` - Donation metrics
8. `useAuditLog()` - Admin actions
9. `useRemoteConfig()` - Feature flags
10. `useSystemHealth()` - Status checks

**Exit Criteria**:
- All hooks return typed data
- Loading states handled
- Errors caught and displayed
- Realtime subscriptions work

---

## Phase 6: Polish & Optimization

### Step 6.1: Performance Optimization
**Objective**: Ensure fast load times and smooth interactions.

**Tasks**:
1. **Code Splitting**
   - Lazy load all pages
   - Split chart library
   - Dynamic imports for heavy components

2. **Memoization**
   - React.memo for StatCard
   - useMemo for expensive calculations
   - useCallback for event handlers

3. **Image Optimization**
   - Use webp format
   - Lazy load below fold
   - Proper sizing

4. **Bundle Analysis**
   - Analyze with @next/bundle-analyzer
   - Remove unused dependencies
   - Tree-shake effectively

**Exit Criteria**:
- Lighthouse score > 90
- First Contentful Paint < 1.5s
- Bundle size < 500KB initial

---

### Step 6.2: Accessibility
**Objective**: Meet WCAG 2.1 AA standards.

**Tasks**:
1. **Keyboard Navigation**
   - All interactive elements focusable
   - Logical tab order
   - Skip links

2. **Screen Reader Support**
   - ARIA labels on icons
   - Table captions
   - Chart alternatives

3. **Color Contrast**
   - 4.5:1 for normal text
   - 3:1 for large text
   - Test with Stark or similar

4. **Focus Indicators**
   - Visible focus on all elements
   - 2px primary outline
   - 2px offset

**Exit Criteria**:
- axe-core tests pass
- Keyboard navigation works
- Screen reader testing complete

---

### Step 6.3: Responsive Design
**Objective**: Ensure perfect experience on all devices.

**Breakpoints**:
- Mobile: < 640px
- Tablet: 640px - 1024px
- Desktop: > 1024px

**Mobile Adaptations**:
1. **Sidebar**
   - Collapses to hamburger menu
   - Bottom sheet on mobile
   - Icons only on tablet

2. **Tables**
   - Horizontal scroll with sticky first column
   - Or card view transformation

3. **Charts**
   - Maintain aspect ratio
   - Minimum height enforced
   - Touch-friendly tooltips

4. **Stats Grid**
   - Single column on mobile
   - Two columns on tablet
   - Three columns on desktop

**Exit Criteria**:
- All pages usable on mobile
- No horizontal scroll issues
- Touch targets > 44px

---

## Phase 7: Testing & Deployment

### Step 7.1: Testing Setup
**Objective**: Comprehensive test coverage.

**Testing Strategy**:
1. **Unit Tests** (Vitest)
   - Hook tests with MSW
   - Component tests with React Testing Library
   - Utility function tests

2. **Integration Tests**
   - Page flow tests
   - Auth flow tests
   - Data fetching tests

3. **E2E Tests** (Playwright)
   - Critical user journeys
   - Cross-browser testing
   - Mobile viewport testing

**Exit Criteria**:
- > 80% code coverage
- All critical paths tested
- CI/CD pipeline runs tests

---

### Step 7.2: Deployment
**Objective**: Deploy to production.

**Platform**: Vercel (or Stitch hosting if available)

**Steps**:
1. Configure build settings
2. Set environment variables
3. Configure custom domain (optional)
4. Set up preview deployments
5. Configure CSP headers

**Post-Deployment**:
1. Smoke test all pages
2. Verify auth flows
3. Check analytics tracking
4. Monitor error rates

**Exit Criteria**:
- Site live on production URL
- All features functional
- No console errors

---

## Appendix A: File Structure

```text
my-app/
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   │   └── login/
│   │   │       └── page.tsx
│   │   ├── (dashboard)/
│   │   │   ├── layout.tsx
│   │   │   ├── page.tsx                 # Dashboard
│   │   │   ├── users/
│   │   │   │   ├── page.tsx
│   │   │   │   └── [id]/
│   │   │   │       └── page.tsx
│   │   │   ├── analytics/
│   │   │   │   └── page.tsx
│   │   │   ├── presets/
│   │   │   │   └── page.tsx
│   │   │   ├── config/
│   │   │   │   └── page.tsx
│   │   │   ├── audit/
│   │   │   │   └── page.tsx
│   │   │   ├── health/
│   │   │   │   └── page.tsx
│   │   │   ├── login-history/
│   │   │   │   └── page.tsx
│   │   │   └── ads/
│   │   │       └── page.tsx
│   │   └── layout.tsx
│   ├── components/
│   │   ├── layout/
│   │   │   ├── Sidebar.tsx
│   │   │   ├── TopBar.tsx
│   │   │   └── PageContainer.tsx
│   │   ├── data/
│   │   │   ├── StatCard.tsx
│   │   │   ├── DataTable.tsx
│   │   │   └── ChartContainer.tsx
│   │   ├── forms/
│   │   │   ├── SearchInput.tsx
│   │   │   ├── DateRangePicker.tsx
│   │   │   └── ConfirmDialog.tsx
│   │   ├── feedback/
│   │   │   ├── LoadingSpinner.tsx
│   │   │   └── Toast.tsx
│   │   └── auth/
│   │       ├── LoginForm.tsx
│   │       └── ProtectedRoute.tsx
│   ├── hooks/
│   │   ├── useAuth.ts
│   │   ├── useAnalytics.ts
│   │   ├── useUsers.ts
│   │   ├── useUser.ts
│   │   ├── useSessions.ts
│   │   ├── usePresets.ts
│   │   ├── useRealtimeUsers.ts
│   │   ├── useDonations.ts
│   │   ├── useAuditLog.ts
│   │   ├── useRemoteConfig.ts
│   │   ├── useSystemHealth.ts
│   │   └── useDebounce.ts
│   ├── lib/
│   │   ├── supabase.ts
│   │   ├── theme.ts
│   │   ├── utils.ts
│   │   ├── export.ts
│   │   └── validation.ts
│   ├── types/
│   │   └── database.ts
│   └── styles/
│       └── globals.css
├── public/
│   └── fonts/
├── components.json          # shadcn config
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
└── package.json
```text

---

## Appendix B: Dependencies

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
  },
  "devDependencies": {
    "typescript": "^5.x",
    "@types/node": "^20.x",
    "@types/react": "^19.x",
    "@types/react-dom": "^19.x",
    "tailwindcss": "^3.x",
    "postcss": "^8.x",
    "autoprefixer": "^10.x",
    "eslint": "^8.x",
    "eslint-config-next": "^15.x",
    "vitest": "^1.x",
    "@testing-library/react": "^14.x",
    "@testing-library/jest-dom": "^6.x",
    "msw": "^2.x",
    "playwright": "^1.x"
  }
}
```text

---

## Appendix C: Environment Variables

```bash
# .env.local
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=          # Server-side only

# Optional
NEXT_PUBLIC_APP_URL=
```text

---

## Construction Order Summary

1. **Week 1**: Design System + Base Components
2. **Week 2**: Dashboard + Users Pages
3. **Week 3**: Analytics + Presets + Config
4. **Week 4**: Audit + Health + Login History + Ads
5. **Week 5**: Auth + Security + Data Integration
6. **Week 6**: Testing + Polish + Deployment

**Total Estimated Time**: 6 weeks (1 developer)
