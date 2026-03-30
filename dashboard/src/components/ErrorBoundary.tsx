import { Component, type ReactNode } from 'react'
import { AlertTriangle, RefreshCw } from 'lucide-react'
import { reportError } from '../lib/errorReporter'

interface Props {
  children: ReactNode
}

interface State {
  hasError: boolean
  error: Error | null
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { hasError: false, error: null }
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error, _errorInfo: React.ErrorInfo) {
    reportError(error)
  }

  handleRetry = () => {
    this.setState({ hasError: false, error: null })
    window.location.reload()
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen bg-background flex items-center justify-center p-4">
          <div className="bg-surface rounded-lg p-8 border border-gray-800 max-w-md w-full text-center">
            <div className="w-16 h-16 bg-red-500/20 rounded-full flex items-center justify-center mx-auto mb-4">
              <AlertTriangle className="w-8 h-8 text-red-400" />
            </div>
            <h2 className="text-xl font-bold text-white mb-2">Something went wrong</h2>
            <p className="text-text-secondary mb-6">
              An error occurred while rendering this page. Please try again.
            </p>
            {this.state.error && (
              <div className="bg-background rounded p-3 mb-6 text-left overflow-auto">
                <code className="text-xs text-red-400 font-mono">
                  {this.state.error.message}
                </code>
              </div>
            )}
            <button
              onClick={this.handleRetry}
              className="flex items-center justify-center w-full px-4 py-2 bg-primary text-white rounded-lg hover:bg-opacity-90 transition-colors"
            >
              <RefreshCw className="w-4 h-4 mr-2" />
              Retry
            </button>
          </div>
        </div>
      )
    }

    return this.props.children
  }
}
