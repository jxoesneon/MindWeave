/**
 * Analytics Hooks Tests
 * 
 * Comprehensive tests for analytics data fetching and aggregation
 * 
 * @module hooks/useAnalytics.test
 */

import { describe, it, expect, vi, beforeEach } from 'vitest'
import { renderHook, waitFor } from '@testing-library/react'
import { useAnalytics, useDailyActiveUsers, useDonationMetrics } from './useAnalytics'

// Mock supabase
vi.mock('../lib/supabase', () => ({
  supabase: {
    from: vi.fn(() => ({
      select: vi.fn(() => ({
        gte: vi.fn(() => ({
          lte: vi.fn(() => ({
            order: vi.fn(() => ({
              data: [
                { id: '1', user_id: 'user1', started_at: '2024-01-01', duration_seconds: 300 },
                { id: '2', user_id: 'user2', started_at: '2024-01-02', duration_seconds: 600 },
              ],
              error: null,
            })),
          })),
        })),
      })),
    })),
    rpc: vi.fn(() => ({ data: 100, error: null })),
  },
}))

describe('useAnalytics', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should fetch analytics data', async () => {
    const { result } = renderHook(() => useAnalytics())

    await waitFor(() => expect(result.current.loading).toBe(false))

    expect(result.current.stats).toBeDefined()
    expect(result.current.error).toBeNull()
  })

  it('should handle loading state', () => {
    const { result } = renderHook(() => useAnalytics())

    expect(result.current.loading).toBe(true)
  })
})

describe('useDailyActiveUsers', () => {
  it('should fetch daily active users', async () => {
    const { result } = renderHook(() => useDailyActiveUsers(30))

    await waitFor(() => expect(result.current.loading).toBe(false))

    expect(result.current.data).toBeDefined()
    expect(Array.isArray(result.current.data)).toBe(true)
  })
})

describe('useDonationMetrics', () => {
  it('should calculate donation metrics', async () => {
    const { result } = renderHook(() => useDonationMetrics())

    await waitFor(() => expect(result.current.loading).toBe(false))

    expect(result.current.data).toBeDefined()
    expect(result.current.totalAmount).toBeDefined()
    expect(result.current.totalCount).toBeDefined()
  })
})
