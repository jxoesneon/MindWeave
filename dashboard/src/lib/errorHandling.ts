import { showError } from './toast'
import { reportError } from './errorReporter'

interface RetryConfig {
  maxRetries?: number
  retryDelay?: number
  timeout?: number
}

const DEFAULT_RETRY_CONFIG: RetryConfig = {
  maxRetries: 3,
  retryDelay: 1000,
  timeout: 10000,
}

/**
 * Execute a function with retry logic and timeout
 */
export async function withRetry<T>(
  fn: () => Promise<T>,
  config: RetryConfig = {}
): Promise<T> {
  const { maxRetries = 3, retryDelay = 1000, timeout = 10000 } = {
    ...DEFAULT_RETRY_CONFIG,
    ...config,
  }

  let lastError: Error | undefined

  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      // Create a timeout promise
      const timeoutPromise = new Promise<never>((_, reject) => {
        setTimeout(() => reject(new Error('Request timeout')), timeout)
      })

      // Race between the function and timeout
      const result = await Promise.race([fn(), timeoutPromise])
      return result
    } catch (error) {
      lastError = error instanceof Error ? error : new Error(String(error))
      
      // Don't retry on client errors (4xx)
      if (lastError.message.includes('400') || lastError.message.includes('401') || 
          lastError.message.includes('403') || lastError.message.includes('404')) {
        throw lastError
      }

      // Wait before retrying (exponential backoff)
      if (attempt < maxRetries - 1) {
        const delay = retryDelay * Math.pow(2, attempt)
        await new Promise(resolve => setTimeout(resolve, delay))
      }
    }
  }

  throw lastError || new Error('Max retries exceeded')
}

/**
 * Handle Supabase errors consistently
 */
export function handleSupabaseError(error: unknown, context: string): void {
  const message = error instanceof Error ? error.message : String(error)
  
  // Report error to centralized error tracking
  reportError(error)
  
  // Show user-friendly message
  showError(`${context}: ${message}`)
}

/**
 * Optimistic update helper
 */
export function createOptimisticUpdate<T>(
  currentData: T[],
  updateFn: (item: T) => T,
  predicate: (item: T) => boolean
): { optimisticData: T[]; rollback: () => T[] } {
  const originalData = [...currentData]
  
  const optimisticData = currentData.map(item => 
    predicate(item) ? updateFn(item) : item
  )
  
  const rollback = () => originalData
  
  return { optimisticData, rollback }
}

/**
 * API request wrapper with loading state
 */
export async function apiRequest<T>(
  requestFn: () => Promise<T>,
  setLoading: (loading: boolean) => void,
  context: string
): Promise<T | null> {
  setLoading(true)
  
  try {
    const result = await withRetry(requestFn)
    return result
  } catch (error) {
    handleSupabaseError(error, context)
    return null
  } finally {
    setLoading(false)
  }
}
