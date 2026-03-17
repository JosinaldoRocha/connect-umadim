-- =============================================================================
-- CONECTA UMADIM - Setup Supabase Storage
-- =============================================================================
-- Execute este script no Supabase SQL Editor:
-- Dashboard → SQL Editor → New query → Cole o conteúdo → Run
-- =============================================================================

-- 1. Criar bucket para fotos de perfil dos usuários
INSERT INTO storage.buckets (id, name, public)
VALUES ('user_profile_images', 'user_profile_images', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Criar bucket para imagens dos eventos
INSERT INTO storage.buckets (id, name, public)
VALUES ('event_images', 'event_images', true)
ON CONFLICT (id) DO NOTHING;

-- 3. Políticas para user_profile_images
-- Permite upload (anon key - app usa Firebase Auth)
CREATE POLICY "Allow upload user_profile_images"
ON storage.objects FOR INSERT
TO anon
WITH CHECK (bucket_id = 'user_profile_images');

-- Permite atualizar (sobrescrever foto)
CREATE POLICY "Allow update user_profile_images"
ON storage.objects FOR UPDATE
TO anon
USING (bucket_id = 'user_profile_images');

-- 4. Políticas para event_images
CREATE POLICY "Allow upload event_images"
ON storage.objects FOR INSERT
TO anon
WITH CHECK (bucket_id = 'event_images');

CREATE POLICY "Allow update event_images"
ON storage.objects FOR UPDATE
TO anon
USING (bucket_id = 'event_images');
