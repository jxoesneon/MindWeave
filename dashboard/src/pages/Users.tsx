import { useState, useEffect, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase, type User } from '../lib/supabase'
import { Search, Download, Trash2, Eye, RefreshCw } from 'lucide-react'
import { reportError } from '../lib/errorReporter'
import { showSuccess, showError } from '../lib/toast'
import { useDebounce } from '../hooks/useDebounce'
import { useConfirmDialog } from '../components/ConfirmDialog'

export function Users() {
  const navigate = useNavigate()
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)
  const [searchQuery, setSearchQuery] = useState('')
  const debouncedSearch = useDebounce(searchQuery, 300)
  const [page, setPage] = useState(0)
  const [pageSize, setPageSize] = useState(20)
  const { confirm, dialog } = useConfirmDialog()

  useEffect(() => {
    fetchUsers()
  }, [page, pageSize])

  useEffect(() => {
    // Reset to first page when search changes
    setPage(0)
  }, [debouncedSearch])

  const fetchUsers = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('users')
        .select('*')
        .order('created_at', { ascending: false })
        .range(page * pageSize, (page + 1) * pageSize - 1)

      if (error) {
        // Check if table doesn't exist
        if (error.message?.includes('does not exist') || error.code === '42P01') {
          console.warn('users table not set up yet')
          setUsers([])
          return
        }
        throw error
      }
      setUsers(data || [])
    } catch (err) {
      reportError(err, 'Users.fetchUsers')
    } finally {
      setLoading(false)
    }
  }

  const filteredUsers = users.filter((user) =>
    user.id.toLowerCase().includes(debouncedSearch.toLowerCase()) ||
    user.device_type?.toLowerCase().includes(debouncedSearch.toLowerCase())
  )

  const exportUserData = async (userId: string) => {
    // Trigger GDPR data export
    const { error } = await supabase.functions.invoke('export-data', {
      body: { userId },
    })
    
    if (error) {
      showError('Export failed: ' + error.message)
    } else {
      showSuccess('Data export initiated. Check your email.')
    }
  }

  const deleteUser = useCallback(async (userId: string) => {
    const confirmed = await confirm({
      title: 'Delete User',
      message: 'Are you sure? This will permanently delete the user and all their data.',
      variant: 'danger',
      confirmLabel: 'Delete',
    })
    
    if (!confirmed) return

    try {
      const { error } = await supabase
        .from('users')
        .delete()
        .eq('id', userId)

      if (error) throw error
      showSuccess('User deleted successfully')
      setUsers(users.filter((u) => u.id !== userId))
    } catch (err) {
      reportError(err, 'Users.deleteUser')
      showError('Delete failed: ' + (err instanceof Error ? err.message : 'Unknown error'))
    }
  }, [confirm, users])

  return (
    <div className="space-y-6">
      {dialog}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-white">Users</h1>
          <p className="text-text-secondary">Manage user accounts and data</p>
        </div>
        <button
          onClick={fetchUsers}
          disabled={loading}
          className="flex items-center px-3 py-2 bg-surface border border-gray-700 rounded-lg text-white hover:bg-gray-800 transition-colors disabled:opacity-50"
        >
          <RefreshCw className={`w-4 h-4 mr-2 ${loading ? 'animate-spin' : ''}`} />
          Refresh
        </button>
      </div>

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-text-secondary" />
        <input
          type="text"
          placeholder="Search users by ID or device..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full pl-10 pr-4 py-2 bg-surface border border-gray-700 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-primary"
        />
      </div>

      {/* Users Table */}
      <div className="bg-surface rounded-lg border border-gray-800 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-background border-b border-gray-800">
              <tr>
                <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">User ID</th>
                <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Anonymous</th>
                <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Device</th>
                <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">App Version</th>
                <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Created</th>
                <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Last Active</th>
                <th className="px-4 py-3 text-right text-sm font-medium text-text-secondary">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-800">
              {loading ? (
                <tr>
                  <td colSpan={7} className="px-4 py-8 text-center">
                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto"></div>
                  </td>
                </tr>
              ) : filteredUsers.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-4 py-8 text-center text-text-secondary">
                    No users found
                  </td>
                </tr>
              ) : (
                filteredUsers.map((user) => (
                  <tr key={user.id} className="hover:bg-background/50">
                    <td className="px-4 py-3 text-sm text-white font-mono">
                      {user.id.slice(0, 8)}...
                    </td>
                    <td className="px-4 py-3 text-sm text-white">
                      {user.is_anonymous ? 'Yes' : 'No'}
                    </td>
                    <td className="px-4 py-3 text-sm text-white">
                      {user.device_type || 'Unknown'}
                    </td>
                    <td className="px-4 py-3 text-sm text-white">
                      {user.app_version || 'Unknown'}
                    </td>
                    <td className="px-4 py-3 text-sm text-text-secondary">
                      {new Date(user.created_at).toLocaleDateString()}
                    </td>
                    <td className="px-4 py-3 text-sm text-text-secondary">
                      {new Date(user.last_active).toLocaleDateString()}
                    </td>
                    <td className="px-4 py-3 text-right space-x-2">
                      <button
                        onClick={() => navigate(`/users/${user.id}`)}
                        className="p-1 text-text-secondary hover:text-primary transition-colors"
                        title="View user details"
                      >
                        <Eye className="w-4 h-4" />
                      </button>
                      <button
                        onClick={() => exportUserData(user.id)}
                        className="p-1 text-text-secondary hover:text-primary transition-colors"
                        title="Export user data (GDPR)"
                      >
                        <Download className="w-4 h-4" />
                      </button>
                      <button
                        onClick={() => deleteUser(user.id)}
                        className="p-1 text-text-secondary hover:text-red-400 transition-colors"
                        title="Delete user"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="px-4 py-3 border-t border-gray-800 flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <button
              onClick={() => setPage(Math.max(0, page - 1))}
              disabled={page === 0}
              className="px-3 py-1 bg-background border border-gray-700 rounded text-sm text-white disabled:opacity-50"
            >
              Previous
            </button>
            <span className="text-sm text-text-secondary">Page {page + 1}</span>
            <button
              onClick={() => setPage(page + 1)}
              disabled={users.length < pageSize}
              className="px-3 py-1 bg-background border border-gray-700 rounded text-sm text-white disabled:opacity-50"
            >
              Next
            </button>
          </div>
          <div className="flex items-center space-x-2">
            <span className="text-sm text-text-secondary">Show:</span>
            <select
              value={pageSize}
              onChange={(e) => {
                setPageSize(Number(e.target.value))
                setPage(0)
              }}
              className="px-2 py-1 bg-background border border-gray-700 rounded text-sm text-white"
            >
              <option value={10}>10</option>
              <option value={20}>20</option>
              <option value={50}>50</option>
            </select>
          </div>
        </div>
      </div>
    </div>
  )
}
