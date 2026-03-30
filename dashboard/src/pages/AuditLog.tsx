import { useState, useEffect } from 'react'
import { supabase, type AuditLog as AuditLogType } from '../lib/supabase'
import { FileText, ChevronLeft, ChevronRight } from 'lucide-react'
import { reportError } from '../lib/errorReporter'

export function AuditLog() {
  const [logs, setLogs] = useState<AuditLogType[]>([])
  const [loading, setLoading] = useState(true)
  const [page, setPage] = useState(0)
  const pageSize = 25

  useEffect(() => {
    fetchLogs()
  }, [page])

  const fetchLogs = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('audit_log')
        .select('*')
        .order('performed_at', { ascending: false })
        .range(page * pageSize, (page + 1) * pageSize - 1)

      if (error) {
        // Check if column doesn't exist
        if (error.message?.includes('performed_at') || error.code === '42703') {
          console.warn('audit_log.performed_at column not set up yet')
          // Fetch without ordering
          const { data: unsortedData, error: unsortedError } = await supabase
            .from('audit_log')
            .select('*')
            .range(page * pageSize, (page + 1) * pageSize - 1)
          
          if (!unsortedError) {
            setLogs(unsortedData || [])
            return
          }
        }
        throw error
      }
      setLogs(data || [])
    } catch (err) {
      reportError(err)
    } finally {
      setLoading(false)
    }
  }

  const getActionColor = (action: string) => {
    switch (action) {
      case 'CREATE':
      case 'INSERT':
        return 'text-green-400'
      case 'UPDATE':
        return 'text-yellow-400'
      case 'DELETE':
        return 'text-red-400'
      default:
        return 'text-text-secondary'
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-white">Audit Log</h1>
        <p className="text-text-secondary">Track all administrative changes</p>
      </div>

      {loading ? (
        <div className="flex justify-center py-16">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        </div>
      ) : (
        <div className="bg-surface rounded-lg border border-gray-800 overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-background border-b border-gray-800">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Time</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Action</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Entity</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">ID</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Performed By</th>
                  <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Changes</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-800">
                {logs.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="px-4 py-8 text-center text-text-secondary">
                      No audit logs found
                    </td>
                  </tr>
                ) : (
                  logs.map((log) => (
                    <tr key={log.id} className="hover:bg-background/50">
                      <td className="px-4 py-3 text-sm text-text-secondary whitespace-nowrap">
                        {new Date(log.performed_at).toLocaleString()}
                      </td>
                      <td className="px-4 py-3 text-sm">
                        <span className={`font-medium ${getActionColor(log.action)}`}>
                          {log.action}
                        </span>
                      </td>
                      <td className="px-4 py-3 text-sm text-white">{log.entity_type}</td>
                      <td className="px-4 py-3 text-sm text-white font-mono">
                        {log.entity_id.slice(0, 8)}...
                      </td>
                      <td className="px-4 py-3 text-sm text-text-secondary font-mono">
                        {log.performed_by?.slice(0, 8)}...
                      </td>
                      <td className="px-4 py-3 text-sm">
                        {log.old_value && (
                          <div className="text-red-400 text-xs mb-1">
                            - {JSON.stringify(log.old_value).slice(0, 50)}
                          </div>
                        )}
                        {log.new_value && (
                          <div className="text-green-400 text-xs">
                            + {JSON.stringify(log.new_value).slice(0, 50)}
                          </div>
                        )}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>

          {/* Pagination */}
          <div className="px-4 py-3 border-t border-gray-800 flex items-center justify-between">
            <button
              onClick={() => setPage(Math.max(0, page - 1))}
              disabled={page === 0}
              className="flex items-center px-3 py-1 bg-background border border-gray-700 rounded text-sm text-white disabled:opacity-50"
            >
              <ChevronLeft className="w-4 h-4 mr-1" />
              Previous
            </button>
            <span className="text-sm text-text-secondary">Page {page + 1}</span>
            <button
              onClick={() => setPage(page + 1)}
              disabled={logs.length < pageSize}
              className="flex items-center px-3 py-1 bg-background border border-gray-700 rounded text-sm text-white disabled:opacity-50"
            >
              Next
              <ChevronRight className="w-4 h-4 ml-1" />
            </button>
          </div>
        </div>
      )}

      <div className="bg-surface/50 rounded-lg p-4 border border-gray-800">
        <div className="flex items-start">
          <FileText className="w-5 h-5 text-primary mr-3 mt-0.5" />
          <div>
            <h3 className="text-sm font-medium text-white mb-1">Audit Trail</h3>
            <p className="text-sm text-text-secondary">
              All changes made through this dashboard are logged for security and compliance purposes. 
              Logs are retained for 90 days.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
