import { useState, useEffect } from 'react'
import { supabase } from '../lib/supabase'
import { CheckCircle, XCircle } from 'lucide-react'
import { reportError } from '../lib/errorReporter'

interface LoginAttempt {
  id: string
  email: string
  success: boolean
  failure_reason: string | null
  ip_address: string
  created_at: string
}

export function LoginHistory() {
  const [attempts, setAttempts] = useState<LoginAttempt[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchLoginHistory()
  }, [])

  const fetchLoginHistory = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('admin_login_history')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(50)

      if (error) {
        // Check if table doesn't exist
        if (error.message?.includes('does not exist') || error.code === '42P01') {
          console.warn('admin_login_history table not set up yet')
          setAttempts([])
          return
        }
        throw error
      }
      setAttempts(data || [])
    } catch (err) {
      reportError(err, 'LoginHistory.fetchAttempts')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-white">Login History</h1>
        <p className="text-text-secondary">Track admin login attempts</p>
      </div>

      <div className="bg-surface rounded-lg border border-gray-800 overflow-hidden">
        {loading ? (
          <div className="flex justify-center py-16">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
          </div>
        ) : attempts.length === 0 ? (
          <div className="px-4 py-8 text-center text-text-secondary">
            No login history found
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-background border-b border-gray-800">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Time</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Email</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Status</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">IP Address</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Reason</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-800">
                {attempts.map((attempt) => (
                  <tr key={attempt.id} className="hover:bg-background/50">
                    <td className="px-4 py-3 text-sm text-text-secondary">
                      {new Date(attempt.created_at).toLocaleString()}
                    </td>
                    <td className="px-4 py-3 text-sm text-white">{attempt.email}</td>
                    <td className="px-4 py-3 text-sm">
                      {attempt.success ? (
                        <span className="flex items-center text-green-400">
                          <CheckCircle className="w-4 h-4 mr-1" />
                          Success
                        </span>
                      ) : (
                        <span className="flex items-center text-red-400">
                          <XCircle className="w-4 h-4 mr-1" />
                          Failed
                        </span>
                      )}
                    </td>
                    <td className="px-4 py-3 text-sm text-text-secondary font-mono">
                      {attempt.ip_address || 'Unknown'}
                    </td>
                    <td className="px-4 py-3 text-sm text-text-secondary">
                      {attempt.failure_reason || '-'}
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
