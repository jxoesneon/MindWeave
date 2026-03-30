import { Link } from 'react-router-dom'
import { Home, AlertTriangle } from 'lucide-react'
import { memo } from 'react'

export const NotFound = memo(function NotFound() {
  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div className="bg-surface rounded-lg p-8 border border-gray-800 max-w-md w-full text-center">
        <div className="w-20 h-20 bg-yellow-500/20 rounded-full flex items-center justify-center mx-auto mb-6">
          <AlertTriangle className="w-10 h-10 text-yellow-400" />
        </div>
        <h1 className="text-4xl font-bold text-white mb-2">404</h1>
        <h2 className="text-xl font-semibold text-white mb-4">Page Not Found</h2>
        <p className="text-text-secondary mb-6">
          The page you're looking for doesn't exist or has been moved.
        </p>
        <Link
          to="/"
          className="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-opacity-90 transition-colors"
        >
          <Home className="w-4 h-4 mr-2" />
          Go Home
        </Link>
      </div>
    </div>
  )
})
