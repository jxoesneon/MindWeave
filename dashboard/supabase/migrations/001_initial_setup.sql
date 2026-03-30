-- MindWeave Admin Dashboard - Database Setup
-- Run this in your Supabase SQL Editor to create all required tables

-- ============================================
-- 1. USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  is_anonymous BOOLEAN DEFAULT true,
  device_type TEXT,
  app_version TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_active TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.users IS 'App users synced from auth.users';

-- ============================================
-- 2. PRESETS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.presets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  band TEXT NOT NULL CHECK (band IN ('Delta', 'Theta', 'Alpha', 'Beta', 'Gamma')),
  beat_frequency DECIMAL(5,2) NOT NULL,
  default_carrier INTEGER DEFAULT 250,
  is_official BOOLEAN DEFAULT false,
  is_featured BOOLEAN DEFAULT false,
  usage_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.presets IS 'Brainwave frequency presets for binaural beats';

-- ============================================
-- 3. SESSIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  beat_frequency DECIMAL(5,2),
  duration_seconds INTEGER,
  started_at TIMESTAMPTZ DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.sessions IS 'User meditation/listening sessions';

-- ============================================
-- 4. DONATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.donations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  amount DECIMAL(10,2) NOT NULL,
  currency TEXT DEFAULT 'USD',
  platform TEXT, -- 'ios', 'android', 'stripe'
  transaction_id TEXT,
  donated_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.donations IS 'User donations and contributions';

-- ============================================
-- 5. AUDIT LOG TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.audit_log (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  action TEXT NOT NULL CHECK (action IN ('CREATE', 'INSERT', 'UPDATE', 'DELETE')),
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  old_value JSONB,
  new_value JSONB,
  performed_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.audit_log IS 'Admin dashboard audit trail';

-- ============================================
-- 6. ADMIN LOGIN HISTORY TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.admin_login_history (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL,
  success BOOLEAN NOT NULL,
  failure_reason TEXT,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.admin_login_history IS 'Admin login attempt tracking';

-- ============================================
-- 7. REMOTE CONFIG TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.remote_config (
  key TEXT PRIMARY KEY,
  value JSONB NOT NULL,
  description TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  updated_by TEXT
);

COMMENT ON TABLE public.remote_config IS 'Feature flags and app configuration';

-- ============================================
-- 8. USER ROLES TABLE (for admin access)
-- ============================================
CREATE TABLE IF NOT EXISTS public.user_roles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'viewer')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, role)
);

COMMENT ON TABLE public.user_roles IS 'User role assignments for admin dashboard';

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.presets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.donations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_login_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.remote_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

-- Check if user is admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_roles 
    WHERE user_id = auth.uid() AND role = 'admin'
  );
END;
$$;

-- Check if user is viewer (or admin)
CREATE OR REPLACE FUNCTION public.is_viewer()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_roles 
    WHERE user_id = auth.uid() AND role IN ('admin', 'viewer')
  );
END;
$$;

