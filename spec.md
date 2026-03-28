Arrow Chart & Care Plan AI App Specification
1. Project Overview
医療・介護現場でのアセスメントと思考過程を可視化する「アローチャート」を作成し、その構造から「短期目標」と「長期目標」の候補を自動抽出するマルチプラットフォーム対応（Web, iOS, Android, iPadOS）のアプリケーションを開発する。

2. Tech Stack
Framework: Flutter (Dart)

Diagram Engine: diagram_editor パッケージをベースに拡張

Architecture: MVVM または Riverpod を用いた状態管理

Local Storage: SQLite または shared_preferences (オフラインファースト設計)

3. Core UI/UX Requirements (Touch-First)
Platform Targets: モバイル、タブレットのタッチ操作を最優先に設計すること。

Touch Targets: すべてのインタラクティブ要素（ノード、ハンドル、ボタン）は最低 48x48dp のヒット領域を確保する。

Node Connection (Tap-to-Connect): ドラッグ＆ドロップによる結線はモバイルで誤操作を招くため、「ソースノードのハンドルをタップ → ターゲットノードのハンドルをタップ」の順次タップで結線できる機能を実装する。

Modality: プロパティ編集画面などはフルスクリーン遷移を避け、Bottom Sheet や Side Panel を使用してキャンバスのコンテキストを維持する。

4. Arrow Chart Logical Structure
ユーザーが配置するノードとエッジには厳密な論理的意味を持たせる。データモデルは以下を区別してJSONでシリアライズ可能にすること。

Nodes (要素)
Subjective (主観的事実):

形状: 四角形（□）

意味: ユーザーや家族の訴え、感情、希望。

Objective (客観的事実):

形状: 円形（○）

意味: 診断名、身体状況、環境などの事実。

Edges (関係性)
Cause & Effect (順接):

線種: 通常の矢印（→）

意味: 原因と結果（〜なので〜である）。

Paradox (逆説):

線種: 中心にギザギザ波形がある直線（─ギザギザ─）※FlutterのCustomPainter等で描画

意味: ギャップや相反する状態（〜だけど〜である）。

Connection (単なる接続):

線種: 直線（─）

5. Goal Extraction Algorithm (AI Suggestion Logic)
キャンバス上のグラフ構造（JSON）を解析し、以下の厳密なルールに基づいて目標候補を抽出するアルゴリズムを実装する。抽出後、必要に応じてLLM APIを用いて自然な文章に整形し、UI（Bottom Sheet等）に提示する。

短期目標の抽出:

条件: 「□（主観的事実）」ノードと「○（客観的事実）」ノードが、「逆説（ギザギザ線）」のエッジで結ばれているペア（ニーズの構造）を検索する。

抽出対象: 該当ペアの「□（主観的事実）」のテキスト内容を短期目標のベースとする。

長期目標の抽出:

条件: 上記で見つかった「○（客観的事実）」を起点とし、「→（順接の矢印）」を逆方向（結果から原因の方向へ）に再帰的に遡る。

抽出対象: グラフの最上流にある親を持たない「○（根本原因の客観的事実）」のテキスト内容を長期目標のベースとする。