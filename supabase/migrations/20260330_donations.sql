-- Create donations table for tracking user contributions
-- This supports the ethical monetization model (usage-based donation prompts)

CREATE TABLE IF NOT EXISTS donations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE SET NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    currency TEXT DEFAULT 'USD',
    type TEXT NOT NULL CHECK (type IN ('one_time', 'monthly', 'subscription')),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    provider TEXT CHECK (provider IN ('stripe', 'paypal', 'github_sponsors', 'open_collective', 'in_app_purchase')),
    provider_transaction_id TEXT,
    message TEXT,
    is_anonymous BOOLEAN DEFAULT false,
    recognition_tier TEXT CHECK (recognition_tier IN ('contributor', 'supporter', 'advocate', 'champion', 'patron')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    processed_at TIMESTAMPTZ,
    refunded_at TIMESTAMPTZ,
    metadata JSONB
);

-- Indexes for common queries
CREATE INDEX idx_donations_user_id ON donations(user_id);
CREATE INDEX idx_donations_status ON donations(status);
CREATE INDEX idx_donations_created_at ON donations(created_at);
CREATE INDEX idx_donations_type ON donations(type);

-- View for funding progress (total donations, supporter count, etc.)
CREATE OR REPLACE VIEW funding_progress AS
SELECT
    COUNT(*) FILTER (WHERE status = 'completed') as total_donations,
    COUNT(DISTINCT user_id) FILTER (WHERE status = 'completed' AND user_id IS NOT NULL) as unique_supporters,
    COALESCE(SUM(amount) FILTER (WHERE status = 'completed'), 0) as total_amount,
    NOW() as calculated_at
FROM donations;

-- RLS Policies
ALTER TABLE donations ENABLE ROW LEVEL SECURITY;

-- Users can view their own donations
CREATE POLICY "Users can view own donations" ON donations
    FOR SELECT USING (auth.uid() = user_id);

-- Only authenticated users can insert donations
CREATE POLICY "Authenticated users can create donations" ON donations
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Only service role can update donation status
CREATE POLICY "Service role can update donations" ON donations
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE id = auth.uid()
            AND raw_user_meta_data->>'role' = 'service'
        )
    );

-- Function to calculate recognition tier based on cumulative donations
CREATE OR REPLACE FUNCTION calculate_recognition_tier(user_uuid UUID)
RETURNS TEXT AS $$
DECLARE
    total DECIMAL;
BEGIN
    SELECT COALESCE(SUM(amount), 0)
    INTO total
    FROM donations
    WHERE user_id = user_uuid AND status = 'completed';

    RETURN CASE
        WHEN total >= 500 THEN 'patron'
        WHEN total >= 100 THEN 'champion'
        WHEN total >= 50 THEN 'advocate'
        WHEN total >= 10 THEN 'supporter'
        WHEN total > 0 THEN 'contributor'
        ELSE NULL
    END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to auto-update recognition tier on donation completion
CREATE OR REPLACE FUNCTION update_recognition_tier()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
        NEW.recognition_tier = calculate_recognition_tier(NEW.user_id);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_recognition_tier
    BEFORE UPDATE ON donations
    FOR EACH ROW
    EXECUTE FUNCTION update_recognition_tier();
