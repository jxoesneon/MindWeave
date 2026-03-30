/**
 * Rate Limit Hook Tests
 * 
 * Tests for rate limiting functionality
 * 
 * @module hooks/useRateLimit.test
 */

import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'
import { renderHook, act } from '@testing-library/react'
import { useRateLimit, dedupedRequest, queueRequest, clearRequestQueue, getQueueLength } from './useRateLimit'

describe('useRateLimit', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    vi.useFakeTimers()
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  it('should allow requests within limit', () => {
    const { result } = renderHook(() => useRateLimit({ maxRequests: 5, windowMs: 60000 }))

    act(() => {
      const allowed = result.current.checkLimit()
      expect(allowed).toBe(true)
    })
  })

  it('should track remaining requests', () => {
    const { result } = renderHook(() => useRateLimit({ maxRequests: 5, windowMs: 60000 }))

    expect(result.current.remaining).toBe(5)
  })

  it('should enforce rate limit', () => {
    const { result } = renderHook(() => useRateLimit({ maxRequests: 2, windowMs: 60000 }))

    act(() => {
      result.current.checkLimit()
      result.current.checkLimit()
      const blocked = result.current.checkLimit()
      expect(blocked).toBe(false)
    })
  })
})

describe('dedupedRequest', () => {
  it('should deduplicate identical requests', async () => {
    const mockFn = vi.fn().mockResolvedValue('result')

    // First request
    const promise1 = dedupedRequest('key1', mockFn)
    // Duplicate request (should return same promise)
    const promise2 = dedupedRequest('key1', mockFn)

    expect(mockFn).toHaveBeenCalledTimes(1)
    expect(promise1).toBe(promise2)
  })

  it('should allow different keys', async () => {
    const mockFn = vi.fn().mockResolvedValue('result')

    dedupedRequest('key1', mockFn)
    dedupedRequest('key2', mockFn)

    expect(mockFn).toHaveBeenCalledTimes(2)
  })
})

describe('queueRequest', () => {
  beforeEach(() => {
    clearRequestQueue()
  })

  it('should queue requests', async () => {
    const mockRequest = vi.fn()
    
    queueRequest('test-key', mockRequest, 3)
    
    // Request should be added to queue
    expect(getQueueLength()).toBeGreaterThan(0)
  })
})
