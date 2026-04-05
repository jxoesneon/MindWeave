# MindWeave Admin Dashboard - Design System Specification

## Overview

Complete design system specification for the MindWeave Admin Dashboard, optimized for Google Stitch implementation. Based on the existing React/Tailwind dashboard and the main Flutter app's design system.

---

## Design Philosophy

### MindWeave Ethos

- **Deep State Focus**: Calm, focused interface that doesn't distract from the meditation experience
- **Sonic Monolith**: Minimalist yet powerful, like a precision audio instrument
- **Ethereal Pulse**: Subtle animations and glows that suggest gentle energy flow
- **Tonal Hierarchy**: Layered surfaces without hard borders (No-Line rule)

---

## Color System

### Dark Mode (Primary)

#### Foundation Colors
| Token | Hex | Usage |
|-------|-----|-------|
| background | #0D0D0F | Main page background |
| surface | #131315 | Cards, elevated surfaces |
| surfaceDim | #131315 | Subtle backgrounds |
| surfaceBright | #39393B | Brightest surface variant |

#### Surface Container Hierarchy (Tonal Nesting)

| Token | Hex | Elevation Level |
|-------|-----|-----------------|
| surfaceContainerLowest | #0E0E10 | Deepest nested |
| surfaceContainerLow | #1B1B1D | Default card level |
| surfaceContainer | #201F21 | Mid-elevation |
| surfaceContainerHigh | #2A2A2C | Raised cards |
| surfaceContainerHighest | #353437 | Highest containers |
| surfaceVariant | #353437 | Alternative surfaces |

#### Primary Palette (Purple)

| Token | Hex | Usage |
|-------|-----|-------|
| primary | #8B5CF6 | Buttons, active states, links |
| primaryContainer | #907EFF | Selected chips, badges |
| primaryFixed | #E5DEFF | Light backgrounds |
| primaryFixedDim | #C8BFFF | Soft highlights |
| onPrimary | #2D009D | Text on primary |
| onPrimaryContainer | #26008B | Text on primary containers |
| surfaceTint | #C8BFFF | Surface tint overlay |
| inversePrimary | #5C47CD | Inverse states |

#### Secondary Palette (Turquoise/Cyan)
| Token | Hex | Usage |
|-------|-----|-------|
| secondary | #00D9C0 | Success states, secondary actions |
| secondaryContainer | #00D9C0 | Secondary backgrounds |
| secondaryFixed | #4FFBE1 | Bright accents |
| secondaryFixedDim | #1ADEC5 | Medium accents |
| onSecondary | #003730 | Text on secondary |

#### Tertiary Palette (Warm Accent)
| Token | Hex | Usage |
|-------|-----|-------|
| tertiary | #FFB86A | Warnings, attention |
| tertiaryContainer | #CA801D | Warm backgrounds |
| tertiaryFixed | #FFDCBC | Soft warm accents |
| onTertiary | #492900 | Text on tertiary |

#### Content Colors
| Token | Hex | Usage |
|-------|-----|-------|
| onSurface | #E5E1E4 | Primary text |
| onSurfaceVariant | #C9C4D6 | Secondary text |
| onBackground | #E5E1E4 | Text on background |
| inverseSurface | #E5E1E4 | Inverse backgrounds |
| inverseOnSurface | #313032 | Text on inverse |

#### Outlines (Ghost Borders)
| Token | Hex | Usage |
|-------|-----|-------|
| outline | #928E9F | Subtle borders |
| outlineVariant | #474554 | Very subtle dividers |

#### Error Colors
| Token | Hex | Usage |
|-------|-----|-------|
| error | #FFB4AB | Error states |
| errorContainer | #93000A | Error backgrounds |
| onError | #690005 | Text on error |
| onErrorContainer | #FFDAD6 | Text on error containers |

#### Brainwave Band Colors
| Band | Color | Hex | Usage |
|------|-------|-----|-------|
| Delta | Blue | #4A90D9 | Deep Sleep |
| Theta | Purple | #9B59B6 | Meditation |
| Alpha | Slate Blue | #7B68EE | Relaxation |
| Beta | Orange | #E67E22 | Focus |
| Gamma | Red | #E74C3C | Peak Performance |

### Light Mode

#### Foundation Colors
| Token | Hex |
|-------|-----|
| background | #F5F5F7 |
| surface | #FFFFFF |
| surfaceDim | #DDDDE1 |
| surfaceBright | #FFFFFF |

