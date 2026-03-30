import DOMPurify from 'dompurify'

/**
 * Sanitize HTML content to prevent XSS attacks
 */
export function sanitizeHtml(dirty: string): string {
  return DOMPurify.sanitize(dirty, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a'],
    ALLOWED_ATTR: ['href'],
  })
}

/**
 * Sanitize user input for text fields
 */
export function sanitizeInput(input: string): string {
  // Remove any HTML tags
  return input.replace(/<[^>]*>/g, '').trim()
}

/**
 * Validate and sanitize email addresses
 */
export function sanitizeEmail(email: string): string {
  const sanitized = sanitizeInput(email).toLowerCase()
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(sanitized) ? sanitized : ''
}

/**
 * Validate UUID format
 */
export function isValidUUID(str: string): boolean {
  const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
  return uuidRegex.test(str)
}

/**
 * Sanitize search query (allow alphanumeric and spaces only)
 */
export function sanitizeSearchQuery(query: string): string {
  return query.replace(/[^a-zA-Z0-9\s\-_@.]/g, '').trim()
}
