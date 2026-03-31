-- Create remote_config table for feature flags and dynamic configuration
-- This allows real-time feature toggling without app updates

CREATE TABLE IF NOT EXISTS remote_config (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    value_type TEXT NOT NULL CHECK (value_type IN ('boolean', 'integer', 'double', 'string', 'string_list', 'json')),
    description TEXT,
    default_value JSONB,
    requires_restart BOOLEAN DEFAULT false,
    minimum_app_version TEXT,
    platform_filter TEXT[], -- ['ios', 'android', 'web', 'windows', 'macos', 'linux']
    user_segment TEXT, -- 'all', 'beta', 'new_users', 'premium'
    updated_by UUID REFERENCES auth.users(id),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for quick lookups
CREATE INDEX idx_remote_config_platform ON remote_config USING GIN(platform_filter);
CREATE INDEX idx_remote_config_updated_at ON remote_config(updated_at);

-- Insert default feature flags
INSERT INTO remote_config (key, value, value_type, description, default_value) VALUES
    ('show_donation_banner', 'true', 'boolean', 'Show donation banner in settings', 'true'),
    ('enable_premium_features', 'false', 'boolean', 'Enable premium preset features', 'false'),
    ('show_ads', 'false', 'boolean', 'Show advertisements (currently disabled)', 'false'),
    ('enable_health_integration', 'true', 'boolean', 'Enable HealthKit/Google Fit integration', 'true'),
    ('enable_music_mixing', 'true', 'boolean', 'Enable music library mixing feature', 'true'),
    ('enable_session_history', 'true', 'boolean', 'Enable session history tracking', 'true'),
    ('enable_custom_presets', 'false', 'boolean', 'Enable user custom preset creation', 'false'),
    ('enable_analytics', 'true', 'boolean', 'Enable PostHog analytics (when implemented)', 'true'),
    ('max_free_sessions_per_day', '5', 'integer', 'Maximum free sessions per day for non-supporters', '5'),
    ('session_duration_limit', '60', 'integer', 'Maximum session duration in minutes', '60'),
    ('donation_goal_amount', '500.0', 'double', 'Monthly donation goal amount in USD', '500.0'),
    ('current_version', '"1.0.0"', 'string', 'Current app version', '"1.0.0"'),
    ('min_supported_version', '"1.0.0"', 'string', 'Minimum supported app version', '"1.0.0"'),
    ('featured_preset_ids', '["deep_sleep", "meditation", "relaxation"]', 'json', 'Featured preset IDs for discovery', '["deep_sleep", "meditation", "relaxation"]'),
    ('motivational_quote', '"Take a deep breath and begin your journey to inner peace."', 'string', 'Daily motivational quote', '"Take a deep breath and begin your journey to inner peace."'),
    ('supporter_price', '5.0', 'double', 'Supporter tier monthly price', '5.0'),
    ('advocate_price', '15.0', 'double', 'Advocate tier monthly price', '15.0'),
    ('champion_price', '25.0', 'double', 'Champion tier monthly price', '25.0'),
    ('donation_amounts', '["3", "5", "10", "25"]', 'string_list', 'One-time donation amounts', '["3", "5", "10", "25"]')
ON CONFLICT (key) DO NOTHING;

-- RLS Policies
ALTER TABLE remote_config ENABLE ROW LEVEL SECURITY;

-- Anyone can read remote config (needed for feature flags)
CREATE POLICY "Anyone can read remote config" ON remote_config
    FOR SELECT TO anon, authenticated USING (true);

-- Only admins can modify remote config
CREATE POLICY "Only admins can modify remote config" ON remote_config
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE id = auth.uid()
            AND raw_user_meta_data->>'role' = 'admin'
        )
    );

-- Function to get all configs for a specific user context
CREATE OR REPLACE FUNCTION get_remote_config_for_user(
    app_version TEXT DEFAULT NULL,
    user_platform TEXT DEFAULT NULL,
    is_premium BOOLEAN DEFAULT false
)
RETURNS TABLE (key TEXT, value JSONB, value_type TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT rc.key, rc.value, rc.value_type
    FROM remote_config rc
    WHERE (rc.minimum_app_version IS NULL OR 
           (app_version IS NOT NULL AND rc.minimum_app_version <= app_version))
      AND (rc.platform_filter IS NULL OR 
           user_platform IS NULL OR 
           user_platform = ANY(rc.platform_filter))
      AND (rc.user_segment IS NULL OR 
           rc.user_segment = 'all' OR
           (rc.user_segment = 'premium' AND is_premium) OR
           (rc.user_segment = 'new_users' AND NOT is_premium));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Audit log table for tracking config changes
CREATE TABLE IF NOT EXISTS remote_config_audit (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    config_key TEXT NOT NULL,
    old_value JSONB,
    new_value JSONB,
    changed_by UUID REFERENCES auth.users(id),
    changed_at TIMESTAMPTZ DEFAULT NOW(),
    change_reason TEXT
);

-- Trigger to log config changes
CREATE OR REPLACE FUNCTION log_remote_config_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO remote_config_audit (config_key, old_value, new_value, changed_by, change_reason)
        VALUES (NEW.key, OLD.value, NEW.value, NEW.updated_by, NEW.description);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_remote_config_changes
    AFTER UPDATE ON remote_config
    FOR EACH ROW
    EXECUTE FUNCTION log_remote_config_changes();
