import { useState, useEffect } from 'react'
import { Moon, Sun, Monitor } from 'lucide-react'

type Theme = 'dark' | 'light' | 'system'

export function ThemeToggle() {
  const [theme, setTheme] = useState<Theme>('dark')

  useEffect(() => {
    const saved = localStorage.getItem('theme')
    const validThemes: Theme[] = ['dark', 'light', 'system']
    if (saved && validThemes.includes(saved as Theme)) {
      setTheme(saved as Theme)
    } else {
      // Default to dark if no saved preference
      setTheme('dark')
      document.documentElement.classList.add('dark')
    }
  }, [])

  useEffect(() => {
    localStorage.setItem('theme', theme)
    
    const applyTheme = () => {
      // Remove dark class first
      document.documentElement.classList.remove('dark')
      
      if (theme === 'dark') {
        document.documentElement.classList.add('dark')
      } else if (theme === 'light') {
        // Light mode - no dark class
      } else {
        // System preference
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
        if (prefersDark) {
          document.documentElement.classList.add('dark')
        }
      }
    }
    
    applyTheme()
    
    // Listen for system preference changes when in system mode
    if (theme === 'system') {
      const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
      const handleChange = () => applyTheme()
      mediaQuery.addEventListener('change', handleChange)
      return () => mediaQuery.removeEventListener('change', handleChange)
    }
  }, [theme])

  const options: { value: Theme; icon: typeof Moon; label: string }[] = [
    { value: 'dark', icon: Moon, label: 'Dark' },
    { value: 'light', icon: Sun, label: 'Light' },
    { value: 'system', icon: Monitor, label: 'System' },
  ]

  return (
    <div className="bg-surface rounded-lg p-3 border border-gray-800">
      <div className="flex space-x-1">
        {options.map((option) => {
          const Icon = option.icon
          return (
            <button
              key={option.value}
              onClick={() => setTheme(option.value)}
              title={option.label}
              className={`
                group flex items-center rounded-lg transition-all duration-300 ease-out
                overflow-hidden whitespace-nowrap
                ${theme === option.value
                  ? 'bg-primary text-white w-24'
                  : 'bg-background text-text-secondary hover:text-white hover:w-24 w-9'
                }
              `}
            >
              <span className="flex items-center justify-center w-9 h-9 flex-shrink-0">
                <Icon className="w-4 h-4" />
              </span>
              <span className="text-sm font-medium pr-3 opacity-100">
                {option.label}
              </span>
            </button>
          )
        })}
      </div>
    </div>
  )
}
