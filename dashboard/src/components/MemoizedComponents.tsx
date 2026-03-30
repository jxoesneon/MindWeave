import { memo, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import { Download, Trash2, Eye } from 'lucide-react'
import type { User } from '../lib/supabase'

interface UserTableRowProps {
  user: User
  onExport: (userId: string) => void
  onDelete: (userId: string) => void
}

export const UserTableRow = memo(function UserTableRow({ user, onExport, onDelete }: UserTableRowProps) {
  const navigate = useNavigate()

  const handleView = useCallback(() => {
    navigate(`/users/${user.id}`)
  }, [navigate, user.id])

  const handleExport = useCallback(() => {
    onExport(user.id)
  }, [onExport, user.id])

  const handleDelete = useCallback(() => {
    onDelete(user.id)
  }, [onDelete, user.id])

  return (
    <tr className="hover:bg-background/50">
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
          onClick={handleView}
          className="p-1 text-text-secondary hover:text-primary transition-colors"
          title="View user details"
          aria-label="View user details"
        >
          <Eye className="w-4 h-4" aria-hidden="true" />
        </button>
        <button
          onClick={handleExport}
          className="p-1 text-text-secondary hover:text-primary transition-colors"
          title="Export user data (GDPR)"
          aria-label="Export user data"
        >
          <Download className="w-4 h-4" aria-hidden="true" />
        </button>
        <button
          onClick={handleDelete}
          className="p-1 text-text-secondary hover:text-red-400 transition-colors"
          title="Delete user"
          aria-label="Delete user"
        >
          <Trash2 className="w-4 h-4" aria-hidden="true" />
        </button>
      </td>
    </tr>
  )
})

interface StatCardProps {
  title: string
  value: string | number
  subtitle?: string
  icon: React.ElementType
  trend?: 'up' | 'down' | 'neutral'
}

export const StatCard = memo(function StatCard({ title, value, subtitle, icon: Icon, trend }: StatCardProps) {
  const trendColors = {
    up: 'text-green-400',
    down: 'text-red-400',
    neutral: 'text-text-secondary',
  }

  return (
    <div className="bg-surface rounded-lg p-6 border border-gray-800">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-sm text-text-secondary">{title}</p>
          <p className="text-2xl font-bold text-white mt-1">{value}</p>
          {subtitle && (
            <p className={`text-sm mt-1 ${trend ? trendColors[trend] : 'text-text-secondary'}`}>
              {subtitle}
            </p>
          )}
        </div>
        <div className="p-3 bg-primary/10 rounded-lg">
          <Icon className="w-6 h-6 text-primary" aria-hidden="true" />
        </div>
      </div>
    </div>
  )
})

interface PresetCardProps {
  name: string
  description: string
  band: string
  beatFrequency: number
  usageCount: number
  isOfficial: boolean
  isFeatured: boolean
  onEdit: () => void
  onDelete: () => void
}

export const PresetCard = memo(function PresetCard({
  name,
  description,
  band,
  beatFrequency,
  usageCount,
  isOfficial,
  isFeatured,
  onEdit,
  onDelete,
}: PresetCardProps) {
  return (
    <div className="bg-surface rounded-lg p-6 border border-gray-800 hover:border-gray-700 transition-colors">
      <div className="flex items-start justify-between mb-4">
        <div>
          <h3 className="text-lg font-semibold text-white">{name}</h3>
          <p className="text-sm text-text-secondary">{description}</p>
        </div>
        <div className="flex space-x-1">
          {isOfficial && (
            <span className="px-2 py-1 bg-primary/20 text-primary text-xs rounded">Official</span>
          )}
          {isFeatured && (
            <span className="px-2 py-1 bg-yellow-500/20 text-yellow-400 text-xs rounded">Featured</span>
          )}
        </div>
      </div>
      <div className="flex items-center justify-between text-sm text-text-secondary mb-4">
        <span>{band} • {beatFrequency}Hz</span>
        <span>{usageCount.toLocaleString()} uses</span>
      </div>
      <div className="flex space-x-2">
        <button
          onClick={onEdit}
          className="flex-1 px-3 py-2 bg-background border border-gray-700 text-white rounded-lg hover:bg-gray-800 transition-colors text-sm"
        >
          Edit
        </button>
        <button
          onClick={onDelete}
          className="flex-1 px-3 py-2 bg-red-500/20 text-red-400 rounded-lg hover:bg-red-500/30 transition-colors text-sm"
        >
          Delete
        </button>
      </div>
    </div>
  )
})
