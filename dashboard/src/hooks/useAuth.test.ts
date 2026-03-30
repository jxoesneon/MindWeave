/**
 * useAuth Hook Tests
 * 
 * Comprehensive tests for authentication state management
 * 
 * @module hooks/useAuth.test
 */

import { describe, it, expect, vi, beforeEach } from 'vitest'
import { renderHook, waitFor } from '@testing-library/react'
import { useAuth } from './useAuth'

// Mock supabase
vi.mock('../lib/supabase', () => ({
  supabase: {
    auth: {
      getSession: vi.fn(),
      onAuthStateChange: vi.fn(() => ({ data: { subscription: { unsubscribe: vi.fn() } } })),
      signInWithPassword: vi.fn(),
      signOut: vi.fn(),
    },
    from: vi.fn(() => ({
      select: vi.fn(() => ({
        eq: vi.fn(() => ({
          single: vi.fn(),
        })),
      })),
      rpc: vi.fn(),
    })),
  },
}))

describe('useAuth', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should initialize with loading state', () => {
    const { result } = renderHook(() => useAuth())
    
    expect(result.current.loading).toBe(true)
    expect(result.current.user).toBeNull()
    expect(result.current.isAdmin).toBe(false)
    expect(result.current.isViewer).toBe(false)
  })

  it('should handle sign in', async () => {
    const { result } = renderHook(() => useAuth())
    
    // Wait for initial load
    await waitFor(() => expect(result.current.loading).toBe(false))
    
    // Test sign in
    const email = 'test@example.com'
    const password = 'password123'
    
    await result.current.signIn(email, password)
    
    // Verify signIn was called
    const { supabase } = await import('../lib/supabase')
    expect(supabase.auth.signInWithPassword).toHaveBeenCalledWith({ email, password })
  })

  it('should handle sign out', async () => {
    const { result } = renderHook(() => useAuth())
    
    await waitFor(() => expect(result.current.loading).toBe(false))
    
    await result.current.signOut()
    
    const { supabase } = await import('../lib/supabase')
    expect(supabase.auth.signOut).toHaveBeenCalled()
  })
})
