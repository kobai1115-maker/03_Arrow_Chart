import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'goal_extraction_service.dart';
import 'supabase_service.dart';
import '../data/care_knowledge.dart';

class CarePlanProposal {
  final String needs;
  final String longTermGoal;
  final String shortTermGoal;
  final String careGuidelines;
  final String? loopAdvice;
  final bool hasLoop;

  CarePlanProposal({
    required this.needs,
    required this.longTermGoal,
    required this.shortTermGoal,
    required this.careGuidelines,
    this.loopAdvice,
    this.hasLoop = false,
  });
}

/// Gemini API を使った目標文リライトサービス
class LlmService {
  final String? apiKey;
  final SupabaseService _supabase = SupabaseService();

  LlmService({this.apiKey});

  /// APIが利用可能か
  bool get isAvailable => apiKey != null && apiKey!.isNotEmpty;

  /// 適切なアセスメント項目を統合したケアプラン提案の生成
  Future<CarePlanProposal> generateCarePlan(List<GoalCandidate> candidates, {List<String>? specialNotes}) async {
    final loopCandidate = candidates.where((c) => c.hasLoop).firstOrNull;
    final hasLoop = loopCandidate != null;

    if (!isAvailable) {
      return CarePlanProposal(
        needs: '（エラー）設定画面からGemini APIキーを設定してください',
        longTermGoal: '',
        shortTermGoal: '',
        careGuidelines: '',
        hasLoop: hasLoop,
      );
    }

    // JSON構造などからプロンプトを合成
    final candidatesText = candidates.map((c) => 
      "- ニーズ元: ${c.needs}\n"
      "- 原因/結果: ${c.longTermGoal}\n"
      "- 短期目標候補: ${c.shortTermGoal}\n"
      "${c.hasLoop ? '- 【悪循環検知】: ${c.loopTexts?.join(" → ")}\n' : ''}"
    ).join('\n');

    final specialNotesText = (specialNotes != null && specialNotes.isNotEmpty) 
        ? "【特記事項（記号を含むノード）】\n" + specialNotes.map((n) => "- $n").join('\n') + "\n"
        : "";

    final prompt = '''あなたの目標は、提供された利用者の客観的情報（テキストまたは音声認識による入力）を分析し、
根拠のある具体的なケアプランを提案することです。あなたは標準的なアセスメント方式とケアプラン作成に精通した、熟練の主任介護支援専門員（ケアマネジャー）です。

【基本タスク】
渡されたアローチャートの構造データから、第2表の要件である「ニーズ（〜したい）」「長期目標（〜できる）」「短期目標」「ケア指針」を立案してください。

【アセスメント項目の適用】
客観的事実を適切なケアマネジメント手法の「基本ケア」や「疾患別ケア」の項目に分類し、「機能低下の予防」または「自立支援」の視点で評価してケア指針に盛り込んでください。

【悪循環（ループ）へのアプローチ（必須要件）】
データ内に順接の「ループ（悪循環）」が含まれている場合、適切なケアマネジメント手法の考え方に基づき、「そのループを構成する要因群の中で、医学的・環境的に最も介入（アプローチ）が容易で、悪循環を根本から断ち切れるポイントはどこか」を分析し、専門的な助言として出力してください。そして、その介入点を「短期目標」として設定してください。

【特殊記号の解釈（必須要件）】
ノード内の言葉に以下の記号が含まれる場合、特別な意味を持ちます。これらの記号が付与されたノードが存在する場合は、その内容について「ケア指針」の項目内で必ず言及し、分析内容を含めてください。
・「！」または「!」：将来予測（例：～の危険性がある、～の可能性がある）
・「！！」または「!!」：繰り返している（例：転倒を繰り返している、入院を繰り返している）
・「？」または「?」：不明な情報、仮説の形成

【抽出された構造データ】
$candidatesText
$specialNotesText
【出力形式】
アプリ側でパースできるよう、必ず以下のJSONスキーマのみを返却してください。マークダウン装飾(```json等)は除外してください。
{
  "needs": "（〜したいというニーズ）",
  "long_term_goal": "（〜できるという長期目標）",
  "short_term_goal": "（短期目標。ループがある場合はその介入点）",
  "care_guidelines": "（基本ケアおよび疾患別ケアの評価を含むケア指針）",
  "loop_advice": "（ループに対する介入の専門的助言。ループがない場合は空文字）"
}
''';

    try {
      final responseText = await _callGemini(prompt, expectJson: true, systemInstruction: CareKnowledge.systemPromptBase);
      final cleanJson = responseText.replaceAll('```json', '').replaceAll('```', '').trim();
      final data = jsonDecode(cleanJson);
      
      final loopAdviceText = data['loop_advice']?.toString();
      final loopAdvice = (loopAdviceText != null && loopAdviceText.isNotEmpty) ? loopAdviceText : null;
      
      return CarePlanProposal(
        needs: data['needs'] ?? '取得に失敗しました',
        longTermGoal: data['long_term_goal'] ?? '取得に失敗しました',
        shortTermGoal: data['short_term_goal'] ?? '取得に失敗しました',
        careGuidelines: data['care_guidelines'] ?? '取得に失敗しました',
        loopAdvice: loopAdvice,
        hasLoop: hasLoop,
      );
    } catch (_) {
      return CarePlanProposal(
        needs: '（エラー）AIからの応答をパースできませんでした',
        longTermGoal: '（エラー）',
        shortTermGoal: '（エラー）',
        careGuidelines: '（エラー）',
        hasLoop: hasLoop,
      );
    }
  }

