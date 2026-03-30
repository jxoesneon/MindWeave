import { useState, useEffect } from 'react'
import { supabase } from '../lib/supabase'
import { Activity, Database, Server, AlertTriangle, CheckCircle, Clock } from 'lucide-react'
import { ServerStats } from '../components/ServerStats'
import { RateLimitDisplay } from '../components/RateLimitDisplay'

interface HealthStatus {
  api: 'healthy' | 'degraded' | 'down'
  database: 'healthy' | 'degraded' | 'down'
  latency: number
  lastChecked: Date
}

export function SystemHealth() {
  const [status, setStatus] = useState<HealthStatus>({
    api: 'healthy',
    database: 'healthy',
    latency: 0,
    lastChecked: new Date(),
  })

  useEffect(() => {
    checkHealth()
    const interval = setInterval(checkHealth, 30000)
    return () => clearInterval(interval)
  }, [])

  const checkHealth = async () => {
    const start = Date.now()
    try {
      const { error } = await supabase.from('users').select('count', { count: 'exact', head: true })
      const latency = Date.now() - start

      setStatus({
        api: error ? 'down' : latency > 1000 ? 'degraded' : 'healthy',
        database: error ? 'down' : 'healthy',
        latency,
        lastChecked: new Date(),
      })
    } catch {
      setStatus({
        api: 'down',
        database: 'down',
        latency: 0,
        lastChecked: new Date(),
      })
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'healthy': return 'text-green-400'
      case 'degraded': return 'text-yellow-400'
      case 'down': return 'text-red-400'
      default: return 'text-text-secondary'
    }
  }

  const getStatusBg = (status: string) => {
    switch (status) {
      case 'healthy': return 'bg-green-500/20'
      case 'degraded': return 'bg-yellow-500/20'
      case 'down': return 'bg-red-500/20'
      default: return 'bg-gray-800'
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-white">System Health</h1>
        <p className="text-text-secondary">Monitor dashboard and API status</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className={`rounded-lg p-6 border border-gray-800 ${getStatusBg(status.api)}`}>
          <div className="flex items-center justify-between mb-4">
            <Server className="w-6 h-6 text-white" />
            <span className={`text-sm font-medium ${getStatusColor(status.api)}`}>
              {status.api.toUpperCase()}
            </span>
          </div>
          <h3 className="text-lg font-semibold text-white">API Status</h3>
          <p className="text-sm text-text-secondary mt-1">
            {status.latency > 0 ? `${status.latency}ms latency` : 'Checking...'}
          </p>
        </div>

        <div className={`rounded-lg p-6 border border-gray-800 ${getStatusBg(status.database)}`}>
          <div className="flex items-center justify-between mb-4">
            <Database className="w-6 h-6 text-white" />
            <span className={`text-sm font-medium ${getStatusColor(status.database)}`}>
              {status.database.toUpperCase()}
            </span>
          </div>
          <h3 className="text-lg font-semibold text-white">Database</h3>
          <p className="text-sm text-text-secondary mt-1">PostgreSQL connection</p>
        </div>

        <div className="bg-surface rounded-lg p-6 border border-gray-800">
          <div className="flex items-center justify-between mb-4">
            <Clock className="w-6 h-6 text-white" />
            <Activity className="w-5 h-5 text-primary" />
          </div>
          <h3 className="text-lg font-semibold text-white">Last Checked</h3>
          <p className="text-sm text-text-secondary mt-1">
            {status.lastChecked.toLocaleTimeString()}
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <RateLimitDisplay />
      </div>

      <ServerStats />

      <div className="bg-surface rounded-lg p-6 border border-gray-800">
        <h3 className="text-lg font-semibold text-white mb-4">Status Legend</h3>
        <div className="space-y-3">
          <div className="flex items-center">
            <CheckCircle className="w-5 h-5 text-green-400 mr-3" />
            <span className="text-white">Healthy - All systems operational</span>
          </div>
          <div className="flex items-center">
            <AlertTriangle className="w-5 h-5 text-yellow-400 mr-3" />
            <span className="text-white">Degraded - High latency detected</span>
          </div>
          <div className="flex items-center">
            <Activity className="w-5 h-5 text-red-400 mr-3" />
            <span className="text-white">Down - Service unavailable</span>
          </div>
        </div>
      </div>
    </div>
  )
}
