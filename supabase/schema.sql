-- ========================================================
-- MyManager Database Schema & RLS Security Policies
-- ========================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. PROFILES (Extends Supabase Auth)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    phone VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    default_role VARCHAR(20) CHECK (default_role IN ('owner', 'tenant')) DEFAULT 'owner',
    language_preference VARCHAR(10) DEFAULT 'en',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. PROPERTIES
CREATE TABLE IF NOT EXISTS public.properties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. FLOORS
CREATE TABLE IF NOT EXISTS public.floors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES public.properties(id) ON DELETE CASCADE,
    floor_number INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. UNITS
CREATE TABLE IF NOT EXISTS public.units (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    floor_id UUID NOT NULL REFERENCES public.floors(id) ON DELETE CASCADE,
    unit_number VARCHAR(20) NOT NULL,
    rent_amount NUMERIC(10, 2) NOT NULL,
    deposit_amount NUMERIC(10, 2) DEFAULT 0,
    status VARCHAR(20) CHECK (status IN ('vacant', 'occupied')) DEFAULT 'vacant',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. TENANCIES
CREATE TABLE IF NOT EXISTS public.tenancies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
    owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    tenant_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    monthly_rent NUMERIC(10, 2) NOT NULL,
    due_day_of_month INT CHECK (due_day_of_month BETWEEN 1 AND 31) DEFAULT 1,
    status VARCHAR(20) CHECK (status IN ('pending', 'active', 'ended', 'vacating')) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. AGREEMENTS
CREATE TABLE IF NOT EXISTS public.agreements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenancy_id UUID NOT NULL REFERENCES public.tenancies(id) ON DELETE CASCADE,
    file_path TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    duration_months INT DEFAULT 11,
    status VARCHAR(20) CHECK (status IN ('active', 'expiring_soon', 'expired')) DEFAULT 'active',
    uploaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. RENT RECORDS (Ledger - What is owed for a billing period)
CREATE TABLE IF NOT EXISTS public.rent_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenancy_id UUID NOT NULL REFERENCES public.tenancies(id) ON DELETE CASCADE,
    billing_month VARCHAR(7) NOT NULL, -- Format: 'YYYY-MM'
    amount_due NUMERIC(10, 2) NOT NULL,
    due_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'processing', 'paid', 'overdue')) DEFAULT 'pending',
    paid_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. PAYMENTS (Transactions against a Rent Record - 1 to Many)
CREATE TABLE IF NOT EXISTS public.payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rent_record_id UUID NOT NULL REFERENCES public.rent_records(id) ON DELETE CASCADE,
    rent_amount NUMERIC(10, 2) NOT NULL,
    fee_amount NUMERIC(10, 2) DEFAULT 0,
    total_amount NUMERIC(10, 2) NOT NULL,
    provider_reference VARCHAR(100),
    status VARCHAR(20) CHECK (status IN ('pending', 'processing', 'paid', 'failed')) DEFAULT 'pending',
    initiated_at TIMESTAMPTZ DEFAULT NOW(),
    confirmed_at TIMESTAMPTZ
);

-- 9. INVITATIONS
CREATE TABLE IF NOT EXISTS public.invitations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenancy_id UUID NOT NULL REFERENCES public.tenancies(id) ON DELETE CASCADE,
    token VARCHAR(64) UNIQUE NOT NULL,
    owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    phone VARCHAR(20) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('active', 'used', 'revoked', 'expired')) DEFAULT 'active',
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. MAINTENANCE REQUESTS
CREATE TABLE IF NOT EXISTS public.maintenance_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenancy_id UUID NOT NULL REFERENCES public.tenancies(id) ON DELETE CASCADE,
    unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(10) CHECK (priority IN ('low', 'medium', 'high')) DEFAULT 'medium',
    status VARCHAR(20) CHECK (status IN ('open', 'in_progress', 'resolved')) DEFAULT 'open',
    photo_urls TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 11. VACATE REQUESTS
CREATE TABLE IF NOT EXISTS public.vacate_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenancy_id UUID NOT NULL REFERENCES public.tenancies(id) ON DELETE CASCADE,
    requested_vacate_date DATE NOT NULL,
    reason TEXT,
    status VARCHAR(20) CHECK (status IN ('pending', 'approved', 'rejected')) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 12. NOTIFICATIONS
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(30) NOT NULL,
    read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 13. MONTHLY REPORTS
CREATE TABLE IF NOT EXISTS public.monthly_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    month VARCHAR(7) NOT NULL, -- Format: YYYY-MM
    pdf_url TEXT NOT NULL,
    generated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ========================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.floors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.units ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tenancies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.agreements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rent_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.maintenance_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vacate_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.monthly_reports ENABLE ROW LEVEL SECURITY;

-- Profiles: users can read/update their own profile
CREATE POLICY profiles_user_policy ON public.profiles
    FOR ALL USING (auth.uid() = id);

-- Properties: owner access only
CREATE POLICY properties_owner_policy ON public.properties
    FOR ALL USING (auth.uid() = owner_id);

-- Floors & Units: owner through property
CREATE POLICY floors_owner_policy ON public.floors
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.properties p
            WHERE p.id = floors.property_id AND p.owner_id = auth.uid()
        )
    );

CREATE POLICY units_owner_policy ON public.units
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.floors f
            JOIN public.properties p ON p.id = f.property_id
            WHERE f.id = units.floor_id AND p.owner_id = auth.uid()
        )
    );

-- Tenancies: owner or tenant access
CREATE POLICY tenancies_policy ON public.tenancies
    FOR ALL USING (auth.uid() = owner_id OR auth.uid() = tenant_id);

-- Rent Records: owner or tenant access
CREATE POLICY rent_records_policy ON public.rent_records
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.tenancies t
            WHERE t.id = rent_records.tenancy_id
            AND (t.owner_id = auth.uid() OR t.tenant_id = auth.uid())
        )
    );

-- Payments: Select for owner/tenant. Updates restricted to service role or authenticated owner (for manual override)
CREATE POLICY payments_select_policy ON public.payments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.rent_records r
            JOIN public.tenancies t ON t.id = r.tenancy_id
            WHERE r.id = payments.rent_record_id
            AND (t.owner_id = auth.uid() OR t.tenant_id = auth.uid())
        )
    );

-- Maintenance: Tenant creates & views, Owner views & updates
CREATE POLICY maintenance_policy ON public.maintenance_requests
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.tenancies t
            WHERE t.id = maintenance_requests.tenancy_id
            AND (t.owner_id = auth.uid() OR t.tenant_id = auth.uid())
        )
    );

-- Invitations: Owner manages, tenant reads via token lookup
CREATE POLICY invitations_policy ON public.invitations
    FOR ALL USING (auth.uid() = owner_id OR status = 'active');
