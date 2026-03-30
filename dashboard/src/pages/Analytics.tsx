import { useDailyActiveUsers, useFrequencyBandStats, useMonthlyActiveUsers, useSessionDurationDistribution, useDonationMetrics } from '../hooks/useAnalytics'
import { exportToCSV } from '../lib/export'
import { showSuccess } from '../lib/toast'
import { useState, useEffect } from 'react'
import { 
  LineChart, 
  Line, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell
} from 'recharts'
import { BarChart3, Users, Music, Calendar, Clock, Heart } from 'lucide-react'

const COLORS = {
  Delta: '#4A90D9',
  Theta: '#9B59B6',
  Alpha: '#7B68EE',
  Beta: '#E67E22',
  Gamma: '#E74C3C',
}

export function Analytics() {
  const { data: dailyData, loading: dailyLoading } = useDailyActiveUsers(30)
  const { data: monthlyData, loading: monthlyLoading } = useMonthlyActiveUsers(6)
  const { data: durationData, loading: durationLoading } = useSessionDurationDistribution()
  const { data: donationData, loading: donationLoading, totalAmount, totalCount } = useDonationMetrics(6)
  const { data: bandStats, loading: bandsLoading } = useFrequencyBandStats()
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    // Small delay to ensure DOM containers have dimensions
    const timer = setTimeout(() => setMounted(true), 100)
    return () => clearTimeout(timer)
  }, [])

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-white">Analytics</h1>
        <p className="text-text-secondary">Detailed insights into app usage</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2">
          <div className="bg-surface rounded-lg p-4 border border-gray-800">
            <h3 className="text-sm font-medium text-white mb-3">Date Range</h3>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-xs text-text-secondary mb-1">Start Date</label>
                <input
                  type="date"
                  className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white text-sm"
                />
              </div>
              <div>
                <label className="block text-xs text-text-secondary mb-1">End Date</label>
                <input
                  type="date"
                  className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white text-sm"
                />
              </div>
            </div>
          </div>
        </div>
        <div className="flex items-end">
          <button
            onClick={() => {
              exportToCSV(dailyData || [], 'daily_active_users')
              showSuccess('Analytics data exported')
            }}
            className="w-full px-4 py-2 bg-surface border border-gray-700 text-white rounded-lg hover:bg-gray-800 transition-colors"
          >
            Export All Data
          </button>
        </div>
      </div>
      <div className="bg-surface rounded-lg p-6 border border-gray-800">
        <h2 className="text-lg font-semibold text-white mb-4 flex items-center">
          <Users className="w-5 h-5 mr-2 text-primary" />
          Daily Active Users (Last 30 Days)
        </h2>
        
        {dailyLoading || !mounted ? (
          <div className="flex justify-center py-16">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
          </div>
        ) : (
          <div style={{ height: '320px', minHeight: '200px' }}>
            <ResponsiveContainer width="100%" height="100%" aspect={2}>
              <LineChart data={dailyData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#333" />
                <XAxis 
                  dataKey="date" 
                  stroke="#666"
                  tickFormatter={(value) => {
                    const date = new Date(value)
                    return `${date.getMonth() + 1}/${date.getDate()}`
                  }}
                />
                <YAxis stroke="#666" />
                <Tooltip 
                  contentStyle={{ 
                    backgroundColor: '#1A1A1F', 
                    border: '1px solid #333',
                    borderRadius: '8px'
                  }}
                  labelStyle={{ color: '#fff' }}
                />
                <Line 
                  type="monotone" 
                  dataKey="value" 
                  stroke="#7B68EE" 
                  strokeWidth={2}
                  dot={false}
                />
              </LineChart>
            </ResponsiveContainer>
          </div>
        )}
      </div>

      {/* Monthly Active Users Chart */}
      <div className="bg-surface rounded-lg p-6 border border-gray-800">
        <h2 className="text-lg font-semibold text-white mb-4 flex items-center">
          <Calendar className="w-5 h-5 mr-2 text-primary" />
          Monthly Active Users (Last 6 Months)
        </h2>
        
        {monthlyLoading || !mounted ? (
          <div className="flex justify-center py-16">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
          </div>
        ) : (
          <div style={{ height: '320px', minHeight: '200px' }}>
            <ResponsiveContainer width="100%" height="100%" aspect={2}>
              <BarChart data={monthlyData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#333" />
                <XAxis dataKey="date" stroke="#666" />
                <YAxis stroke="#666" />
                <Tooltip 
                  contentStyle={{ 
                    backgroundColor: '#1A1A1F', 
                    border: '1px solid #333',
                    borderRadius: '8px'
                  }}
                  labelStyle={{ color: '#fff' }}
                />
                <Bar dataKey="value" fill="#7B68EE" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}
      </div>

      {/* Session Duration Distribution */}
      <div className="bg-surface rounded-lg p-6 border border-gray-800">
        <h2 className="text-lg font-semibold text-white mb-4 flex items-center">
          <Clock className="w-5 h-5 mr-2 text-primary" />
          Session Duration Distribution
        </h2>
        
        {durationLoading || !mounted ? (
          <div className="flex justify-center py-16">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
          </div>
        ) : (
          <div style={{ height: '256px', minHeight: '160px' }}>
            <ResponsiveContainer width="100%" height="100%" aspect={2}>
              <BarChart data={durationData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#333" />
                <XAxis dataKey="range" stroke="#666" />
                <YAxis stroke="#666" />
                <Tooltip 
                  contentStyle={{ 
                    backgroundColor: '#1A1A1F', 
                    border: '1px solid #333',
                    borderRadius: '8px'
                  }}
                />
                <Bar dataKey="count" fill="#4A90D9" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Frequency Band Distribution */}
        <div className="bg-surface rounded-lg p-6 border border-gray-800">
          <h2 className="text-lg font-semibold text-white mb-4 flex items-center">
            <Music className="w-5 h-5 mr-2 text-primary" />
            Frequency Band Distribution
          </h2>
          
          {bandsLoading || !mounted ? (
            <div className="flex justify-center py-16">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
            </div>
          ) : (
            <div style={{ height: '256px', minHeight: '160px' }}>
              <ResponsiveContainer width="100%" height="100%" aspect={2}>
                <BarChart data={bandStats}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#333" />
                  <XAxis dataKey="band" stroke="#666" />
                  <YAxis stroke="#666" />
                  <Tooltip 
                    contentStyle={{ 
                      backgroundColor: '#1A1A1F', 
                      border: '1px solid #333',
                      borderRadius: '8px'
                    }}
                  />
                  <Bar dataKey="count" radius={[4, 4, 0, 0]}>
                    {bandStats.map((entry, index) => (
                      <Cell 
                        key={`cell-${index}`} 
                        fill={COLORS[entry.band as keyof typeof COLORS]} 
                      />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </div>
          )}
        </div>

        {/* Pie Chart */}
        <div className="bg-surface rounded-lg p-6 border border-gray-800">
          <h2 className="text-lg font-semibold text-white mb-4 flex items-center">
            <BarChart3 className="w-5 h-5 mr-2 text-primary" />
            Band Usage Percentage
          </h2>
          
          {bandsLoading || !mounted ? (
            <div className="flex justify-center py-16">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
            </div>
          ) : (
            <div style={{ height: '256px', minHeight: '160px' }}>
              <ResponsiveContainer width="100%" height="100%" aspect={2}>
                <PieChart>
                  <Pie
                    data={bandStats}
                    cx="50%"
                    cy="50%"
                    labelLine={false}
                    label={({ name, value }) => `${name || ''} ${value || 0}%`}
                    outerRadius={80}
                    fill="#8884d8"
                    dataKey="count"
                  >
                    {bandStats.map((entry, index) => (
                      <Cell 
                        key={`cell-${index}`} 
                        fill={COLORS[entry.band as keyof typeof COLORS]} 
                      />
                    ))}
                  </Pie>
                  <Tooltip 
                    contentStyle={{ 
                      backgroundColor: '#1A1A1F', 
                      border: '1px solid #333',
                      borderRadius: '8px'
                    }}
                  />
                </PieChart>
              </ResponsiveContainer>
            </div>
          )}
        </div>
      </div>

      {/* Donation Metrics */}
      <div className="bg-surface rounded-lg p-6 border border-gray-800">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-white flex items-center">
            <Heart className="w-5 h-5 mr-2 text-red-400" />
            Donation Metrics (Last 6 Months)
          </h2>
          <div className="flex space-x-4 text-sm">
            <div className="text-text-secondary">
              Total: <span className="text-white font-medium">${totalAmount.toFixed(2)}</span>
            </div>
            <div className="text-text-secondary">
              Donors: <span className="text-white font-medium">{totalCount}</span>
            </div>
          </div>
        </div>
        
        {donationLoading || !mounted ? (
          <div className="flex justify-center py-16">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
          </div>
        ) : (
          <div style={{ height: '256px', minHeight: '160px' }}>
            <ResponsiveContainer width="100%" height="100%" aspect={2}>
              <BarChart data={donationData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#333" />
                <XAxis dataKey="date" stroke="#666" />
                <YAxis stroke="#666" />
                <Tooltip 
                  contentStyle={{ 
                    backgroundColor: '#1A1A1F', 
                    border: '1px solid #333',
                    borderRadius: '8px'
                  }}
                  formatter={(value, name) => {
                    const numValue = typeof value === 'number' ? value : undefined
                    if (numValue === undefined) return ['-', String(name)]
                    if (name === 'amount') return [`$${numValue.toFixed(2)}`, 'Amount']
                    return [String(numValue), 'Donors']
                  }}
                />
                <Bar dataKey="amount" fill="#10B981" radius={[4, 4, 0, 0]} />
                <Bar dataKey="count" fill="#34D399" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}
      </div>
    </div>
  )
}
