import { useState, useEffect, useCallback } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { supabase, type User, type Session } from '../lib/supabase'
import { ArrowLeft, Clock, Music, Download, Trash2, Ban } from 'lucide-react'
import { showSuccess, showError } from '../lib/toast'
import { useConfirmDialog } from '../components/ConfirmDialog'
import { reportError } from '../lib/errorReporter'

export function UserDetails() {
  const { userId } = useParams<{ userId: string }>()
  const navigate = useNavigate()
  const [user, setUser] = useState<User | null>(null)
  const [sessions, setSessions] = useState<Session[]>([])
  const [loading, setLoading] = useState(true)
  const [adsEnabled, setAdsEnabled] = useState<boolean | null>(null)
  const { confirm, dialog } = useConfirmDialog()

  useEffect(() => {
    if (userId) {
      fetchUserDetails()
      fetchUserSessions()
      fetchUserAdStatus()
    }
  }, [userId])

  const fetchUserDetails = async () => {
    try {
      const { data, error } = await supabase
        .from('users')
        .select('*')
        .eq('id', userId)
        .single()

      if (error) throw error
      setUser(data)
    } catch (err) {
      reportError(err)
    }
  }

  const fetchUserSessions = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('sessions')
        .select('*')
        .eq('user_id', userId)
        .order('started_at', { ascending: false })

      if (error) throw error
      setSessions(data || [])
    } catch (err) {
      reportError(err)
    } finally {
      setLoading(false)
    }
  }

  const fetchUserAdStatus = async () => {
    try {
      const { data, error } = await supabase
        .from('user_ad_settings')
        .select('ads_enabled')
        .eq('user_id', userId)
        .single()

      if (error && error.code !== 'PGRST116') throw error
      setAdsEnabled(data?.ads_enabled ?? null)
    } catch (err) {
      reportError(err)
    }
  }

  const toggleUserAds = async () => {
    if (!userId) return

    const newValue = adsEnabled === false ? true : false
    try {
      const { error } = await supabase
        .from('user_ad_settings')
        .upsert({
          user_id: userId,
          ads_enabled: newValue,
          updated_at: new Date().toISOString(),
        })

      if (error) throw error
      setAdsEnabled(newValue)
    } catch (err) {
      showError('Failed to update ad settings: ' + (err instanceof Error ? err.message : 'Unknown error'))
    }
  }

  const exportUserData = useCallback(async () => {
    if (!userId) return

    const { error } = await supabase.functions.invoke('export-data', {
      body: { userId },
    })

    if (error) {
      showError('Export failed: ' + error.message)
    } else {
      showSuccess('Data export initiated. Check your email.')
    }
  }, [userId])

  const deleteUser = useCallback(async () => {
    if (!userId) return
    
    const confirmed = await confirm({
      title: 'Delete User',
      message: 'Are you sure? This will permanently delete the user and all their data.',
      variant: 'danger',
      confirmLabel: 'Delete',
    })
    
    if (!confirmed) return

    const { error } = await supabase.from('users').delete().eq('id', userId)

    if (error) {
      showError('Delete failed: ' + error.message)
    } else {
      showSuccess('User deleted successfully')
      navigate('/users')
    }
  }, [confirm, userId, navigate])

  const formatDuration = (seconds: number | null) => {
    if (!seconds) return 'N/A'
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}m ${secs}s`
  }

  const getBandFromFrequency = (freq: number) => {
    if (freq < 4) return 'Delta'
    if (freq < 8) return 'Theta'
    if (freq < 12) return 'Alpha'
    if (freq < 30) return 'Beta'
    return 'Gamma'
  }

  if (!user) {
    return (
      <div className="flex justify-center py-16">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {dialog}
      {/* Header */}
      <div className="flex items-center space-x-4">
        <button
          onClick={() => navigate('/users')}
          className="p-2 text-text-secondary hover:text-white transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <h1 className="text-2xl font-bold text-white">User Details</h1>
          <p className="text-text-secondary font-mono">{userId}</p>
        </div>
      </div>

      {/* User Info Card */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="bg-surface rounded-lg p-4 border border-gray-800">
          <h3 className="text-sm font-medium text-text-secondary mb-1">Status</h3>
          <p className="text-white">{user.is_anonymous ? 'Anonymous' : 'Registered'}</p>
        </div>
        <div className="bg-surface rounded-lg p-4 border border-gray-800">
          <h3 className="text-sm font-medium text-text-secondary mb-1">Device</h3>
          <p className="text-white">{user.device_type || 'Unknown'}</p>
        </div>
        <div className="bg-surface rounded-lg p-4 border border-gray-800">
          <h3 className="text-sm font-medium text-text-secondary mb-1">App Version</h3>
          <p className="text-white">{user.app_version || 'Unknown'}</p>
        </div>
      </div>

      {/* Actions */}
      <div className="flex space-x-3">
        <button
          onClick={toggleUserAds}
          className={`flex items-center px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
            adsEnabled === false
              ? 'bg-green-500/20 text-green-400 hover:bg-green-500/30'
              : 'bg-yellow-500/20 text-yellow-400 hover:bg-yellow-500/30'
          }`}
        >
          <Ban className="w-4 h-4 mr-2" />
          {adsEnabled === false ? 'Ads Disabled (Click to Enable)' : 'Disable Ads for User'}
        </button>
        <button
          onClick={exportUserData}
          className="flex items-center px-4 py-2 bg-primary/20 text-primary rounded-lg text-sm font-medium hover:bg-primary/30 transition-colors"
        >
          <Download className="w-4 h-4 mr-2" />
          Export Data (GDPR)
        </button>
        <button
          onClick={deleteUser}
          className="flex items-center px-4 py-2 bg-red-500/20 text-red-400 rounded-lg text-sm font-medium hover:bg-red-500/30 transition-colors"
        >
          <Trash2 className="w-4 h-4 mr-2" />
          Delete User
        </button>
      </div>

      {/* Session History */}
      <div className="bg-surface rounded-lg border border-gray-800 overflow-hidden">
        <div className="px-4 py-3 border-b border-gray-800">
          <h2 className="text-lg font-semibold text-white flex items-center">
            <Clock className="w-5 h-5 mr-2 text-primary" />
            Session History ({sessions.length} sessions)
          </h2>
        </div>

        {loading ? (
          <div className="flex justify-center py-16">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
          </div>
        ) : sessions.length === 0 ? (
          <div className="px-4 py-8 text-center text-text-secondary">No sessions found</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-background">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Date</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Preset</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Band</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Beat Freq</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Duration</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Completed</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-800">
                {sessions.map((session) => (
                  <tr key={session.id} className="hover:bg-background/50">
                    <td className="px-4 py-3 text-sm text-text-secondary">
                      {new Date(session.started_at).toLocaleString()}
                    </td>
                    <td className="px-4 py-3 text-sm text-white font-mono">{session.preset_id?.slice(0, 8)}...</td>
                    <td className="px-4 py-3 text-sm">
                      <span
                        className={`inline-flex items-center px-2 py-1 rounded text-xs font-medium ${
                          getBandFromFrequency(session.beat_frequency) === 'Delta'
                            ? 'bg-blue-500/20 text-blue-400'
                            : getBandFromFrequency(session.beat_frequency) === 'Theta'
                            ? 'bg-purple-500/20 text-purple-400'
                            : getBandFromFrequency(session.beat_frequency) === 'Alpha'
                            ? 'bg-indigo-500/20 text-indigo-400'
                            : getBandFromFrequency(session.beat_frequency) === 'Beta'
                            ? 'bg-orange-500/20 text-orange-400'
                            : 'bg-red-500/20 text-red-400'
                        }`}
                      >
                        <Music className="w-3 h-3 mr-1" />
                        {getBandFromFrequency(session.beat_frequency)}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-sm text-white">{session.beat_frequency} Hz</td>
                    <td className="px-4 py-3 text-sm text-text-secondary">
                      {formatDuration(session.duration_seconds)}
                    </td>
                    <td className="px-4 py-3 text-sm">
                      {session.completed ? (
                        <span className="text-green-400">Yes</span>
                      ) : (
                        <span className="text-yellow-400">No</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
