import { useState, useEffect } from 'react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import { Menu, X, LogOut } from 'lucide-react'
import { useAuth } from '../hooks/useAuth'

const navItems = [
  { path: '/', label: 'Dashboard' },
  { path: '/analytics', label: 'Analytics' },
  { path: '/users', label: 'Users' },
  { path: '/presets', label: 'Presets' },
  { path: '/config', label: 'Remote Config' },
  { path: '/audit', label: 'Audit Log' },
  { path: '/health', label: 'System Health' },
  { path: '/login-history', label: 'Login History' },
]

export function MobileNav() {
  const [isOpen, setIsOpen] = useState(false)
  const location = useLocation()
  const navigate = useNavigate()
  const { signOut, user } = useAuth()

  useEffect(() => {
    setIsOpen(false)
  }, [location.pathname])

  const handleSignOut = async () => {
    await signOut()
    navigate('/login')
  }

  return (
    <div className="lg:hidden">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="fixed top-4 left-4 z-50 p-2 bg-surface border border-gray-700 rounded-lg text-white"
      >
        {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
      </button>

      {isOpen && (
        <div className="fixed inset-0 z-40">
          <div
            className="absolute inset-0 bg-black/50"
            onClick={() => setIsOpen(false)}
          />
          <nav className="absolute top-0 left-0 h-full w-64 bg-surface border-r border-gray-800 p-4 pt-16 flex flex-col">
            <div className="space-y-1 flex-1">
              {navItems.map((item) => {
                const isActive = location.pathname === item.path
                return (
                  <Link
                    key={item.path}
                    to={item.path}
                    className={`block px-4 py-3 rounded-lg text-sm font-medium transition-colors ${
                      isActive
                        ? 'bg-primary/20 text-primary'
                        : 'text-text-secondary hover:bg-gray-800 hover:text-white'
                    }`}
                  >
                    {item.label}
                  </Link>
                )
              })}
            </div>
            
            {/* Mobile Logout Button */}
            <div className="border-t border-gray-800 pt-4 mt-4">
              <div className="px-4 py-2 text-sm text-text-secondary truncate">
                {user?.email}
              </div>
              <button
                onClick={handleSignOut}
                className="w-full flex items-center px-4 py-3 rounded-lg text-sm font-medium text-text-secondary hover:bg-gray-800 hover:text-red-400 transition-colors"
              >
                <LogOut className="w-5 h-5 mr-3" />
                Sign Out
              </button>
            </div>
          </nav>
        </div>
      )}
    </div>
  )
}
