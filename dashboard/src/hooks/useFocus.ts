/**
 * useFocus Hook
 * 
 * Hook for managing focus within components
 * 
 * @module hooks/useFocus
 */

import { useRef, useCallback, useEffect } from 'react'

interface UseFocusOptions {
  autoFocus?: boolean
}

export function useFocus<T extends HTMLElement>(options: UseFocusOptions = {}) {
  const ref = useRef<T>(null)
  const { autoFocus = false } = options

  useEffect(() => {
    if (autoFocus && ref.current) {
      ref.current.focus()
    }
  }, [autoFocus])

  const focus = useCallback(() => {
    ref.current?.focus()
  }, [])

  const blur = useCallback(() => {
    ref.current?.blur()
  }, [])

  return {
    ref,
    focus,
    blur,
  }
}
