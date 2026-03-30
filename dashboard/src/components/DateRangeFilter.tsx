import { useState } from 'react'
import { Calendar, Download } from 'lucide-react'
import { exportToCSV } from '../lib/export'
import { showSuccess, showError } from '../lib/toast'

interface DateRangeFilterProps {
  onFilterChange?: (startDate: string, endDate: string) => void
  data?: Record<string, unknown>[]
  filename?: string
}

export function DateRangeFilter({ onFilterChange, data, filename = 'export' }: DateRangeFilterProps) {
  const [startDate, setStartDate] = useState(() => {
    const d = new Date()
    d.setMonth(d.getMonth() - 1)
    return d.toISOString().split('T')[0]
  })
  const [endDate, setEndDate] = useState(() => new Date().toISOString().split('T')[0])

  const handleApply = () => {
    onFilterChange?.(startDate, endDate)
  }

  const handleExport = () => {
    if (!data || data.length === 0) {
      showError('No data to export')
      return
    }
    try {
      exportToCSV(data, filename)
      showSuccess('Data exported successfully')
    } catch (err) {
      showError('Export failed')
    }
  }

  return (
    <div className="bg-surface rounded-lg p-4 border border-gray-800">
      <div className="flex items-center mb-4">
        <Calendar className="w-5 h-5 text-primary mr-2" />
        <h3 className="text-sm font-medium text-white">Date Range Filter</h3>
      </div>

      <div className="grid grid-cols-2 gap-4 mb-4">
        <div>
          <label className="block text-xs text-text-secondary mb-1">Start Date</label>
          <input
            type="date"
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
            className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white text-sm focus:outline-none focus:border-primary"
          />
        </div>
        <div>
          <label className="block text-xs text-text-secondary mb-1">End Date</label>
          <input
            type="date"
            value={endDate}
            onChange={(e) => setEndDate(e.target.value)}
            className="w-full px-3 py-2 bg-background border border-gray-700 rounded-md text-white text-sm focus:outline-none focus:border-primary"
          />
        </div>
      </div>

      <div className="flex space-x-2">
        <button
          onClick={handleApply}
          className="flex-1 px-4 py-2 bg-primary text-white rounded-lg text-sm hover:bg-opacity-90 transition-colors"
        >
          Apply Filter
        </button>
        {data && (
          <button
            onClick={handleExport}
            className="flex items-center px-4 py-2 bg-background border border-gray-700 text-white rounded-lg text-sm hover:bg-gray-800 transition-colors"
          >
            <Download className="w-4 h-4 mr-2" />
            Export CSV
          </button>
        )}
      </div>
    </div>
  )
}
