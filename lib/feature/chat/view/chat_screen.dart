// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/style/global_text_style.dart';
import 'package:prettyrini/feature/chat/controller/chats_controller.dart';

class ChatScreen extends StatelessWidget {
  final String receiverId;
  final String name;
  final String? imageUrl;
  final TextEditingController _messageController = TextEditingController();

  final ChatController _chatController = Get.put(ChatController());

  ChatScreen({
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
          SizedBox(
            height: 60,
          ),
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
                      backgroundImage: AssetImage(ImagePath.profileImage),
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
                              ImagePath.profileImage,
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
