/**
 * Rate Limiting Hook
 * Prevents excessive API calls and UI interactions
 */

import { useState, useCallback, useRef } from 'react'
import { reportError } from '../lib/errorReporter'

interface RateLimitConfig {
  maxRequests?: number
  windowMs?: number
  cooldownMs?: number
}

interface RateLimitState {
  isLimited: boolean
  remaining: number
  resetTime: Date | null
}

export function useRateLimit(config: RateLimitConfig = {}) {
  const { maxRequests = 10, windowMs = 60000, cooldownMs = 5000 } = config
  
  const [state, setState] = useState<RateLimitState>({
    isLimited: false,
    remaining: maxRequests,
    resetTime: null,
  })
  
  const requestsRef = useRef<number[]>([])
  const cooldownRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  const checkLimit = useCallback((): boolean => {
    const now = Date.now()
    
    // Clean old requests outside the window
    requestsRef.current = requestsRef.current.filter(
      (timestamp: number) => now - timestamp < windowMs
    )
    
    // Check if limited
    if (requestsRef.current.length >= maxRequests) {
      const oldestRequest = requestsRef.current[0]
      const resetTime = new Date(oldestRequest + windowMs)
      
      setState({
        isLimited: true,
        remaining: 0,
        resetTime,
      })
      
      reportError(new Error(`Rate limit exceeded. Try again at ${resetTime.toLocaleTimeString()}`))
      return false
    }
    
    // Check cooldown
    if (cooldownRef.current) {
      return false
    }
    
    // Record request
    requestsRef.current.push(now)
    
    // Set cooldown
    cooldownRef.current = setTimeout(() => {
      cooldownRef.current = null
    }, cooldownMs)
    
    setState({
      isLimited: false,
      remaining: maxRequests - requestsRef.current.length,
      resetTime: null,
    })
    
    return true
  }, [maxRequests, windowMs, cooldownMs])

  const resetLimit = useCallback(() => {
    requestsRef.current = []
    if (cooldownRef.current) {
      clearTimeout(cooldownRef.current)
      cooldownRef.current = null
    }
    setState({
      isLimited: false,
      remaining: maxRequests,
      resetTime: null,
    })
  }, [maxRequests])

  return {
    ...state,
    checkLimit,
    resetLimit,
  }
}

/**
 * Debounced request deduplication
 * Prevents duplicate in-flight requests
 */
const pendingRequests = new Map<string, Promise<unknown>>()

export async function dedupedRequest<T>(
  key: string,
  requestFn: () => Promise<T>
): Promise<T> {
  // Check if request is already in flight
  if (pendingRequests.has(key)) {
    return pendingRequests.get(key) as Promise<T>
  }
  
  // Create new request
  const promise = requestFn().finally(() => {
    pendingRequests.delete(key)
  })
  
  // Store pending request
  pendingRequests.set(key, promise)
  
  return promise
}

/**
 * Request queue for offline handling
 */
interface QueuedRequest {
  id: string
  key: string
  requestFn: () => Promise<unknown>
  retryCount: number
  maxRetries: number
}

const requestQueue: QueuedRequest[] = []
let isProcessingQueue = false

export function queueRequest<T>(
  key: string,
  requestFn: () => Promise<T>,
  maxRetries = 3
): void {
  const id = `${key}-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
  
  requestQueue.push({
    id,
    key,
    requestFn,
    retryCount: 0,
    maxRetries,
  })
  
  processQueue()
}

async function processQueue(): Promise<void> {
  if (isProcessingQueue || requestQueue.length === 0) return
  
  isProcessingQueue = true
  
  while (requestQueue.length > 0) {
    const request = requestQueue[0]
    
    try {
      await request.requestFn()
      requestQueue.shift() // Remove successful request
    } catch (error) {
      reportError(error)
      request.retryCount++
      
      if (request.retryCount >= request.maxRetries) {
        reportError(new Error(`Failed to execute ${request.key} after ${request.maxRetries} attempts`))
        requestQueue.shift() // Remove failed request
      } else {
        // Wait before retrying
        await new Promise(resolve => setTimeout(resolve, 1000 * request.retryCount))
      }
    }
  }
  
  isProcessingQueue = false
}

export function clearRequestQueue(): void {
  requestQueue.length = 0
}

export function getQueueLength(): number {
  return requestQueue.length
}
