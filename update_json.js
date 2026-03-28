const fs = require('fs');
const jsonPath = 'C:\\\\Users\\\\小林洋貴(東包括)\\\\OneDrive - 社会福祉法人萌佑会\\\\デスクトップ\\\\Antigravity\\\\01_Nursing_Welfare\\\\03_Arrow_Chart\\\\インターライ方式.json';
const dartPath = 'C:\\\\Users\\\\小林洋貴(東包括)\\\\OneDrive - 社会福祉法人萌佑会\\\\デスクトップ\\\\Antigravity\\\\01_Nursing_Welfare\\\\03_Arrow_Chart\\\\arrow_chart_app\\\\lib\\\\data\\\\care_knowledge.dart';

const jsonContent = fs.readFileSync(jsonPath, 'utf8');
let dartContent = fs.readFileSync(dartPath, 'utf8');

dartContent = dartContent.replace('// インターライ方式と適切なケアマネジメント手法の知識データ', '// アセスメント方式と適切なケアマネジメント手法の知識データ');
dartContent = dartContent.replace(/static const String interRaiCaps = r'''[\s\S]*?''';/, `static const String interRaiCaps = r'''\n${jsonContent}''';`);
dartContent = dartContent.replace('以下の「インターライ方式（interRAI CAPs）」と「適切なケアマネジメント手法」のデータに基づき、', '以下の「標準的なアセスメント項目」と「適切なケアマネジメント手法」のデータに基づき、');
dartContent = dartContent.replace('【インターライ方式（CAPs）データ】', '【アセスメント項目データ】');

fs.writeFileSync(dartPath, dartContent, 'utf8');
console.log('Done');
