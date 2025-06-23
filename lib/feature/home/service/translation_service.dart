// // lib/services/translation_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';

// class TranslationService {
//   // Using LibreTranslate API - free and open source
//   static const String _baseUrl = 'https://libretranslate.com/translate';

//   // Language mapping
//   static const Map<String, String> languageMap = {
//     'English': 'en',
//     'French': 'fr',
//     'German': 'de',
//     'Spanish': 'es',
//     'Italian': 'it',
//     'Portuguese': 'pt',
//     'Russian': 'ru',
//     'Chinese': 'zh',
//     'Japanese': 'ja',
//     'Korean': 'ko',
//     'Arabic': 'ar',
//     'Hindi': 'hi',
//     'Bengali': 'bn',
//     'Turkish': 'tr',
//     'Swedish': 'sv',
//     'Norwegian': 'no',
//   };

//   static Future<String> translateText(
//       String text, String targetLanguage) async {
//     try {
//       final targetLangCode = languageMap[targetLanguage] ?? 'en';

//       // Skip if already in English or empty
//       if (targetLanguage == 'English' || text.trim().isEmpty) {
//         return text;
//       }

//       final response = await http
//           .post(
//             Uri.parse(_baseUrl),
//             headers: {'Content-Type': 'application/json'},
//             body: json.encode({
//               'q': text,
//               'source': 'auto',
//               'target': targetLangCode,
//             }),
//           )
//           .timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['translatedText'] ?? text;
//       }

//       debugPrint('Translation API failed with status: ${response.statusCode}');
//       return text; // Fallback to original text
//     } catch (e) {
//       debugPrint('Translation error: $e');
//       return text; // Fallback to original text
//     }
//   }

//   // Offline translations for common product terms (fallback)
//   static const Map<String, Map<String, String>> offlineTranslations = {
//     'Product nearby you': {
//       'French': 'Produits près de chez vous',
//       'German': 'Produkte in Ihrer Nähe',
//       'Spanish': 'Productos cerca de ti',
//       'Bengali': 'আপনার কাছাকাছি পণ্য',
//       'Chinese': '您附近的产品',
//       'Japanese': 'あなたの近くの製品',
//       'Korean': '근처 제품',
//       'Arabic': 'المنتجات القريبة منك',
//       'Hindi': 'आपके पास के उत्पाद',
//       'Turkish': 'Yakınınızdaki ürünler',
//       'Swedish': 'Produkter nära dig',
//       'Norwegian': 'Produkter i nærheten',
//     },
//     'Stylish Backpack': {
//       'French': 'Sac à dos élégant',
//       'German': 'Stylischer Rucksack',
//       'Spanish': 'Mochila elegante',
//       'Bengali': 'স্টাইলিশ ব্যাকপ্যাক',
//       'Chinese': '时尚背包',
//       'Japanese': 'スタイリッシュなバックパック',
//       'Korean': '스타일리시한 백팩',
//       'Arabic': 'حقيبة ظهر أنيقة',
//       'Hindi': 'स्टाइलिश बैकपैक',
//       'Turkish': 'Şık sırt çantası',
//     },
//     // Add more common product terms as needed
//     'Laptop': {
//       'French': 'Ordinateur portable',
//       'German': 'Laptop',
//       'Spanish': 'Portátil',
//       'Bengali': 'ল্যাপটপ',
//       'Chinese': '笔记本电脑',
//       'Japanese': 'ノートパソコン',
//       'Korean': '노트북',
//       'Arabic': 'حاسوب محمول',
//       'Hindi': 'लैपटॉप',
//       'Turkish': 'Dizüstü bilgisayar',
//     },
//     'Smartphone': {
//       'French': 'Smartphone',
//       'German': 'Smartphone',
//       'Spanish': 'Teléfono inteligente',
//       'Bengali': 'স্মার্টফোন',
//       'Chinese': '智能手机',
//       'Japanese': 'スマートフォン',
//       'Korean': '스마트폰',
//       'Arabic': 'هاتف ذكي',
//       'Hindi': 'स्मार्टफोन',
//       'Turkish': 'Akıllı telefon',
//     },
//   };
//   static String getOfflineTranslation(String text, String targetLanguage) {
//     if (targetLanguage == 'English') return text;

//     // Check direct match first
//     final directMatch = offlineTranslations[text]?[targetLanguage];
//     if (directMatch != null) return directMatch;

//     // Check for partial matches (case insensitive)
//     for (final key in offlineTranslations.keys) {
//       if (text.toLowerCase().contains(key.toLowerCase())) {
//         final translation = offlineTranslations[key]?[targetLanguage];
//         if (translation != null) return translation;
//       }
//     }

//     return text; // Return original if no translation found
//   }
// }
