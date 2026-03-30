import { Link, useLocation, useNavigate } from 'react-router-dom'
import { 
  LayoutDashboard, 
  BarChart3, 
  Users, 
  Music, 
  Settings, 
  FileText, 
  LogOut,
  AlertTriangle,
  Clock,
  Activity,
  Shield,
  DollarSign
} from 'lucide-react'
import { useAuth } from '../hooks/useAuth'
import { useSessionTimeout } from '../hooks/useSessionTimeout'
import { MobileNav } from './MobileNav'
import { RateLimitDisplay } from './RateLimitDisplay'
import { ThemeToggle } from './ThemeToggle'
import { OfflineIndicator } from '../hooks/useNetworkStatus'

interface LayoutProps {
  children: React.ReactNode
}

const navItems = [
  { path: '/', label: 'Dashboard', icon: LayoutDashboard },
  { path: '/analytics', label: 'Analytics', icon: BarChart3 },
  { path: '/users', label: 'Users', icon: Users },
  { path: '/presets', label: 'Presets', icon: Music },
  { path: '/ads', label: 'Ad Performance', icon: DollarSign },
  { path: '/config', label: 'Remote Config', icon: Settings },
  { path: '/audit', label: 'Audit Log', icon: FileText },
  { path: '/health', label: 'System Health', icon: Activity },
  { path: '/login-history', label: 'Login History', icon: Shield },
]

export function Layout({ children }: LayoutProps) {
  const location = useLocation()
  const navigate = useNavigate()
  const { signOut, user } = useAuth()
  const { showWarning, timeRemaining, extendSession } = useSessionTimeout()

  const handleSignOut = async () => {
    await signOut()
    navigate('/login')
  }

  const formatTime = (ms: number) => {
    const minutes = Math.floor(ms / 60000)
    const seconds = Math.floor((ms % 60000) / 1000)
    return `${minutes}:${seconds.toString().padStart(2, '0')}`
  }

  return (
    <div className="min-h-screen bg-background flex">
      <MobileNav />
      
      {/* Session Timeout Warning Modal */}
      {showWarning && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-surface rounded-lg p-6 border border-gray-800 max-w-md w-full mx-4">
            <div className="flex items-center mb-4">
              <AlertTriangle className="w-6 h-6 text-yellow-400 mr-3" />
              <h3 className="text-lg font-semibold text-white">Session Expiring Soon</h3>
            </div>
            <p className="text-text-secondary mb-4">
              Your session will expire in {formatTime(timeRemaining)} due to inactivity.
              Click below to stay logged in.
            </p>
            <div className="flex space-x-3">
              <button
                onClick={handleSignOut}
                className="flex-1 px-4 py-2 bg-background border border-gray-700 text-white rounded-lg hover:bg-gray-800 transition-colors"
              >
                Log Out
              </button>
              <button
                onClick={extendSession}
                className="flex-1 px-4 py-2 bg-primary text-white rounded-lg hover:bg-opacity-90 transition-colors flex items-center justify-center"
              >
                <Clock className="w-4 h-4 mr-2" />
                Stay Logged In
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Sidebar */}
      <aside className="hidden lg:flex w-64 bg-surface border-r border-gray-800 flex-col">
        <div className="p-6">
          <h1 className="text-xl font-bold text-white">MindWeave</h1>
          <p className="text-xs text-text-secondary mt-1">Admin Dashboard</p>
        </div>

        <nav className="flex-1 px-4 space-y-1">
          {navItems.map((item) => {
            const Icon = item.icon
            const isActive = location.pathname === item.path

            return (
              <Link
                key={item.path}
                to={item.path}
                aria-label={item.label}
                aria-current={isActive ? 'page' : undefined}
                className={`flex items-center px-4 py-3 rounded-lg text-sm font-medium transition-colors ${
                  isActive
                    ? 'bg-primary/20 text-primary'
                    : 'text-text-secondary hover:bg-gray-800 hover:text-white'
                }`}
              >
                <Icon className="w-5 h-5 mr-3" aria-hidden="true" />
                {item.label}
              </Link>
            )
          })}
        </nav>

        <div className="p-4 border-t border-gray-800 space-y-4">
          <RateLimitDisplay />
          <ThemeToggle />
          <div className="border-t border-gray-700 pt-4">
            <div className="px-2 mb-2">
              <p className="text-white font-medium truncate max-w-[200px] text-sm">
                {user?.email}
              </p>
            </div>
            <button
              onClick={handleSignOut}
              className="w-full flex items-center px-2 py-2 rounded-lg text-text-secondary hover:bg-gray-800 hover:text-red-400 transition-colors"
            >
              <LogOut className="w-5 h-5 mr-3" aria-hidden="true" />
              <span className="text-sm font-medium">Sign Out</span>
            </button>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <main className="flex-1 overflow-auto">
        <div className="p-8">{children}</div>
      </main>

      <OfflineIndicator />
    </div>
  )
}
