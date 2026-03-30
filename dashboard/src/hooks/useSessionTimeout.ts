import { useEffect, useState } from 'react'
import { useAuth } from './useAuth'

const SESSION_TIMEOUT = 30 * 60 * 1000 // 30 minutes
const WARNING_BEFORE = 5 * 60 * 1000 // 5 minutes before timeout

export function useSessionTimeout() {
  const { user } = useAuth()
  const [showWarning, setShowWarning] = useState(false)
  const [timeRemaining, setTimeRemaining] = useState(0)

  useEffect(() => {
    if (!user) return

    let lastActivity = Date.now()
    let warningTimer: ReturnType<typeof setTimeout>
    let logoutTimer: ReturnType<typeof setTimeout>

    const resetTimers = () => {
      lastActivity = Date.now()
      setShowWarning(false)
      clearTimeout(warningTimer)
      clearTimeout(logoutTimer)

      warningTimer = setTimeout(() => {
        setShowWarning(true)
      }, SESSION_TIMEOUT - WARNING_BEFORE)

      logoutTimer = setTimeout(() => {
        window.location.href = '/logout'
      }, SESSION_TIMEOUT)
    }

    const updateTimeRemaining = () => {
      const elapsed = Date.now() - lastActivity
      const remaining = Math.max(0, SESSION_TIMEOUT - elapsed)
      setTimeRemaining(remaining)
    }

    const interval = setInterval(updateTimeRemaining, 1000)

    // Track user activity
    const events = ['mousedown', 'keydown', 'scroll', 'touchstart']
    events.forEach(event => {
      window.addEventListener(event, resetTimers)
    })

    resetTimers()

    return () => {
      clearTimeout(warningTimer)
      clearTimeout(logoutTimer)
      clearInterval(interval)
      events.forEach(event => {
        window.removeEventListener(event, resetTimers)
      })
    }
  }, [user])

  const extendSession = () => {
    setShowWarning(false)
    // Reset will happen automatically via activity
    window.dispatchEvent(new Event('mousedown'))
  }

  return { showWarning, timeRemaining, extendSession }
}
