-- ============================================================
-- Arrow Chart RLS修正マイグレーション
-- 作成日: 2026-05-15
-- ブランチ: feature/rls-audit
--
-- 【適用方法】
-- Supabase再開後、ダッシュボードの SQL Editor にこのファイルの内容を
-- 貼り付けて実行してください。
-- ============================================================

-- ■ ステップ0: 現在のRLS状態を確認（情報のみ・変更なし）
-- 以下のクエリでRLSが有効かどうか確認できます:
-- SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public';

-- ■ ステップ1: RLSが有効であることを保証（冪等）
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.diagrams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nodes    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.edges    ENABLE ROW LEVEL SECURITY;

-- ■ ステップ2: profiles の危険なポリシーを修正
-- 旧ポリシー削除（存在しない場合は無視される）
DROP POLICY IF EXISTS "Profiles are viewable by everyone" ON public.profiles;

-- 新ポリシー作成（本人のみ閲覧可能）
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'profiles' AND policyname = 'Users can view their own profile'
  ) THEN
    CREATE POLICY "Users can view their own profile" ON public.profiles
      FOR SELECT USING (auth.uid() = id);
  END IF;
END
$$;

-- ■ ステップ3: nodes の旧ポリシーを削除して個別ポリシーに分割
DROP POLICY IF EXISTS "Individuals can manage their own nodes" ON public.nodes;

DO $$
BEGIN
  -- SELECT
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'nodes' AND policyname = 'Individuals can view their own nodes'
  ) THEN
    CREATE POLICY "Individuals can view their own nodes" ON public.nodes
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM public.diagrams
          WHERE diagrams.id = nodes.diagram_id AND diagrams.user_id = auth.uid()
        )
      );
  END IF;

  -- INSERT (WITH CHECK)
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'nodes' AND policyname = 'Individuals can insert their own nodes'
  ) THEN
    CREATE POLICY "Individuals can insert their own nodes" ON public.nodes
      FOR INSERT WITH CHECK (
        EXISTS (
          SELECT 1 FROM public.diagrams
          WHERE diagrams.id = nodes.diagram_id AND diagrams.user_id = auth.uid()
        )
      );
  END IF;

  -- UPDATE
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'nodes' AND policyname = 'Individuals can update their own nodes'
  ) THEN
    CREATE POLICY "Individuals can update their own nodes" ON public.nodes
      FOR UPDATE USING (
        EXISTS (
          SELECT 1 FROM public.diagrams
          WHERE diagrams.id = nodes.diagram_id AND diagrams.user_id = auth.uid()
        )
      );
  END IF;

  -- DELETE
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'nodes' AND policyname = 'Individuals can delete their own nodes'
  ) THEN
    CREATE POLICY "Individuals can delete their own nodes" ON public.nodes
      FOR DELETE USING (
        EXISTS (
          SELECT 1 FROM public.diagrams
          WHERE diagrams.id = nodes.diagram_id AND diagrams.user_id = auth.uid()
        )
      );
  END IF;
END
$$;

-- ■ ステップ4: edges の旧ポリシーを削除して個別ポリシーに分割
DROP POLICY IF EXISTS "Individuals can manage their own edges" ON public.edges;

DO $$
BEGIN
  -- SELECT
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'edges' AND policyname = 'Individuals can view their own edges'
  ) THEN
    CREATE POLICY "Individuals can view their own edges" ON public.edges
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM public.diagrams
          WHERE diagrams.id = edges.diagram_id AND diagrams.user_id = auth.uid()
        )
      );
  END IF;

  -- INSERT (WITH CHECK)
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'edges' AND policyname = 'Individuals can insert their own edges'
  ) THEN
    CREATE POLICY "Individuals can insert their own edges" ON public.edges
      FOR INSERT WITH CHECK (
        EXISTS (
          SELECT 1 FROM public.diagrams
          WHERE diagrams.id = edges.diagram_id AND diagrams.user_id = auth.uid()
        )
      );
  END IF;

  -- UPDATE
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'edges' AND policyname = 'Individuals can update their own edges'
  ) THEN
    CREATE POLICY "Individuals can update their own edges" ON public.edges
      FOR UPDATE USING (
        EXISTS (
          SELECT 1 FROM public.diagrams
          WHERE diagrams.id = edges.diagram_id AND diagrams.user_id = auth.uid()
        )
      );
  END IF;

  -- DELETE
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'edges' AND policyname = 'Individuals can delete their own edges'
  ) THEN
    CREATE POLICY "Individuals can delete their own edges" ON public.edges
      FOR DELETE USING (
        EXISTS (
          SELECT 1 FROM public.diagrams
          WHERE diagrams.id = edges.diagram_id AND diagrams.user_id = auth.uid()
        )
      );
  END IF;
END
$$;

-- ■ ステップ5: GRANTの追加（Supabase Data API用）
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;

-- ■ 完了確認クエリ（実行後に確認用として利用）
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
-- FROM pg_policies WHERE schemaname = 'public' ORDER BY tablename, cmd;
