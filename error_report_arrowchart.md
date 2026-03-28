# アローチャートアプリ エラー調査レポート

本報告書では、アローチャートアプリ（`arrow_chart_app`）の静的解析で検出されたエラーおよび警告の詳細と、その対処方法についてまとめます。

## 1. 検出された主要なエラー

### 1.1. `Uuid` クラスが未定義（`creation_with_non_type`）
- **ファイル**: `lib/database/app_database.g.dart` (自動生成ファイル)
- **内容**: `The name 'Uuid' isn't a class`
- **原因**: 
  - `tables.dart` で `package:uuid/uuid.dart` をインポートしていますが、Driftのコードジェネレーターが `app_database.g.dart` を生成する際に、`uuid` パッケージの型を正しく認識できていない、または `app_database.dart` 側でのインポートが不足している可能性があります。
  - また、依存関係が最新の状態でない（`pub get` が未完了）場合にも発生します。

### 1.2. 依存関係の警告（`depend_on_referenced_packages`）
- **ファイル**: `lib/database/connection_native.dart`
- **内容**: `The imported package 'sqlite3' isn't a dependency of the importing package`
- **原因**: `pubspec.yaml` に `sqlite3` は記載されていますが、内部的な依存関係の解決が同期されていない可能性があります。

### 1.3. Drift Web の非推奨警告（`deprecated_member_use`）
- **ファイル**: `lib/database/connection_web.dart`
- **内容**: `package:drift/web.dart` is deprecated.
- **原因**: Drift 2.0以降、従来のWebサポート（`sql.js`ベース）は非推奨となり、Wasmベースの `package:drift/wasm.dart` への移行が推奨されています。

---

## 2. 対処方法と解消用コード

### ステップ1: 依存関係の更新（コマンド実行）
まず、プロジェクトのディレクトリで以下のコマンドを実行し、パッケージ情報を最新に更新してください。
```bash
flutter pub get
```

### ステップ2: コードの修正

#### 修正箇所A: `lib/database/tables.dart`
`Uuid` の使用方法を、直接 `clientDefault` でインスタンス化するのではなく、Driftが推奨する定数または外部関数呼び出しの形に整理します。

```dart
// lib/database/tables.dart の修正例
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../models/node_model.dart' show NodeType;
import '../models/edge_model.dart' show EdgeRelation;

// Uuid生成用のヘルパー関数（グローバル領域に置く）
String _uuidGenerate() => const Uuid().v4();

@DataClassName('DiagramData')
class Diagrams extends Table {
  // clientDefault には関数参照を渡す
  TextColumn get id => text().clientDefault(_uuidGenerate)();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ChartNodes, ChartEdges も同様に .clientDefault(_uuidGenerate) に変更
```

#### 修正箇所B: `lib/database/connection_web.dart` (Webサポートの更新)
非推奨の警告を消すために、Wasmベースの接続に切り替えます。

```dart
// lib/database/connection_web.dart の修正例
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart'; // web.dart から変更

QueryExecutor connect() {
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'arrow_chart',
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  }));
}
```

### ステップ3: 再ビルド（コード生成）
修正後、以下のコマンドを実行して `app_database.g.dart` を再生成してください。
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 3. まとめ
これらのエラーの多くは、パッケージの不整合や自動生成コードの同期ズレが原因です。
1. `flutter pub get` で依存関係を整理する。
2. `Uuid` の呼び出し方を関数参照形式（`_uuidGenerate`）にする。
3. `build_runner` を再実行する。
以上の手順で、現在出ているエラーの大部分は解消されます。
