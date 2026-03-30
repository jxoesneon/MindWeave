/**
 * Focus Management Utilities
 * 
 * Provides accessible focus management for keyboard navigation
 * and focus trapping within modals/dialogs
 * 
 * @module lib/focusManagement
 */

/**
 * Focusable elements selector
 */
const FOCUSABLE_SELECTORS = [
  'button:not([disabled])',
  'a[href]',
  'input:not([disabled])',
  'select:not([disabled])',
  'textarea:not([disabled])',
  '[tabindex]:not([tabindex="-1"])',
].join(', ')

/**
 * Get all focusable elements within a container
 */
export function getFocusableElements(container: HTMLElement): HTMLElement[] {
  return Array.from(container.querySelectorAll(FOCUSABLE_SELECTORS))
}

/**
 * Trap focus within a container (for modals/dialogs)
 */
export function trapFocus(container: HTMLElement): () => void {
  const focusableElements = getFocusableElements(container)
  const firstElement = focusableElements[0]
  const lastElement = focusableElements[focusableElements.length - 1]
  
  const handleKeyDown = (e: KeyboardEvent) => {
    if (e.key !== 'Tab') return
    
    if (e.shiftKey) {
      // Shift + Tab
      if (document.activeElement === firstElement) {
        e.preventDefault()
        lastElement?.focus()
      }
    } else {
      // Tab
      if (document.activeElement === lastElement) {
        e.preventDefault()
        firstElement?.focus()
      }
    }
  }
  
  container.addEventListener('keydown', handleKeyDown)
  firstElement?.focus()
  
  return () => {
    container.removeEventListener('keydown', handleKeyDown)
  }
}

/**
 * Set focus to an element safely
 */
export function setFocus(element: HTMLElement | null): void {
  if (element && element.focus) {
    element.focus()
  }
}

/**
 * Save and restore focus (for modals)
 */
export function saveFocus(): () => void {
  const savedElement = document.activeElement as HTMLElement
  
  return () => {
    setFocus(savedElement)
  }
}

/**
 * Check if element is focusable
 */
export function isFocusable(element: HTMLElement): boolean {
  return element.matches(FOCUSABLE_SELECTORS)
}
