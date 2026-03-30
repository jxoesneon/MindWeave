/**
 * ConfirmDialog Component Tests
 * 
 * Tests for the confirmation dialog component and hook
 * 
 * @module components/ConfirmDialog.test
 */

import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import { ConfirmDialog, useConfirmDialog } from './ConfirmDialog'
import { renderHook } from '@testing-library/react'

describe('ConfirmDialog', () => {
  it('should render dialog with correct content', () => {
    const onCancel = vi.fn()
    const onConfirm = vi.fn()
    
    render(
      <ConfirmDialog
        isOpen={true}
        title="Test Title"
        message="Test Message"
        onCancel={onCancel}
        onConfirm={onConfirm}
        confirmLabel="Confirm"
        cancelLabel="Cancel"
        variant="danger"
      />
    )
    
    expect(screen.getByText('Test Title')).toBeInTheDocument()
    expect(screen.getByText('Test Message')).toBeInTheDocument()
    expect(screen.getByText('Confirm')).toBeInTheDocument()
    expect(screen.getByText('Cancel')).toBeInTheDocument()
  })

  it('should not render when closed', () => {
    const onCancel = vi.fn()
    const onConfirm = vi.fn()
    
    render(
      <ConfirmDialog
        isOpen={false}
        title="Test Title"
        message="Test Message"
        onCancel={onCancel}
        onConfirm={onConfirm}
        confirmLabel="Confirm"
        cancelLabel="Cancel"
        variant="danger"
      />
    )
    
    expect(screen.queryByText('Test Title')).not.toBeInTheDocument()
  })
})

describe('useConfirmDialog', () => {
  it('should return confirm function and dialog', () => {
    const { result } = renderHook(() => useConfirmDialog())
    
    expect(typeof result.current.confirm).toBe('function')
    expect(result.current.dialog).toBeDefined()
  })
})
