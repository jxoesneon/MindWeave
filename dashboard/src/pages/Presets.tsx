import { useState, useEffect, useCallback } from 'react'
import { supabase, type Preset } from '../lib/supabase'
import { Plus, Edit2, Trash2, Star } from 'lucide-react'
import { showError, showSuccess } from '../lib/toast'
import { reportError } from '../lib/errorReporter'
import { useConfirmDialog } from '../components/ConfirmDialog'

export function Presets() {
  const [presets, setPresets] = useState<Preset[]>([])
  const [loading, setLoading] = useState(true)
  const [isEditing, setIsEditing] = useState<string | null>(null)
  const [formData, setFormData] = useState<Partial<Preset>>({})
  const { confirm, dialog } = useConfirmDialog()

  useEffect(() => {
    fetchPresets()
  }, [])

  const fetchPresets = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('presets')
        .select('*')
        .order('is_official', { ascending: false })
        .order('usage_count', { ascending: false })

      if (error) {
        // Check if table doesn't exist
        if (error.message?.includes('does not exist') || error.code === '42P01') {
          console.warn('presets table not set up yet')
          setPresets([])
          return
        }
        throw error
      }
      setPresets(data || [])
    } catch (err) {
      reportError(err, 'Presets.fetchPresets')
    } finally {
      setLoading(false)
    }
  }

  const handleSave = async () => {
    if (!formData.name || !formData.beat_frequency) return

    try {
      if (isEditing === 'new') {
        const { error } = await supabase
          .from('presets')
          .insert([{ ...formData, is_official: true, usage_count: 0 }])
        if (error) throw error
      } else if (isEditing) {
        const { error } = await supabase
          .from('presets')
          .update(formData)
          .eq('id', isEditing)
        if (error) throw error
      }

      setIsEditing(null)
      setFormData({})
      fetchPresets()
    } catch (err) {
      reportError(err, 'Presets.handleSave')
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
        } else {
          errorMessage = JSON.stringify(err)
        }
      }
      showError('Save failed: ' + errorMessage)
    }
  }

  const handleDelete = useCallback(async (id: string) => {
    const confirmed = await confirm({
      title: 'Delete Preset',
      message: 'Are you sure you want to delete this preset? This action cannot be undone.',
      variant: 'danger',
      confirmLabel: 'Delete',
    })
    
    if (!confirmed) return

    try {
      const { error } = await supabase
        .from('presets')
        .delete()
        .eq('id', id)

      if (error) throw error
      setPresets(presets.filter(p => p.id !== id))
      showSuccess('Preset deleted successfully')
    } catch (err) {
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
        } else {
          errorMessage = JSON.stringify(err)
        }
      }
      showError('Delete failed: ' + errorMessage)
    }
  }, [confirm, presets])

  const startEdit = (preset?: Preset) => {
    if (preset) {
      setIsEditing(preset.id)
      setFormData(preset)
    } else {
      setIsEditing('new')
      setFormData({
        name: '',
        description: '',
        band: 'Alpha',
        beat_frequency: 10,
        default_carrier: 250,
        is_official: true,
      })
    }
  }

  const toggleFeature = async (preset: Preset) => {
    try {
      const { error } = await supabase
        .from('presets')
        .update({ is_featured: !preset.is_featured })
        .eq('id', preset.id)

      if (error) throw error
      fetchPresets()
    } catch (err) {
      showError('Toggle failed: ' + (err instanceof Error ? err.message : 'Unknown error'))
    }
  }

  const getBandColor = (band: string) => {
    switch (band) {
      case 'Delta': return 'text-accent-delta'
      case 'Theta': return 'text-accent-theta'
      case 'Alpha': return 'text-accent-alpha'
      case 'Beta': return 'text-accent-beta'
      case 'Gamma': return 'text-accent-gamma'
      default: return 'text-primary'
    }
  }

  return (
    <div className="space-y-6">
      {dialog}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-white">Presets</h1>
          <p className="text-text-secondary">Manage brainwave presets</p>
        </div>
        <button
          onClick={() => startEdit()}
          className="flex items-center px-4 py-2 bg-primary hover:bg-opacity-90 text-white rounded-lg font-medium transition-colors"
        >
          <Plus className="w-4 h-4 mr-2" />
          Add Preset
        </button>
      </div>

      {/* Edit Form */}
      {isEditing && (
        <div className="bg-surface rounded-lg p-6 border border-gray-800">
          <h3 className="text-lg font-semibold text-white mb-4">
            {isEditing === 'new' ? 'Add New Preset' : 'Edit Preset'}
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-text-secondary mb-1">Name</label>
              <input
                type="text"
                value={formData.name || ''}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-text-secondary mb-1">Band</label>
              <select
                value={formData.band || 'Alpha'}
                onChange={(e) => setFormData({ ...formData, band: e.target.value })}
                className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
              >
                <option value="Delta">Delta (0.5-4 Hz)</option>
                <option value="Theta">Theta (4-8 Hz)</option>
                <option value="Alpha">Alpha (8-12 Hz)</option>
                <option value="Beta">Beta (12-30 Hz)</option>
                <option value="Gamma">Gamma (30-100 Hz)</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-text-secondary mb-1">Beat Frequency (Hz)</label>
              <input
                type="number"
                step="0.1"
                value={formData.beat_frequency || ''}
                onChange={(e) => setFormData({ ...formData, beat_frequency: parseFloat(e.target.value) })}
                className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-text-secondary mb-1">Default Carrier (Hz)</label>
              <input
                type="number"
                value={formData.default_carrier || ''}
                onChange={(e) => setFormData({ ...formData, default_carrier: parseFloat(e.target.value) })}
                className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
              />
            </div>
            <div className="md:col-span-2">
              <label className="block text-sm font-medium text-text-secondary mb-1">Description</label>
              <input
                type="text"
                value={formData.description || ''}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white focus:outline-none focus:border-primary"
              />
            </div>
          </div>
          <div className="mt-4 flex justify-end space-x-2">
            <button
              onClick={() => { setIsEditing(null); setFormData({}) }}
              className="px-4 py-2 bg-background border border-gray-700 text-white rounded-lg hover:bg-gray-800 transition-colors"
            >
              Cancel
            </button>
            <button
              onClick={handleSave}
              className="px-4 py-2 bg-primary hover:bg-opacity-90 text-white rounded-lg font-medium transition-colors"
            >
              Save
            </button>
          </div>
        </div>
      )}

      {/* Presets Grid */}
      {loading ? (
        <div className="flex justify-center py-16">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {presets.map((preset) => (
            <div
              key={preset.id}
              className="bg-surface rounded-lg p-6 border border-gray-800 hover:border-gray-700 transition-colors"
            >
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center">
                  {preset.is_official && (
                    <Star className="w-4 h-4 text-primary mr-2" />
                  )}
                  <h3 className="font-semibold text-white">{preset.name}</h3>
                </div>
                <div className="flex space-x-1">
                  <button
                    onClick={() => toggleFeature(preset)}
                    className={`p-1 transition-colors ${preset.is_featured ? 'text-primary hover:text-primary/80' : 'text-text-secondary hover:text-primary'}`}
                    title={preset.is_featured ? 'Unfeature preset' : 'Feature preset'}
                  >
                    {preset.is_featured ? <Star className="w-4 h-4 fill-current" /> : <Star className="w-4 h-4" />}
                  </button>
                  <button
                    onClick={() => startEdit(preset)}
                    className="p-1 text-text-secondary hover:text-white transition-colors"
                    title="Edit preset"
                  >
                    <Edit2 className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => handleDelete(preset.id)}
                    className="p-1 text-text-secondary hover:text-red-400 transition-colors"
                    title="Delete preset"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
              <p className="text-sm text-text-secondary mb-4">{preset.description}</p>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-text-secondary">Band:</span>
                  <span className={getBandColor(preset.band)}>{preset.band}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-text-secondary">Beat:</span>
                  <span className="text-white">{preset.beat_frequency} Hz</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-text-secondary">Carrier:</span>
                  <span className="text-white">{preset.default_carrier} Hz</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-text-secondary">Usage:</span>
                  <span className="text-white">{preset.usage_count.toLocaleString()}</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
