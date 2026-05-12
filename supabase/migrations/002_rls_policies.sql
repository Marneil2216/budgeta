-- Enable Row Level Security
ALTER TABLE public.user_profiles     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixed_expenses    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.variable_expenses ENABLE ROW LEVEL SECURITY;

-- user_profiles policies
CREATE POLICY "Users can view own profile"
  ON public.user_profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON public.user_profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.user_profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- fixed_expenses policies
CREATE POLICY "Users can select own fixed expenses"
  ON public.fixed_expenses FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own fixed expenses"
  ON public.fixed_expenses FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own fixed expenses"
  ON public.fixed_expenses FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own fixed expenses"
  ON public.fixed_expenses FOR DELETE
  USING (auth.uid() = user_id);

-- variable_expenses policies
CREATE POLICY "Users can select own variable expenses"
  ON public.variable_expenses FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own variable expenses"
  ON public.variable_expenses FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own variable expenses"
  ON public.variable_expenses FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own variable expenses"
  ON public.variable_expenses FOR DELETE
  USING (auth.uid() = user_id);