#### Surface Containers
| Token | Hex |
|-------|-----|
| surfaceContainerLowest | #FFFFFF |
| surfaceContainerLow | #F5F5F7 |
| surfaceContainer | #EFEFF2 |
| surfaceContainerHigh | #E5E5EA |
| surfaceContainerHighest | #DBDBE1 |
| surfaceVariant | #DBDBE1 |

#### Primary (Light)
| Token | Hex |
|-------|-----|
| primary | #5A4FCF |
| primaryContainer | #E5DEFF |
| onPrimary | #FFFFFF |
| onPrimaryContainer | #26008B |

---

## Typography System

### Font Families
- **Headlines**: Space Grotesk - geometric, editorial, high contrast
- **Body**: Inter - human-readable, neutral, highly legible

### Type Scale

| Style | Size | Weight | Letter-Spacing | Line-Height | Usage |
|-------|------|--------|----------------|-------------|-------|
| displayLarge | 56px | 300 | -0.02 | 1.2 | Hero moments |
| displayMedium | 44px | 400 | -0.02 | 1.2 | Large headers |
| displaySmall | 36px | 500 | -0.02 | 1.2 | Medium headers |
| headlineLarge | 32px | 600 | -0.01 | 1.3 | Page titles |
| headlineMedium | 28px | 600 | -0.01 | 1.3 | Section headers |
| headlineSmall | 24px | 600 | -0.01 | 1.3 | Subsections |
| titleLarge | 22px | 600 | 0 | 1.4 | Card titles |
| titleMedium | 18px | 600 | 0 | 1.4 | List headers |
| titleSmall | 16px | 600 | 0 | 1.4 | Small titles |
| bodyLarge | 16px | 400 | 0 | 1.5 | Primary content |
| bodyMedium | 14px | 400 | 0 | 1.5 | Default body |
| bodySmall | 12px | 400 | 0 | 1.5 | Captions |
| labelLarge | 14px | 600 | 0.05 | 1.2 | Large buttons |
| labelMedium | 12px | 600 | 0.05 | 1.2 | Category tags |
| labelSmall | 10px | 600 | 0.05 | 1.2 | Small labels |

### Specialized Styles
| Style | Font | Size | Weight | Features |
|-------|------|------|--------|----------|
| button | Inter | 14px | 600 | 0.02 spacing |
| caption | Inter | 11px | 400 | 0.02 spacing |
| overline | Inter | 10px | 600 | 0.08 spacing |
| timer | Inter | 24px | 300 | Tabular figures |
| frequency | Space Grotesk | 14px | 600 | Primary color |
| hardwareLabel | Inter | 12px | 600 | 0.05 spacing |

---

## Spacing System

### Base Unit: 4px

| Token | Value | Usage |
|-------|-------|-------|
| space-1 | 4px | Micro spacing |
| space-2 | 8px | Tight spacing |
| space-3 | 12px | Default small |
| space-4 | 16px | Standard spacing |
| space-5 | 20px | Medium spacing |
| space-6 | 24px | Large spacing |
| space-8 | 32px | Section spacing |
| space-10 | 40px | Major sections |
| space-12 | 48px | Page sections |
| space-16 | 64px | Large separations |

### Component Spacing
- Card padding: 16-24px
- Card gap: 16px
- Section gap: 24px
- Page padding: 24-32px
- Sidebar width: 256px (16rem)
- Input height: 48px
- Button height: 48px
- Chip height: 32px

---

## Border Radius System

| Token | Value | Usage |
|-------|-------|-------|
| radius-sm | 8px | Small elements |
| radius-md | 12px | Inputs, buttons |
| radius-lg | 16px | Cards |
| radius-xl | 20px | Large cards |
| radius-2xl | 24px | Modals, dialogs |
| radius-full | 9999px | Pills, avatars |

---

## Shadow & Elevation System

### Aura Glow Effects
| Type | Color | Alpha | Blur | Spread |
|------|-------|-------|------|--------|
| auraGlow | #7B68EE | 0.15 | 40px | 8px |
| auraGlowStrong | #7B68EE | 0.25 | 40px | 12px |
| secondaryAura | #00D9C0 | 0.15 | 40px | 8px |

### Elevation Levels
| Level | Background | Shadow |
|-------|------------|--------|
| Level 0 | surface | None |
| Level 1 | surfaceContainerLow | 0 1px 2px rgba(0,0,0,0.1) |
| Level 2 | surfaceContainer | 0 2px 4px rgba(0,0,0,0.15) |
| Level 3 | surfaceContainerHigh | 0 4px 8px rgba(0,0,0,0.2) |
| Level 4 | surfaceContainerHighest | 0 8px 16px rgba(0,0,0,0.25) |

