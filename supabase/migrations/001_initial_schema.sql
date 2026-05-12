-- user_profiles: extends auth.users 1-to-1
CREATE TABLE public.user_profiles (
  id             UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email          TEXT NOT NULL,
  full_name      TEXT,
  monthly_salary DECIMAL(15, 2) DEFAULT NULL,
  currency       VARCHAR(3) NOT NULL DEFAULT 'PHP',
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- fixed_expenses: recurring monthly bills
CREATE TABLE public.fixed_expenses (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  name       TEXT NOT NULL,
  amount     DECIMAL(15, 2) NOT NULL CHECK (amount > 0),
  category   VARCHAR(50) NOT NULL DEFAULT 'other',
  due_day    INTEGER NOT NULL CHECK (due_day BETWEEN 1 AND 31),
  is_active  BOOLEAN NOT NULL DEFAULT TRUE,
  icon_name  VARCHAR(100) DEFAULT 'receipt',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- variable_expenses: daily/ad-hoc spending
CREATE TABLE public.variable_expenses (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  name         TEXT NOT NULL,
  amount       DECIMAL(15, 2) NOT NULL CHECK (amount > 0),
  category     VARCHAR(50) NOT NULL DEFAULT 'other',
  expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
  note         TEXT,
  icon_name    VARCHAR(100) DEFAULT 'shopping_bag',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Performance indexes
CREATE INDEX idx_fixed_expenses_user_active
  ON public.fixed_expenses(user_id, is_active);

CREATE INDEX idx_variable_expenses_user_date
  ON public.variable_expenses(user_id, expense_date);
