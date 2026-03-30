import { useState, useEffect } from 'react'
import { Zap, AlertCircle, CheckCircle } from 'lucide-react'

interface RateLimitStatus {
  limit: number
  remaining: number
  resetTime: Date
  window: string
}

export function RateLimitDisplay() {
  const [status, setStatus] = useState<RateLimitStatus>({
    limit: 1000,
    remaining: 850,
    resetTime: new Date(Date.now() + 3600000),
    window: '1 hour',
  })

  useEffect(() => {
    const interval = setInterval(() => {
      setStatus((prev) => ({
        ...prev,
        remaining: Math.min(prev.limit, prev.remaining + 1),
      }))
    }, 5000)
    return () => clearInterval(interval)
  }, [])

  const percentage = (status.remaining / status.limit) * 100
  const isLow = percentage < 20

  return (
    <div className="bg-surface rounded-lg p-4 border border-gray-800">
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center">
          <Zap className={`w-5 h-5 mr-2 ${isLow ? 'text-red-400' : 'text-green-400'}`} />
          <h3 className="text-sm font-medium text-white">API Rate Limit</h3>
        </div>
        {isLow ? (
          <AlertCircle className="w-5 h-5 text-red-400" />
        ) : (
          <CheckCircle className="w-5 h-5 text-green-400" />
        )}
      </div>

      <div className="space-y-2">
        <div className="flex justify-between text-sm">
          <span className="text-text-secondary">Remaining</span>
          <span className={`font-medium ${isLow ? 'text-red-400' : 'text-white'}`}>
            {status.remaining} / {status.limit}
          </span>
        </div>

        <div className="w-full bg-background rounded-full h-2">
          <div
            className={`h-2 rounded-full transition-all ${
              isLow ? 'bg-red-400' : percentage < 50 ? 'bg-yellow-400' : 'bg-green-400'
            }`}
            style={{ width: `${percentage}%` }}
          />
        </div>

        <p className="text-xs text-text-secondary">
          Resets in {Math.ceil((status.resetTime.getTime() - Date.now()) / 60000)} minutes
        </p>
      </div>
    </div>
  )
}
