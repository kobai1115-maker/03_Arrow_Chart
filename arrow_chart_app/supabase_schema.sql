-- ユーザープロファイルテーブル
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL PRIMARY KEY,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
  username TEXT,
  is_premium BOOLEAN DEFAULT FALSE,
  role TEXT DEFAULT 'user', -- 'user' or 'admin'
  
  CONSTRAINT username_length CHECK (char_length(username) >= 3)
);

-- RLS設定
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Profiles are viewable by everyone" ON public.profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

-- ダイアグラムテーブル
CREATE TABLE public.diagrams (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.diagrams ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Individuals can create diagrams" ON public.diagrams
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Individuals can view their own diagrams" ON public.diagrams
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Individuals can update their own diagrams" ON public.diagrams
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Individuals can delete their own diagrams" ON public.diagrams
  FOR DELETE USING (auth.uid() = user_id);

-- ノードテーブル
CREATE TABLE public.nodes (
  id TEXT PRIMARY KEY,
  diagram_id TEXT REFERENCES public.diagrams ON DELETE CASCADE NOT NULL,
  type TEXT NOT NULL,
  x DOUBLE PRECISION NOT NULL,
  y DOUBLE PRECISION NOT NULL,
  node_text TEXT,
  width DOUBLE PRECISION NOT NULL,
  height DOUBLE PRECISION NOT NULL,
  font_size DOUBLE PRECISION NOT NULL
);

ALTER TABLE public.nodes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Individuals can manage their own nodes" ON public.nodes
  USING (
    EXISTS (
      SELECT 1 FROM public.diagrams
      WHERE diagrams.id = nodes.diagram_id AND diagrams.user_id = auth.uid()
    )
  );

-- エッジテーブル
CREATE TABLE public.edges (
  id TEXT PRIMARY KEY,
  diagram_id TEXT REFERENCES public.diagrams ON DELETE CASCADE NOT NULL,
  source_id TEXT NOT NULL,
  target_id TEXT NOT NULL,
  relation TEXT NOT NULL
);

ALTER TABLE public.edges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Individuals can manage their own edges" ON public.edges
  USING (
    EXISTS (
      SELECT 1 FROM public.diagrams
      WHERE diagrams.id = edges.diagram_id AND diagrams.user_id = auth.uid()
    )
  );

-- 新規ユーザー作成時にプロフィールを自動生成するトリガー
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username, is_premium)
  VALUES (new.id, new.raw_user_meta_data->>'username', false);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
