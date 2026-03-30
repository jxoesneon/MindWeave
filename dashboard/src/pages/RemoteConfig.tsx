import { useState, useEffect } from 'react'
import { supabase, type RemoteConfig as RemoteConfigType, type AuditLog } from '../lib/supabase'
import { Save, RotateCcw, History, Undo2 } from 'lucide-react'
import { showError, showSuccess } from '../lib/toast'
import { DataRetention } from '../components/DataRetention'
import { MFASetup } from '../components/MFASetup'
import { BulkExport } from '../components/BulkExport'
import { useAuth } from '../hooks/useAuth'

type ConfigValue = string | number | boolean

const DEFAULT_CONFIGS: Record<string, { value: ConfigValue; description: string }> = {
  ads_enabled_globally: { value: false, description: 'Master toggle for all ads' },
  ads_user_percentage: { value: 0, description: 'Percentage of users to show ads to' },
  ads_banner_enabled: { value: false, description: 'Enable banner ads' },
  ads_interstitial_enabled: { value: false, description: 'Enable interstitial ads' },
  ads_interstitial_frequency: { value: 10, description: 'Sessions between interstitials' },
  ads_min_sessions_before_first: { value: 5, description: 'Minimum sessions before showing first ad' },
  donation_prompt_enabled: { value: true, description: 'Show donation prompts' },
  donation_prompt_frequency: { value: 10, description: 'Sessions between donation prompts' },
}

