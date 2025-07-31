// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/style/global_text_style.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';

// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/style/global_text_style.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';

// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/style/global_text_style.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';
import 'package:translator/translator.dart';

// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/style/global_text_style.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';
import 'package:translator/translator.dart';

class ChatScreenV2 extends StatefulWidget {
  final String receiverId;
  final String name;
  final String? imageUrl;

  const ChatScreenV2({
    super.key,
    required this.receiverId,
    required this.name,
    this.imageUrl,
  });

  @override
  State<ChatScreenV2> createState() => _ChatScreenV2State();
}

class _ChatScreenV2State extends State<ChatScreenV2> {
  final TextEditingController _messageController = TextEditingController();
  final ChatController _chatController = Get.put(ChatController());

  // Translation variables
  final GoogleTranslator _translator = GoogleTranslator();
  String _selectedLanguageCode = 'en';
  String _selectedLanguageName = 'English';
  bool _isTranslationEnabled = false;
  Map<String, String> _translatedMessages = {};
  Set<String> _translatingMessages = {};

  // Available languages with their codes
  final Map<String, String> _languages = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Russian': 'ru',
    'Chinese (Simplified)': 'zh-cn',
    'Chinese (Traditional)': 'zh-tw',
    'Japanese': 'ja',
    'Korean': 'ko',
    'Arabic': 'ar',
    'Hindi': 'hi',
    'Bengali': 'bn',
    'Urdu': 'ur',
    'Turkish': 'tr',
    'Dutch': 'nl',
    'Polish': 'pl',
    'Swedish': 'sv',
    'Norwegian': 'no',
    'Danish': 'da',
    'Finnish': 'fi',
    'Greek': 'el',
    'Hebrew': 'he',
    'Thai': 'th',
    'Vietnamese': 'vi',
    'Indonesian': 'id',
    'Malay': 'ms',
    'Filipino': 'tl',
    'Czech': 'cs',
    'Hungarian': 'hu',
    'Romanian': 'ro',
    'Bulgarian': 'bg',
    'Croatian': 'hr',
    'Slovak': 'sk',
    'Slovenian': 'sl',
    'Estonian': 'et',
    'Latvian': 'lv',
    'Lithuanian': 'lt',
    'Ukrainian': 'uk',
  };

  @override
  void initState() {
    super.initState();
    log('ChatScreenV2: Initializing translation system');
    log('ChatScreenV2: Initial language - $_selectedLanguageName ($_selectedLanguageCode)');
    log('ChatScreenV2: Translation enabled - $_isTranslationEnabled');
  }

  Future<String> _translateMessage(String message, String messageId) async {
    log('ChatScreenV2: _translateMessage called');
    log('ChatScreenV2: Message to translate: "$message"');
    log('ChatScreenV2: Message ID: $messageId');
    log('ChatScreenV2: Translation enabled: $_isTranslationEnabled');
    log('ChatScreenV2: Selected language: $_selectedLanguageName ($_selectedLanguageCode)');

    if (!_isTranslationEnabled) {
      log('ChatScreenV2: Translation disabled, returning original message');
      return message;
    }

    if (_selectedLanguageCode == 'en') {
      log('ChatScreenV2: Target language is English, returning original message');
      return message;
    }

    if (message.trim().isEmpty) {
      log('ChatScreenV2: Message is empty, returning original message');
      return message;
    }

    // Check if already translated
    final cacheKey = '${messageId}_${_selectedLanguageCode}';
    if (_translatedMessages.containsKey(cacheKey)) {
      log('ChatScreenV2: Found cached translation for $cacheKey');
      return _translatedMessages[cacheKey]!;
    }

    // Check if currently translating
    if (_translatingMessages.contains(cacheKey)) {
      log('ChatScreenV2: Already translating $cacheKey, returning original');
      return message;
    }

    try {
      log('ChatScreenV2: Starting translation for $cacheKey');
      _translatingMessages.add(cacheKey);

      final translation = await _translator.translate(
        message,
        from: 'auto', // Auto-detect source language
        to: _selectedLanguageCode,
      );

      final translatedText = translation.text;
      log('ChatScreenV2: Translation successful');
      log('ChatScreenV2: Original: "$message"');
      log('ChatScreenV2: Translated: "$translatedText"');

      _translatedMessages[cacheKey] = translatedText;

      // Trigger rebuild to show translated text
      if (mounted) {
        log('ChatScreenV2: Triggering setState to update UI');
        setState(() {});
      }

      return translatedText;
    } catch (e) {
      log('ChatScreenV2: Translation error: $e');
      return message; // Return original message if translation fails
    } finally {
      _translatingMessages.remove(cacheKey);
      log('ChatScreenV2: Removed $cacheKey from translating set');
    }
  }

  // Method to translate outgoing messages
  Future<String> _translateOutgoingMessage(String message) async {
    log('ChatScreenV2: _translateOutgoingMessage called');
    log('ChatScreenV2: Outgoing message: "$message"');

    if (!_isTranslationEnabled ||
        _selectedLanguageCode == 'en' ||
        message.trim().isEmpty) {
      log('ChatScreenV2: No translation needed for outgoing message');
      return message;
    }

    try {
      log('ChatScreenV2: Translating outgoing message from $_selectedLanguageCode to English');

      final translation = await _translator.translate(
        message,
        from: _selectedLanguageCode,
        to: 'en', // Translate to English for sending
      );

      final translatedText = translation.text;
      log('ChatScreenV2: Outgoing translation successful');
      log('ChatScreenV2: Original: "$message"');
      log('ChatScreenV2: Translated to English: "$translatedText"');

      return translatedText;
    } catch (e) {
      log('ChatScreenV2: Outgoing translation error: $e');
      return message; // Return original message if translation fails
    }
  }

  void _showLanguageSelectionDialog() {
    log('ChatScreenV2: Showing language selection dialog');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.containerDark,
          title: Text(
            'Select Translation Language',
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final languageName = _languages.keys.elementAt(index);
                final languageCode = _languages[languageName]!;

                return ListTile(
                  title: Text(
                    languageName,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: _selectedLanguageCode == languageCode
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    log('ChatScreenV2: Language selected - $languageName ($languageCode)');
                    setState(() {
                      _selectedLanguageCode = languageCode;
                      _selectedLanguageName = languageName;
                      _translatedMessages
                          .clear(); // Clear cache for new language

                      // Auto-enable translation when a non-English language is selected
                      if (languageCode != 'en') {
                        _isTranslationEnabled = true;
                      }
                    });
                    Navigator.of(context).pop();
                    // log('ChatScreenV2: Language selected - $languageName ($languageCode)');
                    // setState(() {
                    //   _selectedLanguageCode = languageCode;
                    //   _selectedLanguageName = languageName;
                    //   _translatedMessages
                    //       .clear(); // Clear cache for new language
                    // });
                    // Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Language changed to $languageName'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    log('ChatScreenV2: Language change completed, cache cleared');
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _chatController.fetchChats(widget.receiverId);

    return Scaffold(
      backgroundColor: AppColors.containerDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(widget.name, widget.imageUrl!, context),
            Expanded(
              child: Obx(() {
                if (_chatController.isLoadingChats.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
                if (_chatController.chats.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages found.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }

                log('ChatScreenV2: Building chat list with ${_chatController.chats.length} messages');

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  itemCount: _chatController.chats.length,
                  itemBuilder: (context, index) {
                    final chat = _chatController.chats[index];
                    final isMine = chat['senderId'] != widget.receiverId;
                    final messageId =
                        chat['id']?.toString() ?? index.toString();
                    final originalMessage = chat['message'] ?? '';

                    log('ChatScreenV2: Building message $index - ID: $messageId, isMine: $isMine');

                    return Align(
                      alignment:
                          isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        decoration: BoxDecoration(
                          color: isMine
                              ? Colors.blue.shade600
                              : Colors.grey.shade700,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(isMine ? 12 : 4),
                            bottomRight: Radius.circular(isMine ? 4 : 12),
                          ),
                        ),
                        child: FutureBuilder<String>(
                          future: _translateMessage(originalMessage, messageId),
                          builder: (context, snapshot) {
                            final cacheKey =
                                '${messageId}_${_selectedLanguageCode}';
                            final isTranslating =
                                _translatingMessages.contains(cacheKey);
                            final displayText = snapshot.hasData
                                ? snapshot.data!
                                : originalMessage;
                            final isTranslated = _isTranslationEnabled &&
                                snapshot.hasData &&
                                snapshot.data != originalMessage &&
                                _selectedLanguageCode != 'en';

                            log('ChatScreenV2: Message $messageId - isTranslating: $isTranslating, isTranslated: $isTranslated');

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Main message text
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        displayText,
                                        style: globalTextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    if (isTranslating)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white70),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),

                                // Original message (if translated)
                                if (isTranslated)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Original: $originalMessage',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10.sp,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ),

                                // Timestamp
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _formatTime(chat['createdAt'] ?? ''),
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Container(
              decoration: BoxDecoration(color: AppColors.containerDark),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                  top: 20,
                  right: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: _messageController,
                        decoration: InputDecoration(
                          fillColor:
                              AppColors.primaryColor.withValues(alpha: 0.1),
                          filled: true,
                          hintText: _isTranslationEnabled &&
                                  _selectedLanguageCode != 'en'
                              ? "Type in $_selectedLanguageName..."
                              : "Type a message...",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.grey.shade600,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade600,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () async {
                          final message = _messageController.text.trim();
                          if (message.isNotEmpty) {
                            log('ChatScreenV2: Sending message: "$message"');

                            // Translate the outgoing message if needed
                            String messageToSend = message;
                            if (_isTranslationEnabled &&
                                _selectedLanguageCode != 'en') {
                              log('ChatScreenV2: Translating outgoing message');
                              messageToSend =
                                  await _translateOutgoingMessage(message);
                              log('ChatScreenV2: Message to send: "$messageToSend"');
                            }

                            _chatController.sendMessage(
                                widget.receiverId, messageToSend);
                            _messageController.clear();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String timestamp) {
    if (timestamp.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildTopBar(String name, String imagePath, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.containerDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _chatController.fetchUserList();
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              imagePath.isEmpty
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(ImagePath.gellary),
                    )
                  : ClipOval(
                      child: Image.network(
                        imagePath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(ImagePath.gellary),
                          );
                        },
                      ),
                    ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    if (_isTranslationEnabled && _selectedLanguageCode != 'en')
                      Text(
                        'Translating to $_selectedLanguageName',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.sp,
                        ),
                      ),
                  ],
                ),
              ),
              // Translation toggle button
              GestureDetector(
                onTap: () {
                  log('ChatScreenV2: Translation toggle tapped');
                  log('ChatScreenV2: Current state - enabled: $_isTranslationEnabled');

                  setState(() {
                    _isTranslationEnabled = !_isTranslationEnabled;
                  });

                  log('ChatScreenV2: New state - enabled: $_isTranslationEnabled');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isTranslationEnabled
                          ? 'Translation enabled for $_selectedLanguageName'
                          : 'Translation disabled'),
                      backgroundColor:
                          _isTranslationEnabled ? Colors.green : Colors.orange,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _isTranslationEnabled
                        ? Colors.green
                        : Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.translate,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              // Language selection button
              GestureDetector(
                onTap: _showLanguageSelectionDialog,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

/*
class ChatScreenV2 extends StatefulWidget {
  final String receiverId;
  final String name;
  final String? imageUrl;

  const ChatScreenV2({
    super.key,
    required this.receiverId,
    required this.name,
    this.imageUrl,
  });

  @override
  State<ChatScreenV2> createState() => _ChatScreenV2State();
}

class _ChatScreenV2State extends State<ChatScreenV2> {
  final TextEditingController _messageController = TextEditingController();
  final ChatController _chatController = Get.put(ChatController());

  // Translation variables
  OnDeviceTranslator? _translator;
  TranslateLanguage _selectedLanguage = TranslateLanguage.english;
  bool _isTranslationEnabled = false;
  bool _isDownloadingModel = false;
  Map<String, String> _translatedMessages = {};

  // Available languages
  final Map<String, TranslateLanguage> _languages = {
    'English': TranslateLanguage.english,
    'Spanish': TranslateLanguage.spanish,
    'French': TranslateLanguage.french,
    'German': TranslateLanguage.german,
    'Italian': TranslateLanguage.italian,
    'Portuguese': TranslateLanguage.portuguese,
    'Russian': TranslateLanguage.russian,
    'Chinese': TranslateLanguage.chinese,
    'Japanese': TranslateLanguage.japanese,
    'Korean': TranslateLanguage.korean,
    'Arabic': TranslateLanguage.arabic,
    'Hindi': TranslateLanguage.hindi,
    'Bengali': TranslateLanguage.bengali,
    'Urdu': TranslateLanguage.urdu,
    'Turkish': TranslateLanguage.turkish,
    'Dutch': TranslateLanguage.dutch,
    'Polish': TranslateLanguage.polish,
    'Swedish': TranslateLanguage.swedish,
    'Norwegian': TranslateLanguage.norwegian,
    'Danish': TranslateLanguage.danish,
    'Finnish': TranslateLanguage.finnish,
  };

  @override
  void initState() {
    super.initState();
    _initializeTranslation();
  }

  void _initializeTranslation() {
    _translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: _selectedLanguage,
    );
  }

  Future<void> _downloadLanguageModel(TranslateLanguage language) async {
    setState(() {
      _isDownloadingModel = true;
    });

    try {
      final modelManager = OnDeviceTranslatorModelManager();
      await modelManager.downloadModel(language.bcpCode);

      // Update translator with new language
      await _translator?.close();
      _translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: language,
      );

      _selectedLanguage = language;
      _translatedMessages.clear(); // Clear cache for new language

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language model downloaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      log('Failed to download language model: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download language model: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isDownloadingModel = false;
      });
    }
  }

  Future<String> _translateMessage(String message, String messageId) async {
    if (!_isTranslationEnabled || _translator == null) {
      return message;
    }

    // Check if already translated
    if (_translatedMessages.containsKey(messageId)) {
      return _translatedMessages[messageId]!;
    }

    try {
      final translatedText = await _translator!.translateText(message);
      _translatedMessages[messageId] = translatedText;
      return translatedText;
    } catch (e) {
      print('Translation error: $e');
      return message; // Return original message if translation fails
    }
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Select Translation Language',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final languageName = _languages.keys.elementAt(index);
                final language = _languages[languageName]!;

                return ListTile(
                  title: Text(
                    languageName,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: _selectedLanguage == language
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () async {
                    Navigator.of(context).pop();
                    if (_selectedLanguage != language) {
                      await _downloadLanguageModel(language);
                    }
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _chatController.fetchChats(widget.receiverId);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(widget.name, widget.imageUrl!, context),
            Expanded(
              child: Obx(() {
                if (_chatController.isLoadingChats.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (_chatController.chats.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages found.",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: _chatController.chats.length,
                  itemBuilder: (context, index) {
                    final chat = _chatController.chats[index];
                    final isMine = chat['senderId'] != widget.receiverId;
                    final messageId =
                        chat['id']?.toString() ?? index.toString();

                    return Align(
                      alignment:
                          isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMine ? Colors.grey : Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FutureBuilder<String>(
                          future: _translateMessage(
                              chat['message'] ?? '', messageId),
                          builder: (context, snapshot) {
                            final displayText =
                                snapshot.data ?? chat['message'] ?? '';

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayText,
                                  style: globalTextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (_isTranslationEnabled &&
                                    snapshot.hasData &&
                                    snapshot.data != chat['message'])
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Original: ${chat['message']}',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10.sp,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade800),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                  top: 20,
                  right: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: _messageController,
                        decoration: InputDecoration(
                          fillColor:
                              AppColors.primaryColor.withValues(alpha: 0.1),
                          filled: true,
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: IconButton(
                          icon: Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            final message = _messageController.text.trim();
                            if (message.isNotEmpty) {
                              _chatController.sendMessage(
                                  widget.receiverId, message);
                              _messageController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(String name, String imagePath, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _chatController.fetchUserList();
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              imagePath == null
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(ImagePath.gellary),
                    )
                  : ClipOval(
                      child: Image.network(
                        imagePath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(ImagePath.gellary),
                          );
                        },
                      ),
                    ),
              SizedBox(width: 10),
              Text(
                name,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Spacer(),
              // Translation toggle button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isTranslationEnabled = !_isTranslationEnabled;
                  });
                  if (_isTranslationEnabled) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Translation enabled'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _isTranslationEnabled
                        ? Colors.green
                        : Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.translate,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              // Language selection button
              GestureDetector(
                onTap: _showLanguageSelectionDialog,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isDownloadingModel
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _translator?.close();
    super.dispose();
  }
}

*/
/*
class ChatScreenV2 extends StatelessWidget {
  final String receiverId;
  final String name;
  final String? imageUrl;
  final TextEditingController _messageController = TextEditingController();

  final ChatController _chatController = Get.put(ChatController());

  ChatScreenV2({
    super.key,
    required this.receiverId,
    required this.name,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    _chatController.fetchChats(receiverId);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          _buildTopBar(name, imageUrl!, context),
          Expanded(
            child: Obx(() {
              if (_chatController.isLoadingChats.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (_chatController.chats.isEmpty) {
                return const Center(child: Text("No messages found."));
              }
              return ListView.builder(
                itemCount: _chatController.chats.length,
                itemBuilder: (context, index) {
                  final chat = _chatController.chats[index];
                  final isMine = chat['senderId'] != receiverId;
                  return Align(
                    alignment:
                        isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMine ? Colors.grey : Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        chat['message'] ?? '',
                        style: globalTextStyle(
                          color: isMine
                              ? AppColors.whiteColor
                              : AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade800),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
                top: 20,
                right: 10,
                left: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _messageController,
                      decoration: InputDecoration(
                        fillColor: AppColors.primaryColor.withValues(
                          alpha: 0.1,
                        ),
                        filled: true,
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          final message = _messageController.text.trim();
                          if (message.isNotEmpty) {
                            _chatController.sendMessage(receiverId, message);
                            _messageController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(String name, String imaegPath, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _chatController.fetchUserList();
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              imaegPath == null
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(ImagePath.gellary),
                    )
                  : ClipOval(
                      child: Image.network(
                        imaegPath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              ImagePath.gellary,
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(width: 10),
              Text(
                name,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

*/
