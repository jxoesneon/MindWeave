import { describe, it, expect } from 'vitest'
import { renderHook, waitFor } from '@testing-library/react'
import { useDebounce } from './useDebounce'

describe('useDebounce', () => {
  it('should debounce value changes', async () => {
    const { result, rerender } = renderHook(
      ({ value, delay }) => useDebounce(value, delay),
      {
        initialProps: { value: 'initial', delay: 100 }
      }
    )

    expect(result.current).toBe('initial')

    // Change value
    rerender({ value: 'changed', delay: 100 })
    
    // Value should still be 'initial' immediately
    expect(result.current).toBe('initial')

    // Wait for debounce
    await waitFor(() => expect(result.current).toBe('changed'), {
      timeout: 200
    })
  })
})
