-- MindWeave Admin User Setup Script
-- Run this in your Supabase SQL Editor (https://app.supabase.com/project/vjbnomhbviqdizplxjze/sql-editor)

-- Step 1: Enable the is_admin function if not exists
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_roles 
    WHERE user_id = auth.uid() 
    AND role = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 2: Create user_roles table if not exists
CREATE TABLE IF NOT EXISTS public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('admin', 'viewer')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, role)
);

-- Step 3: Enable RLS on user_roles
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

-- Step 4: Create RLS policies for user_roles
CREATE POLICY "Allow admins to manage roles" ON public.user_roles
  FOR ALL USING (public.is_admin());

CREATE POLICY "Allow users to view their own roles" ON public.user_roles
  FOR SELECT USING (user_id = auth.uid());

-- Step 5: Create the admin user via Supabase Auth API
-- Note: You'll need to create the user in Auth UI first, then run:

-- After creating user in Auth UI, add admin role:
-- INSERT INTO public.user_roles (user_id, role) 
-- VALUES ('USER_UUID_FROM_AUTH', 'admin');

-- Or use this to create the user directly (requires supabase_admin role):
-- This will only work if you have service_role access

-- Alternative: Create user via Supabase Dashboard Auth section, then:
-- 1. Go to Authentication > Users
-- 2. Click "Add User"
-- 3. Email: joseeduardox@gmail.com
-- 4. Password: !Anya40220
-- 5. Confirm email (check the box)
-- 6. Copy the UUID
-- 7. Run: INSERT INTO public.user_roles (user_id, role) VALUES ('PASTE_UUID_HERE', 'admin');

-- Step 6: Add is_featured column to presets if not exists
ALTER TABLE public.presets ADD COLUMN IF NOT EXISTS is_featured BOOLEAN DEFAULT false;

-- Step 7: Create user_ad_settings table for per-user ad control
CREATE TABLE IF NOT EXISTS public.user_ad_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  ads_enabled BOOLEAN DEFAULT true,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Enable RLS on user_ad_settings
ALTER TABLE public.user_ad_settings ENABLE ROW LEVEL SECURITY;

-- Policies for user_ad_settings
CREATE POLICY "Allow admins to manage user ad settings" ON public.user_ad_settings
  FOR ALL USING (public.is_admin());

CREATE POLICY "Allow users to view their own ad settings" ON public.user_ad_settings
  FOR SELECT USING (user_id = auth.uid());

-- Step 8: Create audit_log table if not exists
CREATE TABLE IF NOT EXISTS public.audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT,
  old_value JSONB,
  new_value JSONB,
  performed_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Step 9: Create function to automatically log changes
CREATE OR REPLACE FUNCTION public.log_audit_event()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.audit_log (action, entity_type, entity_id, old_value, new_value, performed_by)
  VALUES (
    TG_OP,
    TG_TABLE_NAME,
    CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
    CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN to_jsonb(OLD) ELSE NULL END,
    CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN to_jsonb(NEW) ELSE NULL END,
    COALESCE(current_setting('request.jwt.claims', true)::json->>'sub', 'system')
  );
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Add triggers for audit logging
DROP TRIGGER IF EXISTS audit_remote_config ON public.remote_config;
CREATE TRIGGER audit_remote_config
  AFTER INSERT OR UPDATE OR DELETE ON public.remote_config
  FOR EACH ROW EXECUTE FUNCTION public.log_audit_event();

DROP TRIGGER IF EXISTS audit_presets ON public.presets;
CREATE TRIGGER audit_presets
  AFTER INSERT OR UPDATE OR DELETE ON public.presets
  FOR EACH ROW EXECUTE FUNCTION public.log_audit_event();

DROP TRIGGER IF EXISTS audit_user_roles ON public.user_roles;
CREATE TRIGGER audit_user_roles
  AFTER INSERT OR UPDATE OR DELETE ON public.user_roles
  FOR EACH ROW EXECUTE FUNCTION public.log_audit_event();

-- Step 9: Create remote_config table if not exists
CREATE TABLE IF NOT EXISTS public.remote_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT UNIQUE NOT NULL,
  value JSONB NOT NULL,
  description TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  updated_by UUID REFERENCES auth.users(id)
);

-- Step 10: Enable RLS on remote_config
ALTER TABLE public.remote_config ENABLE ROW LEVEL SECURITY;

-- Step 11: Create remote_config policies
CREATE POLICY "Allow anyone to view remote config" ON public.remote_config
  FOR SELECT USING (true);

CREATE POLICY "Allow admins to manage remote config" ON public.remote_config
  FOR ALL USING (public.is_admin());

-- Step 12: Insert default remote config values
INSERT INTO public.remote_config (key, value, description) VALUES
  ('show_ads', 'true', 'Whether to show ads to non-donating users'),
  ('donation_prompt_frequency', '3', 'How often to show donation prompt (sessions)'),
  ('max_free_sessions', '10', 'Maximum free sessions before requiring donation'),
  ('app_version_min', '"1.0.0"', 'Minimum required app version'),
  ('app_version_latest', '"1.0.0"', 'Latest app version available')
ON CONFLICT (key) DO NOTHING;

-- Step 13: Create RPC function for getting analytics
CREATE OR REPLACE FUNCTION public.get_analytics_stats()
RETURNS TABLE (
  total_users BIGINT,
  total_sessions BIGINT,
  total_donations NUMERIC,
  active_users_today BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    (SELECT COUNT(*) FROM auth.users) as total_users,
    (SELECT COUNT(*) FROM public.sessions) as total_sessions,
    (SELECT COALESCE(SUM(amount), 0) FROM public.donations) as total_donations,
    (SELECT COUNT(DISTINCT user_id) FROM public.sessions WHERE created_at > NOW() - INTERVAL '24 hours') as active_users_today;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create admin_login_history table for tracking login attempts
CREATE TABLE IF NOT EXISTS public.admin_login_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  ip_address TEXT,
  user_agent TEXT,
  success BOOLEAN NOT NULL,
  failure_reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on admin_login_history
ALTER TABLE public.admin_login_history ENABLE ROW LEVEL SECURITY;

-- Only admins can view login history
CREATE POLICY "Allow admins to view login history" ON public.admin_login_history
  FOR ALL USING (public.is_admin());

-- Grant permissions
GRANT ALL ON public.admin_login_history TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;
GRANT EXECUTE ON FUNCTION public.log_audit_event() TO authenticated;
GRANT SELECT ON public.remote_config TO authenticated;
GRANT ALL ON public.audit_log TO authenticated;
GRANT ALL ON public.user_roles TO authenticated;
GRANT ALL ON public.user_ad_settings TO authenticated;
GRANT SELECT ON public.presets TO authenticated;

