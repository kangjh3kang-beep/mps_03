-- 만파식(MPS) 글로벌 생태계 통합 스키마 (v2.1)
-- 홍익인간 이념 기반의 글로벌 건강 관리 플랫폼

-- 1. 글로벌 지역 관리 (Hierarchy)
CREATE TABLE countries (
    id TEXT PRIMARY KEY, -- ISO 3166-1 alpha-2 (e.g., 'KR', 'US')
    name_ko TEXT NOT NULL,
    name_en TEXT NOT NULL,
    currency TEXT,
    timezone TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE regions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    country_id TEXT REFERENCES countries(id),
    name_ko TEXT NOT NULL,
    name_en TEXT NOT NULL,
    parent_id UUID REFERENCES regions(id), -- 도/성 아래 시/군 등 계층 구조
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. 사용자 및 그룹 관리
CREATE TABLE profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    country_id TEXT REFERENCES countries(id),
    region_id UUID REFERENCES regions(id),
    gender TEXT CHECK (gender IN ('male', 'female', 'other')),
    birth_date DATE,
    language_preference TEXT DEFAULT 'ko',
    theme_preference TEXT DEFAULT 'dark', -- dark, light, senior
    grade TEXT CHECK (grade IN ('basic', 'premium', 'expert', 'admin')) DEFAULT 'basic',
    medical_history JSONB DEFAULT '[]', -- 특정 질병 그룹 관리를 위한 데이터
    points BIGINT DEFAULT 0, -- 보상 시스템
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE family_groups (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    creator_id UUID REFERENCES profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE family_members (
    group_id UUID REFERENCES family_groups(id) ON DELETE CASCADE,
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    role TEXT CHECK (role IN ('guardian', 'member')) DEFAULT 'member',
    PRIMARY KEY (group_id, profile_id)
);

-- 3. 하드웨어 및 측정 관리
CREATE TABLE devices (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    owner_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    model_type TEXT NOT NULL, -- 'standard', 'pro', 'expert'
    serial_number TEXT UNIQUE NOT NULL,
    firmware_version TEXT,
    status TEXT CHECK (status IN ('online', 'offline', 'error')) DEFAULT 'offline',
    last_seen TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE measurements (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    device_id UUID REFERENCES devices(id),
    cartridge_id TEXT NOT NULL,
    measurement_type TEXT NOT NULL, -- 'glucose', 'radon', 'ehd_gas', etc.
    raw_data JSONB NOT NULL, -- 원시 데이터 (고밀도 분석용)
    processed_value NUMERIC, -- 가공된 결과값
    unit TEXT,
    interpretation TEXT, -- AI 주치의 해석
    research_cited TEXT, -- 인용된 논문/연구 정보
    is_public_for_research BOOLEAN DEFAULT FALSE, -- 연구 데이터 공유 여부
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. AI 주치의 및 코칭
CREATE TABLE ai_coaching_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    context_type TEXT, -- 'measurement', 'daily', 'emergency'
    user_message TEXT,
    ai_response TEXT,
    cited_papers JSONB DEFAULT '[]', -- 인용 논문 리스트
    sentiment_score NUMERIC, -- 다정다감한 대응을 위한 감성 분석
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. 보안 및 감사 (FDA/ISO 준수)
CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users,
    action TEXT NOT NULL,
    resource TEXT NOT NULL,
    old_value JSONB,
    new_value JSONB,
    ip_address TEXT,
    user_agent TEXT,
    hash_chain TEXT, -- 데이터 무결성 검증용 해시
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

-- RLS (Row Level Security) 설정
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE measurements ENABLE ROW LEVEL SECURITY;
ALTER TABLE family_groups ENABLE ROW LEVEL SECURITY;

-- 정책 예시: 본인 프로필만 수정 가능
CREATE POLICY "Users can view their own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
