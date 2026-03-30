/**
 * Production error logging
 * Replaces console.error with structured error reporting
 */

import { showError } from './toast'

interface ErrorReport {
  message: string
  stack?: string
  context: string
  timestamp: string
  userAgent: string
  url: string
}

const errorQueue: ErrorReport[] = []
let flushTimeout: ReturnType<typeof setTimeout> | null = null

// Known expected errors that shouldn't alert the user
const EXPECTED_ERROR_PATTERNS = [
  'remote_config', // Table may not exist or RLS blocked
  '400 (Bad Request)', // Expected Supabase errors
]

function isExpectedError(message: string): boolean {
  return EXPECTED_ERROR_PATTERNS.some(pattern => message.includes(pattern))
}

/**
 * Report error to queue (replaces console.error)
 */
export function reportError(error: unknown, context = 'Application'): void {
  // Handle Supabase error objects and other error types
  let message: string
  let stack: string | undefined
  
  if (error instanceof Error) {
    message = error.message
    if (isExpectedError(message)) return // Filter out expected errors
    if ('stack' in error) {
      stack = String((error as { stack: unknown }).stack)
    }
  } else if (error && typeof error === 'object' && 'message' in error) {
    // Handle Supabase error objects
    message = String((error as { message: unknown }).message)
    if (isExpectedError(message)) return // Filter out expected errors
    if ('stack' in error) {
      stack = String((error as { stack: unknown }).stack)
    }
  } else {
    message = String(error)
  }
  
  const report: ErrorReport = {
    message,
    stack,
    context,
    timestamp: new Date().toISOString(),
    userAgent: navigator.userAgent,
    url: window.location.href,
  }
  
  // Add to queue
  errorQueue.push(report)
  
  // Show user-friendly error
  showError(`${context}: ${report.message}`)
  
  // Schedule flush
  scheduleFlush()
}

/**
 * Flush errors to server or storage
 */
function scheduleFlush(): void {
  if (flushTimeout) return
  
  flushTimeout = setTimeout(() => {
    flushErrors()
  }, 5000) // Batch errors every 5 seconds
}

async function flushErrors(): Promise<void> {
  if (errorQueue.length === 0) {
    flushTimeout = null
    return
  }
  
  const errorsToFlush = [...errorQueue]
  errorQueue.length = 0
  
  // In production, send to error tracking service
  // For now, log to console in development only
  if (import.meta.env.DEV) {
    // eslint-disable-next-line no-console
    console.error('[Error Reporter]', errorsToFlush)
  }
  
  // TODO: Send to Supabase edge function or Sentry
  // await supabase.functions.invoke('log-errors', { body: { errors: errorsToFlush } })
  
  flushTimeout = null
}

/**
 * Global error handler
 */
export function setupGlobalErrorHandlers(): void {
  // Unhandled promise rejections
  window.addEventListener('unhandledrejection', (event) => {
    reportError(event.reason, 'Unhandled Promise Rejection')
  })
  
  // Global errors
  window.addEventListener('error', (event) => {
    reportError(event.error, 'Global Error')
  })
}

/**
 * Wrap function with error reporting
 */
export function withErrorReporting<T extends (...args: unknown[]) => unknown>(
  fn: T,
  context: string
): (...args: Parameters<T>) => ReturnType<T> | undefined {
  return (...args: Parameters<T>): ReturnType<T> | undefined => {
    try {
      return fn(...args) as ReturnType<T>
    } catch (error) {
      reportError(error, context)
      return undefined
    }
  }
}

/**
 * Async version with error reporting
 */
export async function withAsyncErrorReporting<T>(
  fn: () => Promise<T>,
  context: string
): Promise<T | undefined> {
  try {
    return await fn()
  } catch (error) {
    reportError(error, context)
    return undefined
  }
}
