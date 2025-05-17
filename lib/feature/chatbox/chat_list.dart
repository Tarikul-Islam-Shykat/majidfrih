// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_bar.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/const/sizer.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/chatbox/chat_message.dart';
import 'package:prettyrini/feature/chatbox/chatlist_controller/chat_controller.dart';
import 'package:prettyrini/feature/chatbox/chatlist_model/chat_model.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());

    return Obx(() {
      final bool isDarkMode = themeController.isDarkMode;
      final Color iconTextColor = isDarkMode ? Colors.white : Colors.black;
      final Color bgColor = isDarkMode ? Colors.black : Colors.white;

      return Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                isDarkMode
                    ? ImagePath.subscriptionLogo
                    : ImagePath.subscriptionLogol,
                fit: BoxFit.fill,
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppBar("Jenny", textColor: iconTextColor),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: chatController.chatList.length,
                        itemBuilder: (context, index) {
                          final chat = chatController.chatList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  ChatDetailScreen(contactName: chat.name));
                            },
                            child: _buildChatItem(context, chat),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildChatItem(BuildContext context, ChatModel chat) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthPercent(context, 5),
        vertical: SizeConfig.heightPercent(context, 1.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: SizeConfig.heightPercent(context, 2.5),
            backgroundImage: AssetImage(chat.profileImage),
          ),
          SizedBox(width: SizeConfig.widthPercent(context, 2.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.name,
                  style: TextStyle(
                    color: themeController.isDarkMode
                        ? Colors.white.withOpacity(0.85)
                        : Color(0xFF171717),
                    fontSize: SizeConfig.heightPercent(context, 1.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.heightPercent(context, 0.5)),
                Text(
                  chat.messagePreview,
                  style: TextStyle(
                    color: themeController.isDarkMode
                        ? Colors.white.withOpacity(0.6)
                        : Color(0xFF171717).withOpacity(0.25),
                    fontSize: SizeConfig.heightPercent(context, 1.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat.dateandtime,
                style: TextStyle(
                  color: themeController.isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : Color(0xFF171717).withOpacity(0.25),
                  fontSize: SizeConfig.heightPercent(context, 1.6),
                ),
              ),
              Text(
                chat.timestamp,
                style: TextStyle(
                  color: themeController.isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : Color(0xFF171717).withOpacity(0.25),
                  fontSize: SizeConfig.heightPercent(context, 1.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // void _showSubscriptionPopup(BuildContext context) {
  //   bool isChecked = false;

  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           final bool isDarkMode = themeController.isDarkMode;
  //           return Dialog(
  //             backgroundColor: isDarkMode ? Colors.black : Colors.white,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: Container(
  //               padding: EdgeInsets.all(SizeConfig.widthPercent(context, 5)),
  //               width: 328,
  //               height: 388,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Center(
  //                     child: Text(
  //                       textAlign: TextAlign.center,
  //                       'Subscription Plans',
  //                       style: TextStyle(
  //                         color: isDarkMode ? Colors.white : Colors.black,
  //                         fontSize: SizeConfig.heightPercent(context, 3),
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: SizeConfig.heightPercent(context, 2)),
  //                   Text(
  //                     textAlign: TextAlign.center,
  //                     'Access premium features to showcase your work, connect, and grow faster.',
  //                     style: TextStyle(
  //                       color: (isDarkMode ? Colors.white : Colors.black)
  //                           .withOpacity(0.80),
  //                       fontSize: SizeConfig.heightPercent(context, 1.5),
  //                     ),
  //                   ),
  //                   SizedBox(height: SizeConfig.heightPercent(context, 3)),
  //                   Container(
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: SizeConfig.widthPercent(context, 4),
  //                       vertical: SizeConfig.heightPercent(context, 2),
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: isDarkMode ? Colors.black : Colors.white,
  //                       borderRadius: BorderRadius.circular(15),
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               isChecked = !isChecked;
  //                             });
  //                           },
  //                           child: Container(
  //                             width: SizeConfig.heightPercent(context, 3),
  //                             height: SizeConfig.heightPercent(context, 3),
  //                             decoration: BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               border: Border.all(
  //                                 color:
  //                                     isDarkMode ? Colors.black : Colors.white,
  //                                 width: 2,
  //                               ),
  //                               color: isChecked
  //                                   ? (isDarkMode ? Colors.white : Colors.black)
  //                                   : Colors.transparent,
  //                             ),
  //                             child: isChecked
  //                                 ? Icon(
  //                                     Icons.check,
  //                                     size:
  //                                         SizeConfig.heightPercent(context, 2),
  //                                     color: isDarkMode
  //                                         ? Colors.black
  //                                         : Colors.white,
  //                                   )
  //                                 : null,
  //                           ),
  //                         ),
  //                         SizedBox(width: SizeConfig.widthPercent(context, 3)),
  //                         Text(
  //                           '\$9.99 / Per Month',
  //                           style: TextStyle(
  //                             color: (isDarkMode ? Colors.white : Colors.black)
  //                                 .withOpacity(0.7),
  //                             fontSize: SizeConfig.heightPercent(context, 2.2),
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(height: SizeConfig.heightPercent(context, 3)),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Get.back();
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor:
  //                           isDarkMode ? Colors.black : Colors.white,
  //                       foregroundColor:
  //                           isDarkMode ? Colors.white : Colors.black,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       minimumSize: Size(
  //                         SizeConfig.widthPercent(context, 70),
  //                         SizeConfig.heightPercent(context, 6),
  //                       ),
  //                     ),
  //                     child: Text(
  //                       'Continue',
  //                       style: TextStyle(
  //                         fontSize: SizeConfig.heightPercent(context, 2),
  //                         fontWeight: FontWeight.bold,
  //                         color: isDarkMode ? Colors.white : Colors.black,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
