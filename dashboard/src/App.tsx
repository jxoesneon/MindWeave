import { Suspense, lazy, useEffect } from 'react'
import { Routes, Route } from 'react-router-dom'
import { ErrorBoundary } from './components/ErrorBoundary'
import { Layout } from './components/Layout'
import { PageLoader } from './components/LoadingSkeletons'
import { Login } from './pages/Login'
import { Dashboard } from './pages/Dashboard'
import { useAuth } from './hooks/useAuth'

// Lazy load heavy pages
const Analytics = lazy(() => import('./pages/Analytics').then(m => ({ default: m.Analytics })))
const Users = lazy(() => import('./pages/Users').then(m => ({ default: m.Users })))
const UserDetails = lazy(() => import('./pages/UserDetails').then(m => ({ default: m.UserDetails })))
const Presets = lazy(() => import('./pages/Presets').then(m => ({ default: m.Presets })))
const RemoteConfig = lazy(() => import('./pages/RemoteConfig').then(m => ({ default: m.RemoteConfig })))
const AuditLog = lazy(() => import('./pages/AuditLog').then(m => ({ default: m.AuditLog })))
const SystemHealth = lazy(() => import('./pages/SystemHealth').then(m => ({ default: m.SystemHealth })))
const LoginHistory = lazy(() => import('./pages/LoginHistory').then(m => ({ default: m.LoginHistory })))
const AdPerformance = lazy(() => import('./pages/AdPerformance').then(m => ({ default: m.AdPerformance })))
const NotFound = lazy(() => import('./pages/NotFound').then(m => ({ default: m.NotFound })))

function App() {
  const { user, loading, isAdmin, authError } = useAuth()

  // Initialize theme on mount (runs before login)
  useEffect(() => {
    const saved = localStorage.getItem('theme')
    if (!saved) {
      // Default to dark if no saved preference
      document.documentElement.classList.add('dark')
    } else if (saved === 'dark') {
      document.documentElement.classList.add('dark')
    } else if (saved === 'light') {
      document.documentElement.classList.remove('dark')
    } else {
      // System preference
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
      if (prefersDark) {
        document.documentElement.classList.add('dark')
      }
    }
  }, [])

  if (loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!user) {
    return <Login />
  }

  if (!isAdmin) {
    const handleReset = () => {
      // Clear all Supabase-related cookies
      const cookies = document.cookie.split(';')
      cookies.forEach(cookie => {
        const [name] = cookie.split('=')
        if (name.trim().startsWith('sb-')) {
          document.cookie = name.trim() + '=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/; domain=' + window.location.hostname
        }
      })
      // Clear all storage
      localStorage.clear()
      sessionStorage.clear()
      // Hard reload
      window.location.href = '/'
    }

    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center max-w-md px-4">
          <div className="mb-6">
            <svg className="w-16 h-16 mx-auto text-yellow-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
          </div>
          <h1 className="text-2xl font-bold text-white mb-2">Connection Issue</h1>
          <p className="text-text-secondary mb-4">
            We're having trouble verifying your admin access. This usually happens after a page refresh or when the connection times out.
          </p>
          {authError && (
            <div className="bg-yellow-500/10 border border-yellow-500/30 rounded-lg p-3 mb-4">
              <p className="text-yellow-400 text-sm font-mono">{authError}</p>
            </div>
          )}
          <div className="space-y-3">
            <button
              onClick={() => window.location.reload()}
              className="w-full px-4 py-2 bg-primary text-white rounded-lg hover:bg-opacity-90 transition-colors"
            >
              Try Again
            </button>
            <button
              onClick={handleReset}
              className="w-full px-4 py-2 bg-surface border border-gray-700 text-text-secondary rounded-lg hover:bg-gray-800 transition-colors text-sm"
            >
              Sign Out & Clear Session
            </button>
          </div>
          <p className="text-text-secondary/60 text-xs mt-4">
            Tip: If "Try Again" doesn't work, use "Sign Out & Clear Session" to start fresh.
          </p>
        </div>
      </div>
    )
  }

  return (
    <ErrorBoundary>
      <Layout>
        <Suspense fallback={<PageLoader />}>
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/analytics" element={<Analytics />} />
            <Route path="/users" element={<Users />} />
            <Route path="/users/:userId" element={<UserDetails />} />
            <Route path="/presets" element={<Presets />} />
            <Route path="/config" element={<RemoteConfig />} />
            <Route path="/audit" element={<AuditLog />} />
            <Route path="/health" element={<SystemHealth />} />
            <Route path="/login-history" element={<LoginHistory />} />
            <Route path="/ads" element={<AdPerformance />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </Suspense>
      </Layout>
    </ErrorBoundary>
  )
}

export default App
