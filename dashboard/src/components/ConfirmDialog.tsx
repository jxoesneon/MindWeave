import { useState } from 'react'
import { AlertTriangle, X } from 'lucide-react'

interface ConfirmDialogProps {
  isOpen: boolean
  title: string
  message: string
  confirmLabel?: string
  cancelLabel?: string
  variant?: 'danger' | 'warning' | 'info'
  onConfirm: () => void
  onCancel: () => void
}

export function ConfirmDialog({
  isOpen,
  title,
  message,
  confirmLabel = 'Confirm',
  cancelLabel = 'Cancel',
  variant = 'warning',
  onConfirm,
  onCancel,
}: ConfirmDialogProps) {
  if (!isOpen) return null

  const variantStyles = {
    danger: 'bg-red-500 hover:bg-red-600',
    warning: 'bg-yellow-500 hover:bg-yellow-600',
    info: 'bg-primary hover:bg-primary/90',
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div className="bg-surface rounded-lg p-6 border border-gray-800 max-w-md w-full mx-4">
        <div className="flex items-start mb-4">
          <div className={`p-2 rounded-full mr-3 ${
            variant === 'danger' ? 'bg-red-500/20' : 
            variant === 'warning' ? 'bg-yellow-500/20' : 
            'bg-primary/20'
          }`}>
            <AlertTriangle className={`w-5 h-5 ${
              variant === 'danger' ? 'text-red-400' : 
              variant === 'warning' ? 'text-yellow-400' : 
              'text-primary'
            }`} />
          </div>
          <div className="flex-1">
            <h3 className="text-lg font-semibold text-white mb-2">{title}</h3>
            <p className="text-text-secondary">{message}</p>
          </div>
          <button
            onClick={onCancel}
            className="p-1 text-text-secondary hover:text-white transition-colors"
            aria-label="Close dialog"
          >
            <X className="w-5 h-5" />
          </button>
        </div>
        <div className="flex space-x-3">
          <button
            onClick={onCancel}
            className="flex-1 px-4 py-2 bg-background border border-gray-700 text-white rounded-lg hover:bg-gray-800 transition-colors"
          >
            {cancelLabel}
          </button>
          <button
            onClick={onConfirm}
            className={`flex-1 px-4 py-2 text-white rounded-lg transition-colors ${variantStyles[variant]}`}
          >
            {confirmLabel}
          </button>
        </div>
      </div>
    </div>
  )
}

export function useConfirmDialog() {
  const [isOpen, setIsOpen] = useState(false)
  const [config, setConfig] = useState<ConfirmDialogProps>({
    isOpen: false,
    title: '',
    message: '',
    onConfirm: () => {},
    onCancel: () => {},
  })

  const confirm = (options: Omit<ConfirmDialogProps, 'isOpen' | 'onConfirm' | 'onCancel'>) => {
    return new Promise<boolean>((resolve) => {
      setConfig({
        ...options,
        isOpen: true,
        onConfirm: () => {
          setIsOpen(false)
          resolve(true)
        },
        onCancel: () => {
          setIsOpen(false)
          resolve(false)
        },
      })
      setIsOpen(true)
    })
  }

  const dialog = (
    <ConfirmDialog
      {...config}
      isOpen={isOpen}
      onConfirm={() => {
        config.onConfirm()
        setIsOpen(false)
      }}
      onCancel={() => {
        config.onCancel()
        setIsOpen(false)
      }}
    />
  )

  return { confirm, dialog }
}
