import { useState, useEffect, useMemo, useCallback } from 'react'
import { reportError } from '../lib/errorReporter'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'
import { TrendingUp, DollarSign, Users, MousePointer } from 'lucide-react'

interface AdMetrics {
  date: string
  impressions: number
  clicks: number
  revenue: number
  ctr: number
}

interface StatCardProps {
  icon: React.ElementType
  title: string
  value: string
  subtitle?: string
}

export function AdPerformance() {
  const [metrics, setMetrics] = useState<AdMetrics[]>([])
  const [loading, setLoading] = useState(true)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  useEffect(() => {
    fetchAdMetrics()
  }, [])

  const fetchAdMetrics = useCallback(async () => {
    try {
      setLoading(true)
      // Mock data since ad table might not exist yet
      const mockData: AdMetrics[] = [
        { date: '2024-01', impressions: 15000, clicks: 450, revenue: 45.0, ctr: 3.0 },
        { date: '2024-02', impressions: 18000, clicks: 540, revenue: 54.0, ctr: 3.0 },
        { date: '2024-03', impressions: 22000, clicks: 660, revenue: 66.0, ctr: 3.0 },
        { date: '2024-04', impressions: 25000, clicks: 750, revenue: 75.0, ctr: 3.0 },
        { date: '2024-05', impressions: 28000, clicks: 840, revenue: 84.0, ctr: 3.0 },
        { date: '2024-06', impressions: 32000, clicks: 960, revenue: 96.0, ctr: 3.0 },
      ]
      
      setMetrics(mockData)
    } catch (err) {
      reportError(err)
    } finally {
      setLoading(false)
    }
  }, [])

  // Memoize expensive calculations
  const summary = useMemo(() => {
    if (metrics.length === 0) {
      return {
        totalImpressions: 0,
        totalClicks: 0,
        totalRevenue: 0,
        avgCtr: 0,
      }
    }
    
    return {
      totalImpressions: metrics.reduce((a, b) => a + b.impressions, 0),
      totalClicks: metrics.reduce((a, b) => a + b.clicks, 0),
      totalRevenue: metrics.reduce((a, b) => a + b.revenue, 0),
      avgCtr: metrics.reduce((a, b) => a + b.ctr, 0) / metrics.length,
    }
  }, [metrics])

  const StatCard = ({ icon: Icon, title, value, subtitle }: StatCardProps) => (
    <div className="bg-surface rounded-lg p-4 border border-gray-800">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-text-secondary text-sm">{title}</p>
          <p className="text-2xl font-bold text-white mt-1">{value}</p>
          {subtitle && <p className="text-xs text-text-secondary mt-1">{subtitle}</p>}
        </div>
        <div className="p-2 bg-primary/10 rounded-lg">
          <Icon className="w-5 h-5 text-primary" />
        </div>
      </div>
    </div>
  )

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-white">Ad Performance</h1>
        <p className="text-text-secondary">Track ad impressions, clicks, and revenue</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          icon={TrendingUp}
          title="Total Impressions"
          value={summary.totalImpressions.toLocaleString()}
          subtitle="Last 6 months"
        />
        <StatCard
          icon={MousePointer}
          title="Total Clicks"
          value={summary.totalClicks.toLocaleString()}
          subtitle={`CTR: ${summary.avgCtr.toFixed(2)}%`}
        />
        <StatCard
          icon={DollarSign}
          title="Revenue"
          value={`$${summary.totalRevenue.toFixed(2)}`}
          subtitle="Estimated"
        />
        <StatCard
          icon={Users}
          title="Ad Viewers"
          value={Math.round(summary.totalImpressions / 3).toLocaleString()}
          subtitle="Unique users"
        />
      </div>

      {loading || !mounted ? (
        <div className="flex justify-center py-16">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        </div>
      ) : (
        <div className="bg-surface rounded-lg p-6 border border-gray-800">
          <h2 className="text-lg font-semibold text-white mb-4">Monthly Performance</h2>
          <div style={{ height: '320px', minHeight: '200px' }}>
            <ResponsiveContainer width="100%" height="100%" aspect={2}>
              <LineChart data={metrics}>
                <CartesianGrid strokeDasharray="3 3" stroke="#333" />
                <XAxis dataKey="date" stroke="#666" />
                <YAxis stroke="#666" />
                <Tooltip
                  contentStyle={{
                    backgroundColor: '#1A1A1F',
                    border: '1px solid #333',
                    borderRadius: '8px',
                  }}
                />
                <Line type="monotone" dataKey="impressions" stroke="#7B68EE" name="Impressions" />
                <Line type="monotone" dataKey="clicks" stroke="#4A90D9" name="Clicks" />
                <Line type="monotone" dataKey="revenue" stroke="#10B981" name="Revenue ($)" />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>
      )}
    </div>
  )
}
