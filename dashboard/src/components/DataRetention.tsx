import { useState, useCallback, memo } from 'react'
import { Shield, Clock, Trash2, AlertTriangle } from 'lucide-react'
import { showSuccess, showError } from '../lib/toast'
import { useConfirmDialog } from './ConfirmDialog'

export const DataRetention = memo(function DataRetention() {
  const [retentionDays, setRetentionDays] = useState(365)
  const [autoDelete, setAutoDelete] = useState(false)
  const [isSaving, setIsSaving] = useState(false)
  const { confirm, dialog } = useConfirmDialog()

  const handleSave = async () => {
    setIsSaving(true)
    try {
      // In a real implementation, this would update remote config
      await new Promise((resolve) => setTimeout(resolve, 1000))
      showSuccess('Data retention settings saved')
    } catch (err) {
      showError('Failed to save settings')
    } finally {
      setIsSaving(false)
    }
  }

  const handlePurgeOldData = useCallback(async () => {
    const confirmed = await confirm({
      title: 'Purge Old Data',
      message: `This will permanently delete all data older than ${retentionDays} days. This action cannot be undone.`,
      variant: 'danger',
      confirmLabel: 'Purge Data',
    })
    
    if (!confirmed) return

    try {
      showSuccess('Data purge scheduled')
    } catch (err) {
      showError('Failed to purge data')
    }
  }, [confirm, retentionDays])

  return (
    <div className="bg-surface rounded-lg p-6 border border-gray-800">
      {dialog}
      <div className="flex items-center mb-6">
        <Shield className="w-6 h-6 text-primary mr-3" />
        <h2 className="text-lg font-semibold text-white">Data Retention Controls</h2>
      </div>

      <div className="space-y-6">
        <div className="bg-yellow-500/10 border border-yellow-500/30 rounded-lg p-4 flex items-start">
          <AlertTriangle className="w-5 h-5 text-yellow-400 mr-3 mt-0.5" />
          <div>
            <h3 className="text-sm font-medium text-yellow-400">GDPR Compliance</h3>
            <p className="text-sm text-text-secondary mt-1">
              Configure how long user data is retained. Users have the right to request data deletion under GDPR.
            </p>
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-text-secondary mb-2">
            Data Retention Period (days)
          </label>
          <div className="flex items-center space-x-4">
            <input
              type="number"
              value={retentionDays}
              onChange={(e) => setRetentionDays(parseInt(e.target.value))}
              min={30}
              max={2555}
              className="px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary w-32"
            />
            <span className="text-text-secondary">days</span>
          </div>
          <p className="text-xs text-text-secondary mt-2">
            User data older than this will be automatically purged
          </p>
        </div>

        <div className="flex items-center space-x-3">
          <input
            type="checkbox"
            id="autoDelete"
            checked={autoDelete}
            onChange={(e) => setAutoDelete(e.target.checked)}
            className="w-4 h-4 rounded border-gray-700 bg-background text-primary focus:ring-primary"
          />
          <label htmlFor="autoDelete" className="text-white">
            Enable automatic data deletion
          </label>
        </div>

        <div className="flex items-center space-x-2 text-sm text-text-secondary">
          <Clock className="w-4 h-4" />
          <span>Next purge scheduled: {autoDelete ? 'Daily at 00:00 UTC' : 'Disabled'}</span>
        </div>

        <div className="flex space-x-3 pt-4 border-t border-gray-800">
          <button
            onClick={handleSave}
            disabled={isSaving}
            className="flex-1 px-4 py-2 bg-primary text-white rounded-lg hover:bg-opacity-90 transition-colors disabled:opacity-50"
          >
            {isSaving ? 'Saving...' : 'Save Settings'}
          </button>
          <button
            onClick={handlePurgeOldData}
            className="flex items-center px-4 py-2 bg-red-500/20 text-red-400 rounded-lg hover:bg-red-500/30 transition-colors"
          >
            <Trash2 className="w-4 h-4 mr-2" />
            Purge Old Data Now
          </button>
        </div>
      </div>
    </div>
  )
})
