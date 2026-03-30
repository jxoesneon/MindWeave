-- Migration: Add is_public to user_favorites for Community Presets
-- Path: supabase/migrations/20240329_mark_public_favorites.sql

ALTER TABLE public.user_favorites 
ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT false;

-- Policy to allow anyone to read public favorites
CREATE POLICY "Anyone can view public favorites" 
ON public.user_favorites FOR SELECT 
USING (is_public = true);
