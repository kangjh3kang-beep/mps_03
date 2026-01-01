-- MPS Global Ecosystem: Supabase Schema (PostgreSQL)

-- 1. Organizations (Global/Regional/Group)
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('GLOBAL', 'REGION', 'GROUP')),
    parent_id UUID REFERENCES organizations(id),
    country_code TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Users with Role-Based Access
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    org_id UUID REFERENCES organizations(id),
    full_name TEXT,
    role TEXT NOT NULL CHECK (role IN ('ADMIN', 'DOCTOR', 'USER')),
    language_pref TEXT DEFAULT 'ko',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Health Measurements with Integrity Hash
CREATE TABLE measurements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES profiles(id),
    cartridge_type TEXT NOT NULL,
    raw_data JSONB NOT NULL,
    integrity_hash TEXT NOT NULL,
    trust_score FLOAT DEFAULT 1.0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. AI Self-Healing Logs
CREATE TABLE system_logs (
    id SERIAL PRIMARY KEY,
    action TEXT NOT NULL,
    status TEXT NOT NULL,
    severity TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE measurements ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own data" ON measurements
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all data" ON measurements
    FOR ALL USING (
        EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'ADMIN')
    );
