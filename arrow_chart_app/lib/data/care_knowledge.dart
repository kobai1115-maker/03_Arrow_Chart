// 適切なケアマネジメント手法の知識データ
class CareKnowledge {
  static const String appropriateCareManagement = r'''
{
  "Appropriate_Care_Management_Method": {
    "Overview": "要介護高齢者本人と家族の生活の継続を支えるために、各職域で培われた知見に基づいて想定される支援を体系化し、アセスメントやモニタリングの項目を整理したもの[3, 4]。",
    "Structure_Note": "「基本ケア」は『基本方針＞大項目＞中項目＞想定される支援内容』の階層。「疾患別ケア」は『大項目＞中項目＞小項目＞想定される支援内容』の階層で構成される[5, 6]。",
    "Basic_Care": [
      {
        "Basic_Policy": "Ⅰ.尊厳を重視した意思決定の支援",
        "Major_Category": "Ⅰ-1. 現在の全体像の把握と生活上の将来予測、備え",
        "Middle_Category": "Ⅰ-1-1. 疾病や心身状態の理解",
        "Support_Items": [
          {
            "id": 1,
            "title": "疾患管理の理解の支援",
            "overview_and_necessity": "再発予防や生活の悪化防止には、生活習慣の改善が必要で、起因となっている疾患の管理についての理解が必要。継続的な受診の確保等により疾患の理解と、適切な療養や生活の改善を支援する体制を整える[7, 8]。",
            "assessment_monitoring_items": [
              "疾患に対する本人・家族等の理解度",
              "生活習慣病の管理・指導に対する本人・家族等の理解度",
              "医師及び専門職からの指導内容に対する本人・家族等の理解度",
              "服薬の必要性及び薬の管理方法に対する本人・家族等の理解度"
            ],
            "consultation_professionals": [
              "医師", "歯科医師", "看護師", "薬剤師", "PT/OT/ST", "歯科衛生士", "管理栄養士", "介護職"
            ]
          },
          {
            "id": 2,
            "title": "併存疾患の把握の支援"
          },
          {
            "id": 3,
            "title": "口腔内の異常の早期発見と歯科受診機会の確保"
          },
          {
            "id": 4,
            "title": "転倒・骨折のリスクや経緯の確認"
          }
        ]
      },
      {
        "Basic_Policy": "Ⅰ.尊厳を重視した意思決定の支援",
        "Major_Category": "Ⅰ-1. 現在の全体像の把握と生活上の将来予測、備え",
        "Middle_Category": "Ⅰ-1-2. 現在の生活の全体像の把握",
        "Support_Items": [
          { "id": 5, "title": "望む生活・暮らしの意向の把握" },
          { "id": 6, "title": "一週間の生活リズムとその変化を把握することの支援" },
          { "id": 7, "title": "食事及び栄養の状態の確認" }
        ]
      }
    ],
    "Disease_Specific_Care": {
      "Cerebrovascular_Disease": {
        "disease_name": "脳血管疾患",
        "Phase_I": {
          "phase_description": "病状が安定し、自宅での生活を送ることができるようにする時期[9, 10]",
          "Major_Category": "1. 再発予防",
          "Middle_Category": "1-1. 血圧や疾病の管理の支援",
          "Minor_Category": "1-1-2. 血圧等の体調の確認",
          "Support_Items": [
            {
              "id": 2,
              "title": "目標血圧が確認できる体制を整える",
              "assessment_monitoring_items": [
                "目標血圧を確認できる体制を整える。特にⅠ期においては、入院中と自宅での環境は異なることから、入院環境下の状況を把握することも重要である[11]。"
              ],
              "consultation_professionals": [
                "医師", "看護師", "介護職"
              ]
            },
            {
              "id": 3,
              "title": "家庭（日常）血圧・脈拍等の把握ができる体制を整える"
            }
          ]
        }
      },
      "Heart_Disease": {
        "disease_name": "心疾患",
        "Phase_I": {
          "phase_description": "退院後の期間が短く、医療との関わりが強い状況にある時期[12, 13]",
          "Major_Category": "1. 再入院の予防",
          "Middle_Category": "1-1. 疾患の理解と確実な服薬",
          "Minor_Category": "1-1-1. 基本的な疾患管理の支援",
          "Support_Items": [
            {
              "id": 1,
              "title": "疾患の理解を支援し、定期的に診察が受けられる体制を整える",
              "assessment_monitoring_items": [
                "再発予防や生活の質の低下を防ぐために、背景にある生活習慣病の管理が必要であることを、本人・家族等の介護者が理解できるよう支援する[14]。",
                "本人・家族等の介護者が日常の状態と普段とは異なる状態の両方を理解することで、病状悪化を早期に発見できるよう支援する[14]。",
                "定期的な受診が可能となるよう通院する環境や手段を整える[14]。"
              ],
              "consultation_professionals": [
                "医師", "看護師", "薬剤師", "管理栄養士", "介護職"
              ]
            }
          ]
        }
      },
      "Dementia": {
        "disease_name": "認知症",
        "Phase_Independent": {
          "phase_description": "アルツハイマー型認知症の診断があり、ADL/IADLは自立あるいは一部介助の「比較的初期～中期」を想定[15]。",
          "Major_Category": "0. ここまでの経緯の確認",
          "Middle_Category": "0-1. ここまでの経緯の確認",
          "Minor_Category": "0-1-2. これまでの医療及び他の専門職の関わりの把握",
          "Support_Items": [
            {
              "id": 2,
              "title": "支援の前提としての医療及び他の専門職の関わりの把握",
              "assessment_monitoring_items": [
                "現在に至るまでにどのような医療及び他の専門職が関わってきたかを把握する[16]。"
              ],
              "consultation_professionals": [
                "医師", "歯科医師", "看護師", "PT/OT/ST", "社会福祉士・MSW", "歯科衛生士", "介護職"
              ]
            }
          ]
        }
      },
      "Femoral_Neck_Fracture": {
        "disease_name": "大腿骨頸部骨折",
        "Phase_II": {
          "phase_description": "病状が安定して、個別性を踏まえた生活の充足に向けた設計と、セルフマネジメントへの理解の促進を図る時期[17]。",
          "Major_Category": "2. セルフマネジメントへの移行",
          "Middle_Category": "2-1. 介護給付サービスの終結に向けた理解の促進（自助・互助への移行）",
          "Minor_Category": "2-1-3. 環境整備",
          "Support_Items": [
            {
              "id": 7,
              "title": "自ら活動しやすい環境の整備（室内環境、用具等）ができる体制を整える",
              "assessment_monitoring_items": [
                "ADL/IADLの向上に向けて、自ら活動しやすい環境（室内環境、用具等）の整備ができる体制を整える[18]。"
              ],
              "consultation_professionals": [
                "医師", "看護師", "PT/OT/ST", "介護職"
              ]
            }
          ]
        }
      }
    }
  }
}
''';

  static String get systemPromptBase => '''
あなたはプロの主任介護支援専門員（ケアマネジャー）です。
以下の「適切なケアマネジメント手法」のデータに基づき、
利用者の状態に応じた専門的で適切なケアプランの提案（ニーズ、長期目標、短期目標、ケア指針）を行ってください。

【適切なケアマネジメント手法データ】
$appropriateCareManagement

必ずこの知識体系（評価の視点や想定される支援内容）を参照し、文脈に沿って、根拠のある目標設定やケア指針の立案に役立ててください。
''';
}