  /// ニーズ（主観事実）をリライト
  Future<String> rewriteNeeds(String rawText) async {
    if (!isAvailable) return rawText;

    final prompt = '''
あなたはプロのケアマネジャーとして、アローチャートから抽出された利用者の想い（主観的事実）を、ケアプランの「ニーズ」にリライトしてください。

【制約事項】
1. 利用者本人の視点に立ち、「〜したい」「〜でありたい」という肯定的な解決への意志を表現してください。
2. 他罰的・否定的な表現は避け、前向きな「なりたい姿」に変換してください。
3. 文末は必ず「〜したい」「〜でありたい」という形式にしてください。
4. 返答にはニーズの文章のみを含め、説明や装飾は一切不要です。

【例】
元のテキスト: 足が痛くて歩くのが嫌だ
ニーズ: 痛みなく安心して自分の足で歩きたい

元のテキスト: 買い物に行きたいけど一人だと怖い
ニーズ: 一人で安心して買い物に出かけられるようになりたい

元のテキスト: 孫の結婚式に行きたい
ニーズ: 体調を整えて、孫の結婚式に元気に参加したい

元のテキスト: $rawText
リライト後のニーズ:''';

    try {
      return await _callGemini(prompt, systemInstruction: CareKnowledge.systemPromptBase);
    } catch (_) {
      return rawText;
    }
  }

  /// 短期目標をリライト
  Future<String> rewriteShortTermGoal(String rawText) async {
    if (!isAvailable) return rawText;

    final prompt = '''
あなたはプロのケアマネジャーとして、原因（客観的事実）の解消を目指す「短期目標」としてリライトしてください。

【制約事項】
1. 具体的で、達成状況が測定可能な行動や状態を表現してください。
2. 介護保険のケアプランにそのまま使える、具体的かつ客観的な文体にしてください。
3. 文末は必ず「〜できる」「〜できるようになる」という形式にしてください。
4. 返答には目標文のみを含め、説明や装飾は一切不要です。

【例】
元のテキスト: 足の筋力低下
短期目標: 毎日10分間の通所リハビリに取り組み、下肢筋力を維持・向上させることができる

元のテキスト: 薬を飲み忘れる
短期目標: カレンダー付きの薬箱を利用し、朝昼晩の薬を忘れずに服用できる

元のテキスト: 外出が億劫になっている
短期目標: 週に2回、デイサービスを利用して他者との交流を楽しむことができる

元のテキスト: $rawText
リライト後の短期目標:''';

    try {
      return await _callGemini(prompt, systemInstruction: CareKnowledge.systemPromptBase);
    } catch (_) {
      return rawText;
    }
  }