-- Log admin login attempt
CREATE OR REPLACE FUNCTION public.log_admin_login(
  p_email TEXT,
  p_success BOOLEAN,
  p_failure_reason TEXT DEFAULT NULL,
  p_ip_address TEXT DEFAULT NULL,
  p_user_agent TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.admin_login_history (email, success, failure_reason, ip_address, user_agent)
  VALUES (p_email, p_success, p_failure_reason, p_ip_address, p_user_agent);
END;
$$;

-- Log audit event
CREATE OR REPLACE FUNCTION public.log_audit_event(
  p_action TEXT,
  p_entity_type TEXT,
  p_entity_id TEXT,
  p_old_value JSONB DEFAULT NULL,
  p_new_value JSONB DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.audit_log (action, entity_type, entity_id, old_value, new_value, performed_by)
  VALUES (p_action, p_entity_type, p_entity_id, p_old_value, p_new_value, auth.uid());
END;
$$;

-- ============================================
-- RLS POLICIES
-- ============================================

-- Users: Admins can view all, users can view own
CREATE POLICY "Admins can view all users"
  ON public.users FOR SELECT
  TO authenticated
  USING (is_admin());

CREATE POLICY "Users can view own data"
  ON public.users FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

-- Presets: Everyone can view, only admins can modify
CREATE POLICY "Everyone can view presets"
  ON public.presets FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Only admins can modify presets"
  ON public.presets FOR ALL
  TO authenticated
  USING (is_admin());

-- Sessions: Users can view own, admins can view all
CREATE POLICY "Users can view own sessions"
  ON public.sessions FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all sessions"
  ON public.sessions FOR SELECT
  TO authenticated
  USING (is_admin());

-- Donations: Admins can view all
CREATE POLICY "Admins can view all donations"
  ON public.donations FOR SELECT
  TO authenticated
  USING (is_admin());

-- Audit Log: Admins can view all
CREATE POLICY "Admins can view audit log"
  ON public.audit_log FOR SELECT
  TO authenticated
  USING (is_admin());

-- Admin Login History: Admins can view
CREATE POLICY "Admins can view login history"
  ON public.admin_login_history FOR SELECT
  TO authenticated
  USING (is_admin());

-- Remote Config: Everyone can view, only admins can modify
CREATE POLICY "Everyone can view remote config"
  ON public.remote_config FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Only admins can modify remote config"
  ON public.remote_config FOR ALL
  TO authenticated
  USING (is_admin());

-- User Roles: Admins can view all
CREATE POLICY "Admins can manage user roles"
  ON public.user_roles FOR ALL
  TO authenticated
  USING (is_admin());

-- ============================================
-- DEFAULT DATA
-- ============================================

-- Insert default presets
INSERT INTO public.presets (name, description, band, beat_frequency, is_official) VALUES
  ('Deep Sleep', 'Delta waves for deep restorative sleep', 'Delta', 2.5, true),
  ('Meditation', 'Theta waves for deep meditation', 'Theta', 6.0, true),
  ('Relaxation', 'Alpha waves for relaxation and calm', 'Alpha', 10.0, true),
  ('Focus', 'Beta waves for concentration and focus', 'Beta', 20.0, true),
  ('Peak Performance', 'Gamma waves for heightened perception', 'Gamma', 40.0, true)
ON CONFLICT (id) DO NOTHING;

-- Insert default remote config
INSERT INTO public.remote_config (key, value, description) VALUES
  ('show_ads', 'true', 'Enable advertisements in the app'),
  ('donation_prompt_interval_days', '7', 'Days between donation prompts'),
  ('min_session_seconds_for_review', '300', 'Minimum session duration before showing review prompt'),
  ('max_free_sessions_per_day', '3', 'Maximum free sessions for anonymous users'),
  ('premium_price_usd', '4.99', 'Monthly premium subscription price')
ON CONFLICT (key) DO UPDATE SET description = EXCLUDED.description;

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX IF NOT EXISTS idx_users_created_at ON public.users(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_users_last_active ON public.users(last_active DESC);
CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON public.sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_started_at ON public.sessions(started_at DESC);
CREATE INDEX IF NOT EXISTS idx_donations_donated_at ON public.donations(donated_at DESC);
CREATE INDEX IF NOT EXISTS idx_donations_user_id ON public.donations(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_created_at ON public.audit_log(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_log_entity_type ON public.audit_log(entity_type);
CREATE INDEX IF NOT EXISTS idx_admin_login_history_created_at ON public.admin_login_history(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_presets_band ON public.presets(band);
CREATE INDEX IF NOT EXISTS idx_presets_is_official ON public.presets(is_official);

-- ============================================
-- REALTIME SUBSCRIPTIONS (optional)
-- ============================================

-- Enable realtime for tables that need live updates
BEGIN;
  -- Add tables to realtime publication
  -- Note: Run this only if you have realtime enabled
  -- ALTER PUBLICATION supabase_realtime ADD TABLE public.sessions;
  -- ALTER PUBLICATION supabase_realtime ADD TABLE public.donations;
COMMIT;

-- ============================================
-- VERIFICATION
-- ============================================

-- Verify all tables exist
SELECT 'users' as table_name, COUNT(*) as row_count FROM public.users
UNION ALL
SELECT 'presets', COUNT(*) FROM public.presets
UNION ALL
SELECT 'sessions', COUNT(*) FROM public.sessions
UNION ALL
SELECT 'donations', COUNT(*) FROM public.donations
UNION ALL
SELECT 'audit_log', COUNT(*) FROM public.audit_log
UNION ALL
SELECT 'admin_login_history', COUNT(*) FROM public.admin_login_history
UNION ALL
SELECT 'remote_config', COUNT(*) FROM public.remote_config
UNION ALL
SELECT 'user_roles', COUNT(*) FROM public.user_roles;