export function RemoteConfig() {
  const [configs, setConfigs] = useState<RemoteConfigType[]>([])
  const [history, setHistory] = useState<AuditLog[]>([])
  const [showHistory, setShowHistory] = useState(false)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [editedValues, setEditedValues] = useState<Record<string, ConfigValue>>({})
  const { user } = useAuth()

  useEffect(() => {
    fetchConfigs()
    if (showHistory) fetchHistory()
  }, [showHistory])

  const fetchHistory = async () => {
    const { data } = await supabase
      .from('audit_log')
      .select('*')
      .eq('entity_type', 'remote_config')
      .order('created_at', { ascending: false })
      .limit(20)
    setHistory(data || [])
  }

  const handleRollback = (log: AuditLog) => {
    if (log.old_value && typeof log.old_value === 'object' && 'value' in log.old_value) {
      const oldValue = (log.old_value as Record<string, unknown>).value
      const key = log.entity_id
      setEditedValues({ ...editedValues, [key]: oldValue as ConfigValue })
    }
  }

  const fetchConfigs = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('remote_config')
        .select('*')
        .order('key')

      if (error) throw error

      // Merge with defaults
      const existingKeys = new Set(data?.map((c) => c.key) || [])
      const merged = [
        ...(data || []),
        ...Object.entries(DEFAULT_CONFIGS)
          .filter(([key]) => !existingKeys.has(key))
          .map(([key, { value, description }]) => ({
            key,
            value,
            description,
            updated_at: new Date().toISOString(),
            updated_by: 'system',
          })),
      ]

      setConfigs(merged)
    } catch (err) {
      // Silently handle 400 errors (table doesn't exist or RLS blocked)
      // Just use default configs without spamming console
      const is400Error = err && typeof err === 'object' && 
        ('code' in err && (err as { code: string }).code === '400' || 
         'message' in err && typeof (err as { message: string }).message === 'string' && 
         (err as { message: string }).message.includes('400'))
      
      if (!is400Error) {
        reportError(err)
      }
      // Use defaults on error
      setConfigs(Object.entries(DEFAULT_CONFIGS).map(([key, { value, description }]) => ({
        key,
        value,
        description,
        updated_at: new Date().toISOString(),
        updated_by: 'system',
      })))
    } finally {
      setLoading(false)
    }
  }

  const handleSave = async (key: string) => {
    try {
      setSaving(true)
      const value = editedValues[key]

      const { error } = await supabase
        .from('remote_config')
        .upsert({
          key,
          value,
          updated_at: new Date().toISOString(),
          updated_by: user?.id,
        }, { onConflict: 'key' })

      if (error) throw error

      // Clear edited value
      setEditedValues((prev) => {
        const next = { ...prev }
        delete next[key]
        return next
      })

      showSuccess('Config saved successfully')
      fetchConfigs()
    } catch (err) {
      // Log full error for debugging
      console.error('Remote config save error:', err)
      
      // Extract error message from Supabase error or fallback
      let errorMessage = 'Unknown error'
      if (err instanceof Error) {
        errorMessage = err.message
      } else if (err && typeof err === 'object') {
        if ('message' in err) {
          errorMessage = String((err as { message: unknown }).message)
        } else if ('error' in err) {
          errorMessage = String((err as { error: unknown }).error)
        } else if ('details' in err) {
          errorMessage = String((err as { details: unknown }).details)
        } else if ('code' in err) {
          errorMessage = `Error code: ${(err as { code: string }).code}`
        } else {
          errorMessage = JSON.stringify(err)
        }
      }
      showError('Save failed: ' + errorMessage)
    } finally {
      setSaving(false)
    }
  }

  const handleReset = (key: string) => {
    setEditedValues((prev) => {
      const next = { ...prev }
      delete next[key]
      return next
    })
  }

  const getValue = (config: RemoteConfigType): ConfigValue => {
    if (editedValues[config.key] !== undefined) {
      return editedValues[config.key]
    }
    return config.value as ConfigValue
  }

  const renderInput = (config: RemoteConfigType) => {
    const value = getValue(config)
    const key = config.key

    if (typeof value === 'boolean') {
      return (
        <select
          value={value.toString()}
          onChange={(e) => setEditedValues({ ...editedValues, [key]: e.target.value === 'true' })}
          className="px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
        >
          <option value="true">True</option>
          <option value="false">False</option>
        </select>
      )
    }

    if (typeof value === 'number') {
      return (
        <input
          type="number"
          value={value}
          onChange={(e) => setEditedValues({ ...editedValues, [key]: parseFloat(e.target.value) || 0 })}
          className="px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
        />
      )
    }

    return (
      <input
        type="text"
        value={value}
        onChange={(e) => setEditedValues({ ...editedValues, [key]: e.target.value })}
        className="px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
      />
    )
  }

  const isEdited = (key: string) => editedValues[key] !== undefined

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-white">Remote Config</h1>
          <p className="text-text-secondary">Manage feature flags and app settings</p>
        </div>
        <button
          onClick={() => setShowHistory(!showHistory)}
          className="flex items-center px-4 py-2 bg-surface border border-gray-700 text-white rounded-lg hover:bg-gray-800 transition-colors"
        >
          <History className="w-4 h-4 mr-2" />
          {showHistory ? 'Hide History' : 'View History'}
        </button>
      </div>

      {loading ? (
        <div className="flex justify-center py-16">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        </div>
      ) : (
        <div className="bg-surface rounded-lg border border-gray-800 overflow-hidden">
          <table className="w-full">
            <thead className="bg-background border-b border-gray-800">
              <tr>
                <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Key</th>
                <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Description</th>
                <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Value</th>
                <th className="px-4 py-3 text-left text-sm font-medium text-text-secondary">Updated</th>
                <th className="px-4 py-3 text-right text-sm font-medium text-text-secondary">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-800">
              {configs.map((config) => (
                <tr key={config.key} className="hover:bg-background/50">
                  <td className="px-4 py-3 text-sm text-white font-mono">{config.key}</td>
                  <td className="px-4 py-3 text-sm text-text-secondary">
                    {config.description || DEFAULT_CONFIGS[config.key]?.description || '-'}
                  </td>
                  <td className="px-4 py-3">{renderInput(config)}</td>
                  <td className="px-4 py-3 text-sm text-text-secondary">
                    {new Date(config.updated_at).toLocaleString()}
                  </td>
                  <td className="px-4 py-3 text-right">
                    {isEdited(config.key) && (
                      <div className="flex justify-end space-x-1">
                        <button
                          onClick={() => handleReset(config.key)}
                          className="p-1 text-text-secondary hover:text-white transition-colors"
                          title="Reset"
                        >
                          <RotateCcw className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleSave(config.key)}
                          disabled={saving}
                          className="p-1 text-primary hover:text-opacity-80 transition-colors"
                          title="Save"
                        >
                          <Save className="w-4 h-4" />
                        </button>
                      </div>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Change History */}
      {showHistory && (
        <div className="bg-surface rounded-lg border border-gray-800 overflow-hidden">
          <div className="px-4 py-3 border-b border-gray-800">
            <h3 className="text-sm font-medium text-white">Recent Changes</h3>
          </div>
          <div className="max-h-64 overflow-y-auto">
            {history.length === 0 ? (
              <div className="px-4 py-8 text-center text-text-secondary">No recent changes</div>
            ) : (
              <table className="w-full">
                <thead className="bg-background">
                  <tr>
                    <th className="px-4 py-2 text-left text-xs font-medium text-text-secondary">Time</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-text-secondary">Action</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-text-secondary">Key</th>
                    <th className="px-4 py-2 text-right text-xs font-medium text-text-secondary">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-800">
                  {history.map((log) => (
                    <tr key={log.id} className="hover:bg-background/50">
                      <td className="px-4 py-2 text-sm text-text-secondary">
                        {new Date(log.performed_at).toLocaleString()}
                      </td>
                      <td className="px-4 py-2 text-sm">
                        <span className={`inline-flex px-2 py-1 rounded text-xs font-medium ${
                          log.action === 'INSERT' ? 'bg-green-500/20 text-green-400' :
                          log.action === 'UPDATE' ? 'bg-yellow-500/20 text-yellow-400' :
                          'bg-red-500/20 text-red-400'
                        }`}>
                          {log.action}
                        </span>
                      </td>
                      <td className="px-4 py-2 text-sm text-white font-mono">{log.entity_id}</td>
                      <td className="px-4 py-2 text-right">
                        {log.old_value && (
                          <button
                            onClick={() => handleRollback(log)}
                            className="p-1 text-text-secondary hover:text-primary transition-colors"
                            title="Rollback to this version"
                          >
                            <Undo2 className="w-4 h-4" />
                          </button>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <DataRetention />
        <MFASetup />
      </div>

      <BulkExport />

      <div className="bg-surface/50 rounded-lg p-4 border border-gray-800">
        <h3 className="text-sm font-medium text-white mb-2">About Remote Config</h3>
        <p className="text-sm text-text-secondary">
          Changes to these settings are applied to the app within 15 minutes. 
          Use these controls to manage ads, donation prompts, and feature flags without requiring an app update.
        </p>
      </div>
    </div>
  )
}
