/// <reference types="vite/client" />
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || ''
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || ''

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

export type User = {
  id: string
  created_at: string
  last_active: string
  is_anonymous: boolean
  device_type: string
  app_version: string
}

export type Session = {
  id: string
  user_id: string
  started_at: string
  ended_at: string | null
  duration_seconds: number | null
  preset_id: string
  beat_frequency: number
  carrier_frequency: number
  volume_level: number
  completed: boolean
}

export type Preset = {
  id: string
  name: string
  description: string
  band: string
  beat_frequency: number
  default_carrier: number
  metadata: Record<string, unknown>
  is_official: boolean
  is_featured: boolean
  usage_count: number
}

export type Donation = {
  id: string
  user_id: string
  created_at: string
  amount: number
  currency: string
  provider: string
  is_recurring: boolean
  recognition_name: string | null
}

export type RemoteConfig = {
  key: string
  value: unknown
  updated_at: string
  updated_by: string
  description: string
}

export type AuditLog = {
  id: string
  performed_at: string
  action: string
  entity_type: string
  entity_id: string
  old_value: Record<string, unknown> | null
  new_value: Record<string, unknown> | null
  performed_by: string
}
