# GEMINI.md - MindWeave Instructional Context

## 📋 Project Overview
**MindWeave** is an open-source, enterprise-grade brainwave entrainment application. It provides scientifically-backed binaural beats and isochronic tones to help users achieve specific mental states (Delta, Theta, Alpha, Beta, Gamma).

- **Type:** Cross-platform (Mobile + Desktop) + Admin Dashboard
- **Frontend (App):** Flutter 3.19+ / Dart 3.3+
- **Frontend (Dashboard):** React 18+ (Vite, TypeScript, Tailwind CSS)
- **Backend:** Supabase (PostgreSQL, GoTrue Auth, Edge Functions)
- **Infrastructure:** Vercel (Dashboard), Supabase (Backend), Firebase (Remote Config/Analytics)

---

## 🏗️ Architecture & Structure

### Core Directories
- `lib/`: Flutter source code.
  - `core/`: Shared services (Auth, Analytics, Config, Theme), atoms, and utilities.
  - `features/`: Feature-based modules (Audio Engine, Navigation, Settings, Auth).
- `dashboard/`: React-based Admin Dashboard.
- `docs/`: Comprehensive project documentation (PRD, Tech Specs, Research, Diagrams).
- `supabase/`: Database migrations and configuration.
- `Concepts/`: Scientific and technical deep-dives.
- `.obsidian/WorkingMemory/`: Hidden space for tracking session state, tasks, and context.

### State Management
- **Flutter:** Uses **Riverpod 3.0+** with `ConsumerWidget` and providers defined in `features/`.
- **Dashboard:** Uses standard React state and hooks, with Supabase JS client.

### Audio Engine
- **Primary:** `flutter_soloud` (FFI) for real-time synthesis of pure sine waves.
- **Mixing:** `just_audio` for combining binaural beats with background music/ambient sounds.

---

## 🚀 Building and Running

### Prerequisites
- Flutter SDK (>=3.41.0)
- Node.js (for Dashboard)
- A `.env` file in the root (copied from `.env.example`)

### Flutter App
- **Run (Development):** `flutter run`
- **Build (Production):** Requires compile-time environment variables:
  ```bash
  flutter build <platform> \
    --dart-define=SUPABASE_URL=YOUR_URL \
    --dart-define=SUPABASE_ANON_KEY=YOUR_KEY \
    --dart-define=POSTHOG_API_KEY=YOUR_KEY
  ```

### Admin Dashboard
- **Location:** `cd dashboard/`
- **Commands:**
  - `npm install`: Install dependencies.
  - `npm run dev`: Start development server.
  - `npm run build`: Build for production (Vite + TSC).
  - `npm run lint`: Run ESLint.

---

## 🛠️ Development Conventions

### Coding Style
- **Flutter:** Follow standard Dart lints (`analysis_options.yaml`). Prefer clean code with clear separation between UI and logic (providers).
- **Dashboard:** Modern React with TypeScript. Use Tailwind CSS for styling.

### Environment Configuration
- Environment variables are managed via `EnvConfig` in `lib/core/config/env_config.dart`.
- Development: Uses `flutter_dotenv` to load from a `.env` file.
- Production: Uses `--dart-define` compile-time flags.

### Testing
- **Unit/Widget Tests:** Located in `test/`.
- **Integration Tests:** Located in `integration_test/`.
- Run tests: `flutter test`

---

## 📖 Key Documentation
- **Product Requirements:** `docs/prd/product_requirements_document.md`
- **Technical Specs:** `docs/tech_specs/technical_specifications.md`
- **Scientific Research:** `docs/research/neuroscience_audio_research.md`
- **Architecture Diagrams:** `docs/diagrams/` (Mermaid format)

---

## ⚠️ Known Constraints & TODOs
- **Riverpod:** `build_runner` is currently disabled due to version conflicts; providers are managed manually or as specified in the project status.
- **Analytics:** PostHog is conditionally initialized based on API key presence.
- **Captcha:** hCaptcha verification is required for authentication flows.
