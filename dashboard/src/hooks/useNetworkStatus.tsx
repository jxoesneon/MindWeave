import { useState, useEffect } from 'react'
import { Wifi, WifiOff } from 'lucide-react'

export function useNetworkStatus() {
  const [isOnline, setIsOnline] = useState(navigator.onLine)

  useEffect(() => {
    const handleOnline = () => setIsOnline(true)
    const handleOffline = () => setIsOnline(false)

    window.addEventListener('online', handleOnline)
    window.addEventListener('offline', handleOffline)

    return () => {
      window.removeEventListener('online', handleOnline)
      window.removeEventListener('offline', handleOffline)
    }
  }, [])

  return isOnline
}

export function OfflineIndicator() {
  const isOnline = useNetworkStatus()

  if (isOnline) return null

  return (
    <div className="fixed bottom-4 right-4 bg-red-500/90 text-white px-4 py-2 rounded-lg shadow-lg flex items-center z-50">
      <WifiOff className="w-4 h-4 mr-2" />
      <span className="text-sm font-medium">Offline</span>
    </div>
  )
}

export function NetworkStatusBadge() {
  const isOnline = useNetworkStatus()

  return (
    <div className={`flex items-center px-2 py-1 rounded text-xs ${
      isOnline ? 'bg-green-500/20 text-green-400' : 'bg-red-500/20 text-red-400'
    }`}>
      {isOnline ? (
        <>
          <Wifi className="w-3 h-3 mr-1" />
          Online
        </>
      ) : (
        <>
          <WifiOff className="w-3 h-3 mr-1" />
          Offline
        </>
      )}
    </div>
  )
}
