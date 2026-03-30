import { useAnalytics, useFrequencyBandStats, useRealtimeUserCount } from '../hooks/useAnalytics'
import { 
  Users, 
  Activity, 
  Clock, 
  Heart, 
  TrendingUp,
  Music,
  Radio
} from 'lucide-react'

function StatCard({ 
  title, 
  value, 
  icon: Icon, 
  subtitle 
}: { 
  title: string
  value: string | number
  icon: React.ElementType
  subtitle?: string 
}) {
  return (
    <div className="bg-surface rounded-lg p-6 border border-gray-800">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-text-secondary text-sm">{title}</p>
          <p className="text-2xl font-bold text-white mt-2">{value}</p>
          {subtitle && (
            <p className="text-xs text-text-secondary mt-1">{subtitle}</p>
          )}
        </div>
        <div className="p-3 bg-primary/10 rounded-lg">
          <Icon className="w-5 h-5 text-primary" />
        </div>
      </div>
    </div>
  )
}

export function Dashboard() {
  const { stats, loading } = useAnalytics()
  const { data: bandStats, loading: bandsLoading } = useFrequencyBandStats()
  const realtimeCount = useRealtimeUserCount()

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-white">Dashboard</h1>
        <p className="text-text-secondary">Overview of your MindWeave app</p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <StatCard
          title="Total Users"
          value={stats.totalUsers.toLocaleString()}
          icon={Users}
          subtitle="All time registered users"
        />
        <StatCard
          title="Active Today"
          value={stats.activeUsersToday.toLocaleString()}
          icon={Activity}
          subtitle="Users with sessions today"
        />
        <StatCard
          title="Active This Month"
          value={stats.activeUsersMonth.toLocaleString()}
          icon={TrendingUp}
          subtitle="Monthly active users"
        />
        <StatCard
          title="Total Sessions"
          value={stats.totalSessions.toLocaleString()}
          icon={Clock}
          subtitle="All time sessions"
        />
        <StatCard
          title="Avg Session Duration"
          value={`${stats.avgSessionDuration} min`}
          icon={Clock}
          subtitle="Average time per session"
        />
        <StatCard
          title="Active Now"
          value={realtimeCount.toLocaleString()}
          icon={Radio}
          subtitle="Users in last 5 min"
        />
        <StatCard
          title="Donations"
          value={`$${stats.donationAmount.toLocaleString()}`}
          icon={Heart}
          subtitle={`${stats.totalDonations} contributors`}
        />
      </div>

      {/* Frequency Bands */}
      <div className="bg-surface rounded-lg p-6 border border-gray-800">
        <h2 className="text-lg font-semibold text-white mb-4 flex items-center">
          <Music className="w-5 h-5 mr-2 text-primary" />
          Frequency Band Usage
        </h2>
        
        {bandsLoading ? (
          <div className="flex justify-center py-8">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
          </div>
        ) : (
          <div className="grid grid-cols-5 gap-4">
            {bandStats.map((band) => (
              <div 
                key={band.band}
                className="text-center p-4 rounded-lg bg-background"
              >
                <div className={`text-2xl font-bold ${
                  band.band === 'Delta' ? 'text-accent-delta' :
                  band.band === 'Theta' ? 'text-accent-theta' :
                  band.band === 'Alpha' ? 'text-accent-alpha' :
                  band.band === 'Beta' ? 'text-accent-beta' :
                  'text-accent-gamma'
                }`}>
                  {band.percentage}%
                </div>
                <div className="text-sm text-text-secondary mt-1">{band.band}</div>
                <div className="text-xs text-gray-500">{band.count} sessions</div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