  /// 長期目標をリライト
  Future<String> rewriteLongTermGoal(String rawText) async {
    if (!isAvailable) return rawText;

    final prompt = '''
あなたはプロのケアマネジャーとして、利用者の生活全体の質（QOL）が高い状態や、あるべき姿を表現する「長期目標」としてリライトしてください。

【制約事項】
1. ニーズ（想い）が達成され、問題が解決された「希望する生活」を表現してください。
2. 包括的で、かつ利用者の意欲を引き出すようなポジティブな表現にしてください。
3. 文末は必ず「〜できる」「〜できるようになる」という形式にしてください。
4. 返答には目標文のみを含め、説明や装飾は一切不要です。

【例】
元のテキスト: 歩けるようになる
長期目標: 足腰を鍛え、近所のスーパーまで自力で買い物に行くことができる

元のテキスト: 家族の負担を減らす
長期目標: 介護サービスを適切に利用しながら、住み慣れた自宅で家族と穏やかに過ごすことができる

元のテキスト: 認知機能の維持
長期目標: 生きがいを持ち、地域活動や趣味の会に意欲的に参加し続けることができる

元のテキスト: $rawText
リライト後の長期目標:''';

    try {
      return await _callGemini(prompt, systemInstruction: CareKnowledge.systemPromptBase);
    } catch (_) {
      return rawText;
    }
  }

  /// 悪循環（ループ）から最適な短期目標を推論
  Future<String> inferShortTermGoalFromLoop(List<String> loopTexts) async {
    if (!isAvailable) return loopTexts.join(' → ');

    final prompt = '''
あなたはプロのケアマネジャーです。
以下の状態は「悪循環（ループ）」に陥っています。この悪循環を断ち切るために、最も介入（支援）として現実的で実行容易なものを1つ選び、具体的な「短期目標」としてリライトしてください。

【制約事項】
1. 介護保険のケアプランにそのまま使える、具体的かつ客観的な文体にしてください。
2. 達成状況が測定可能な行動や状態を表現してください。
3. 文末は必ず「〜できる」「〜できるようになる」という形式にしてください。
4. 最も解決しやすそうな点にフォーカスしてください。
5. 返答には目標文のみを含め、説明や装飾は一切不要です。

【悪循環の構成要素】
${loopTexts.map((e) => '- $e').join('\n')}

リライト後の短期目標:''';

    try {
      return await _callGemini(prompt, systemInstruction: CareKnowledge.systemPromptBase);
    } catch (_) {
      return loopTexts.join(' → ');
    }
  }

  /// Gemini API呼び出し (google_generative_aiを使用)
  Future<String> _callGemini(String prompt, {bool expectJson = false, String? systemInstruction}) async {
    // ログイン済みかつプレミアムならEdge Functionを優先的に試行する（キーを隠蔽するため）
    final user = _supabase.currentUser;
    if (user != null) {
      try {
        final response = await _supabase.client.functions.invoke(
          'generate-care-plan',
          body: {
            'prompt': prompt,
            'systemInstruction': systemInstruction,
            'expectJson': expectJson,
          },
        );
        
        if (response.status == 200) {
          final data = response.data;
          return data['text'] ?? '';
        }
      } catch (e) {
        print('Edge Function Error, falling back to local: $e');
      }
    }

    // fallback: クライアント側のSDKを使用 (開発用または個人用キー設定時)
    if (apiKey == null || apiKey!.isEmpty) {
      throw Exception('API Key is not set');
    }

    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey!,
      systemInstruction: systemInstruction != null ? Content.system(systemInstruction) : null,
      generationConfig: GenerationConfig(
        temperature: 0.2,
        responseMimeType: expectJson ? 'application/json' : 'text/plain',
      ),
    );

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text;
    
    if (text == null) {
      throw Exception('Empty response from model');
    }
    
    return expectJson ? text : _sanitizeResponse(text);
  }

  /// レスポンスの微調整（ケアプランとしてふさわしくない表現の補正）
  String _sanitizeResponse(String text) {
    // 改行、句点、余計な装飾を削除
    var result = text.trim()
        .replaceAll('\n', '')
        .replaceAll('。', '')
        .replaceAll('「', '')
        .replaceAll('」', '')
        .replaceAll('リライト後の目標：', '')
        .replaceAll('リライト後のニーズ：', '');
    
    // 丁寧語の語尾を目標文形式に変換
    if (result.endsWith('します')) {
      result = '${result.substring(0, result.length - 3)}する';
    }
    
    // 最終的な「〜できる」チェック（目標系のみ）
    // ニーズ系（〜したい）でない場合、かつ語尾が不適切な場合は補完する
    if (!result.endsWith('したい') && !result.endsWith('でありたい')) {
      if (!result.endsWith('できる') && !result.endsWith('る')) {
          if (result.endsWith('する')) {
            result = '${result.substring(0, result.length - 2)}できる';
          } else {
            result = '$resultができる';
          }
      }
    }
    
    return result;
  }
}
