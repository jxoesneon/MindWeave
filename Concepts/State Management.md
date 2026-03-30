# State Management: Riverpod

MindWeave uses **Riverpod** for robust, type-safe, and testable state management.

## 🏗️ Architecture Layer
The app follows a "Feature-first" approach with clear separation of concerns:
1.  **Providers**: Expose state and services to the UI.
2.  **Controllers**: Logic handlers (e.g., `AudioController`).
3.  **Repositories**: Data access (Supabase, Hive).
4.  **UI**: Purely representational widgets.

## 🔄 Core Providers
- `AudioController`: Manages the `flutter_soloud` lifecycle and current session state.
- `RemoteConfigController`: Synchronizes with Supabase for feature flags.
- `SessionProvider`: Tracks active session duration and history.
- `SettingsProvider`: Local persistence for user preferences (Dark Mode, default carrier).

## 🧪 Testing Strategy
- Use `ProviderContainer` for unit tests.
- Mock repositories and services using `mockito` or `mocktail`.
- Ensure side effects (like audio playback) are isolated from business logic.
