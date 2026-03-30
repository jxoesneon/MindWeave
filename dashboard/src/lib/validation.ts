import { z } from 'zod'

// Preset validation schema
export const presetSchema = z.object({
  name: z.string().min(1, 'Name is required').max(100, 'Name must be less than 100 characters'),
  description: z.string().max(500, 'Description must be less than 500 characters').optional(),
  band: z.enum(['Delta', 'Theta', 'Alpha', 'Beta', 'Gamma']),
  beat_frequency: z.number().min(0.5).max(100, 'Beat frequency must be between 0.5 and 100 Hz'),
  default_carrier: z.number().min(100).max(1000, 'Carrier frequency must be between 100 and 1000 Hz'),
  is_official: z.boolean().optional(),
  is_featured: z.boolean().optional(),
})

export type PresetFormData = z.infer<typeof presetSchema>

// Remote config validation schema
export const remoteConfigSchema = z.object({
  key: z.string().min(1).max(100).regex(/^[a-zA-Z_][a-zA-Z0-9_]*$/, 'Key must be a valid identifier'),
  value: z.union([z.string(), z.number(), z.boolean()]),
  description: z.string().max(200).optional(),
})

export type RemoteConfigFormData = z.infer<typeof remoteConfigSchema>

// User search validation
export const userSearchSchema = z.object({
  query: z.string().max(100).optional(),
  page: z.number().int().min(0).optional(),
  pageSize: z.number().int().min(1).max(100).optional(),
})

// Login validation
export const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
})

export type LoginFormData = z.infer<typeof loginSchema>

// Data retention validation
export const dataRetentionSchema = z.object({
  retentionDays: z.number().int().min(1).max(3650, 'Retention days must be between 1 and 3650'),
  autoDelete: z.boolean(),
})

// MFA validation
export const mfaSchema = z.object({
  code: z.string().length(6).regex(/^\d{6}$/, 'Code must be 6 digits'),
})

// Helper function to validate form data
export function validateForm<T>(schema: z.ZodSchema<T>, data: unknown): { 
  success: true; data: T } | { 
  success: false; errors: string[] 
} {
  const result = schema.safeParse(data)
  
  if (result.success) {
    return { success: true, data: result.data }
  }
  
  const errors = result.error.issues.map((err) => {
    const path = err.path.map(p => String(p)).join('.')
    return `${path}: ${err.message}`
  })
  return { success: false, errors }
}