---

## Component Specifications

### Cards
- Background: surfaceContainerLow (#1B1B1D)
- Border radius: 20px
- Padding: 24px
- Border: 1px solid outlineVariant (ghost)
- No elevation (flat)

### Buttons

#### Primary Button
- Background: primary (#7B68EE)
- Text: onPrimary (#2D009D)
- Border radius: 16px
- Height: 48px
- Padding: 12px 24px
- Font: labelLarge (14px, 600)

#### Secondary Button
- Background: surfaceContainerHigh
- Text: onSurface
- Border: 1px solid outlineVariant
- Border radius: 16px
- Height: 48px

#### Ghost Button
- Background: transparent
- Text: onSurfaceVariant
- Hover: surfaceContainer
- Border radius: 12px

### Inputs
- Background: surfaceContainerLowest (#0E0E10)
- Border: 1px solid outlineVariant
- Border radius: 12px
- Height: 48px
- Padding: 16px horizontal
- Focus border: 2px solid primary
- Placeholder: onSurfaceVariant with 50% opacity

### Tables
- Header: background (#0D0D0F)
- Header text: onSurfaceVariant
- Row: surfaceContainerLow on hover
- Border: 1px solid outlineVariant
- Cell padding: 16px

### Chips/Badges
- Background: surfaceContainerHigh
- Selected: primary
- Border radius: 12px
- Padding: 4px 12px
- Height: 32px
- Font: labelSmall

### Navigation
- Sidebar width: 256px
- Sidebar background: surfaceContainerLow
- Active item: primary/20 background, primary text
- Inactive item: onSurfaceVariant text
- Hover: surfaceContainerHigh background
- Border right: 1px solid outlineVariant

### Icons
- Default size: 24px
- Default color: onSurfaceVariant
- Active color: primary
- Lucide icon set

---

## Layout Grid

### Admin Dashboard Layout
- Sidebar: Fixed 256px left
- Main content: Flexible, min-width 0
- Page max-width: 1400px
- Page padding: 32px
- Content gap: 24px

### Grid System
- Columns: 12-column grid
- Gutter: 24px
- Breakpoints:
  - Mobile: < 640px (single column)
  - Tablet: 640px - 1024px (sidebar collapses)
  - Desktop: > 1024px (full layout)

---

## Animation Specifications

### Transitions
| Type | Duration | Easing |
|------|----------|--------|
| instant | 0ms | - |
| fast | 150ms | ease-out |
| normal | 200ms | ease-in-out |
| slow | 300ms | ease-in-out |
| emphasis | 400ms | cubic-bezier(0.4, 0, 0.2, 1) |

### Page Transitions
- Enter: Fade in + slide up (20px)
- Duration: 300ms
- Easing: ease-out

### Hover States
- Background color transition: 150ms
- Scale: 1.02 on cards
- Aura glow: Appear on 200ms

### Loading States
- Spinner: 1s linear infinite rotation
- Skeleton: Pulse animation, 2s ease-in-out infinite
- Progress: Smooth width transition, 300ms

---

## Iconography

### Icon Library: Lucide
- Size default: 24px
- Size small: 16px
- Size large: 32px
- Stroke width: 2px

### Dashboard Icons
| Feature | Icon Name |
|---------|-----------|
| Dashboard | LayoutDashboard |
| Analytics | BarChart3 |
| Users | Users |
| Presets | Music |
| Config | Settings |
| Audit | FileText |
| Health | Activity |
| Login History | Shield |
| Ads | DollarSign |
| Logout | LogOut |
| Search | Search |
| Download | Download |
| Delete | Trash2 |
| View | Eye |
| Refresh | RefreshCw |
| Calendar | Calendar |
| Clock | Clock |
| Heart | Heart |
| Activity | Activity |
| Trending | TrendingUp |
| Radio | Radio |
| Music | Music |

---

## Data Visualization

### Chart Colors
| Dataset | Color |
|---------|-------|
| Primary | #7B68EE |
| Secondary | #00D9C0 |
| Tertiary | #FFB86A |
| Success | #10B981 |
| Grid | #333333 |
| Axis | #666666 |
| Tooltip BG | #1A1A1F |

### Chart Specifications
- Grid: Dashed 3px lines, #333 color
- Bar radius: 4px top corners
- Line stroke: 2px
- No fill on line charts (just stroke)
- Tooltip: 8px border-radius, surfaceContainer background

---

## Page Specifications

### Dashboard Page
**Stat Cards Grid**: 3 columns on desktop, 2 on tablet, 1 on mobile
**Stats to Display**:
1. Total Users (all time)
2. Active Today (daily active)
3. Active This Month (monthly active)
4. Total Sessions (all time)
5. Avg Session Duration
6. Active Now (real-time count)
7. Donations (total amount)

**Frequency Bands Section**: 5-column grid showing:
- Delta (Blue): Deep Sleep
- Theta (Purple): Meditation
- Alpha (Slate): Relaxation
- Beta (Orange): Focus
- Gamma (Red): Peak

### Users Page
- Search bar with debounced input (300ms)
- Users table with pagination (20/page default)
- Actions: View, Export (GDPR), Delete
- Filters by device type, anonymous status

### Analytics Page
- Date range selector
- DAU chart (LineChart, 30 days)
- MAU chart (BarChart, 6 months)
- Session duration distribution (BarChart)
- Band usage (BarChart + PieChart)
- Donation metrics (BarChart, dual series)

### Presets Page
- Official presets management
- Featured toggle
- Band categorization
- Edit frequency parameters
- Usage statistics

### Remote Config Page
- Feature flags toggle
- A/B test parameters
- Value type: string, number, boolean, JSON
- Change history

### Audit Log Page
- Admin action history
- Entity type filter
- Date range filter
- Diff view for changes

### System Health Page
- API status indicators
- Database connection
- Realtime subscriptions
- Error rates
- Response times

### Login History Page
- Recent admin logins
- IP addresses
- User agents
- Failed attempts
- Session management

### Ad Performance Page
- Impressions/clicks
- Revenue metrics
- CTR by placement
- Fill rates

---

## Responsive Behavior

### Breakpoints
- Mobile: < 640px
- Tablet: 640px - 1024px  
- Desktop: > 1024px

### Mobile Adaptations
- Sidebar becomes bottom sheet / hamburger menu
- Stats grid becomes single column
- Tables become horizontal scroll or card view
- Charts maintain aspect ratio with minimum height

### Tablet Adaptations
- Sidebar collapses to icons-only (64px)
- Stats grid becomes 2 columns
- Full functionality maintained

---

## Accessibility

### Contrast Requirements
- Normal text: 4.5:1 minimum
- Large text: 3:1 minimum
- Interactive elements: 3:1 minimum

### Focus States
- Primary outline: 2px solid primary
- Offset: 2px
- All interactive elements must have visible focus

### ARIA Labels
- Navigation: "Main navigation"
- Tables: Descriptive captions
- Charts: Alternative text summaries
- Buttons: Action labels

### Reduced Motion
- Respect prefers-reduced-motion
- Disable animations when set
- Instant state changes only

---

## Security UI Patterns

### Authentication States
- Loading: Spinner with "Verifying access..."
- Error: Yellow warning icon with clear message
- Timeout: Session expiry warning with extend option

### Sensitive Actions
- Delete confirmations with red warning styling
- GDPR export with privacy notice
- Role changes with confirmation dialog

### Rate Limiting
- Visual indicator in sidebar
- Remaining requests counter
- Cooldown timer when limited

---

## Implementation Notes for Stitch

### Component Library Selection
- **UI Framework**: shadcn/ui components
- **Charting**: Recharts (already working in existing dashboard)
- **Icons**: Lucide React
- **Date**: date-fns
- **Toast**: Sonner

### Tailwind Configuration
```javascript
// Colors to add to theme
{
  background: '#0D0D0F',
  surface: '#131315',
  surfaceContainerLowest: '#0E0E10',
  surfaceContainerLow: '#1B1B1D',
  surfaceContainer: '#201F21',
  surfaceContainerHigh: '#2A2A2C',
  surfaceContainerHighest: '#353437',
  primary: '#7B68EE',
  secondary: '#00D9C0',
  tertiary: '#FFB86A',
  delta: '#4A90D9',
  theta: '#9B59B6',
  alpha: '#7B68EE',
  beta: '#E67E22',
  gamma: '#E74C3C',
}
```text

### Key Principles for Stitch
1. **Tonal surfaces**: Use the surface container hierarchy, not just gray shades
2. **No hard borders**: Use tonal separation with subtle outlineVariant borders only when necessary
3. **Consistent radius**: 16px for buttons, 20px for cards, 12px for inputs
4. **Purple + Turquoise**: Primary actions in purple, success/secondary in turquoise
5. **Space Grotesk headlines**: Use for all headlines, card titles
6. **Inter body**: Use for all body text, labels, tables
7. **Glass morphism**: Subtle backdrop blur for overlays, modals
8. **Aura glows**: Purple glow on focused/active elements, not shadows
