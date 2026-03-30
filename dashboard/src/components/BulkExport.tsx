import { useState, useEffect, memo } from 'react'
import { supabase } from '../lib/supabase'
import { Shield, AlertTriangle, Download, CheckCircle } from 'lucide-react'
import { showSuccess, showError } from '../lib/toast'
import { useConfirmDialog } from './ConfirmDialog'

export const BulkExport = memo(function BulkExport() {
  const [isExporting, setIsExporting] = useState(false)
  const [progress, setProgress] = useState(0)
  const [totalUsers, setTotalUsers] = useState(0)
  const { confirm, dialog } = useConfirmDialog()

  useEffect(() => {
    fetchUserCount()
  }, [])

  const fetchUserCount = async () => {
    const { count } = await supabase.from('users').select('*', { count: 'exact', head: true })
    setTotalUsers(count || 0)
  }

  const handleBulkExport = async () => {
    const confirmed = await confirm({
      title: 'GDPR Bulk Export',
      message: `This will export data for ${totalUsers} users. This operation may take several minutes. Continue?`,
      variant: 'warning',
      confirmLabel: 'Start Export',
    })
    
    if (!confirmed) return

    setIsExporting(true)
    setProgress(0)

    try {
      const { data: users, error } = await supabase.from('users').select('id')
      if (error) throw error

      const batchSize = 10
      const total = users?.length || 0
      let completed = 0

      for (let i = 0; i < total; i += batchSize) {
        const batch = users!.slice(i, i + batchSize)
        await Promise.all(
          batch.map(async (user) => {
            await supabase.functions.invoke('export-data', {
              body: { userId: user.id, skipEmail: true },
            })
          })
        )
        completed += batch.length
        setProgress(Math.round((completed / total) * 100))
      }

      showSuccess(`Export completed for ${total} users`)
    } catch (err) {
      showError(err instanceof Error ? err.message : 'Export failed')
    } finally {
      setIsExporting(false)
    }
  }

  return (
    <div className="bg-surface rounded-lg p-6 border border-gray-800">
      {dialog}
      <div className="flex items-center mb-4">
        <Shield className="w-6 h-6 text-primary mr-3" />
        <h2 className="text-lg font-semibold text-white">GDPR Bulk Export</h2>
      </div>

      <div className="space-y-4">
        <div className="flex items-center justify-between p-4 bg-background rounded-lg">
          <div>
            <p className="text-white font-medium">Total Users</p>
            <p className="text-text-secondary text-sm">{totalUsers.toLocaleString()} users to export</p>
          </div>
          <Download className="w-6 h-6 text-text-secondary" />
        </div>

        {isExporting && (
          <div className="space-y-2">
            <div className="flex items-center text-text-secondary text-sm">
              <AlertTriangle className="w-4 h-4 mr-2" />
              <span>Export in progress... Do not close this page</span>
            </div>
            <div className="w-full bg-background rounded-full h-2">
              <div
                className="bg-primary h-2 rounded-full transition-all"
                style={{ width: `${progress}%` }}
              />
            </div>
            <p className="text-sm text-text-secondary text-center">{progress}%</p>
          </div>
        )}

        <button
          onClick={handleBulkExport}
          disabled={isExporting || totalUsers === 0}
          className="w-full flex items-center justify-center px-4 py-3 bg-primary text-white rounded-lg hover:bg-opacity-90 transition-colors disabled:opacity-50"
        >
          {isExporting ? (
            <>
              <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2" />
              Exporting...
            </>
          ) : (
            <>
              <CheckCircle className="w-4 h-4 mr-2" />
              Start Bulk Export
            </>
          )}
        </button>

        <p className="text-xs text-text-secondary">
          This will trigger GDPR data exports for all users. Exported data will be stored securely
          and can be downloaded from the individual user pages.
        </p>
      </div>
    </div>
  )
})
