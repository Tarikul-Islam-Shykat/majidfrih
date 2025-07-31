import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/sizer.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';
import 'package:prettyrini/feature/chat_v2/view/chat_screen.dart';

class UsersChatList extends StatefulWidget {
  const UsersChatList({super.key});
  @override
  State<UsersChatList> createState() => _UserChatListScreenState();
}

class _UserChatListScreenState extends State<UsersChatList> {
  final ChatController _chatController = Get.put(ChatController());

  var name = "";
  var role = "";
  var imaegPath = "";
  var rating = "";

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
    });
  }

  Future<void> loadData() async {
    await setData();
  }

  setData() async {}

  String formatTo12Hour(String isoString) {
    DateTime dateTime =
        DateTime.parse(isoString).toLocal(); // Convert to local time
    return DateFormat('hh:mm a').format(dateTime); // Format as 12-hour time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.containerDark,
      body: RefreshIndicator(
        onRefresh: () => _chatController.refreshUserList(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Obx(() {
                    if (_chatController.isLoadingUserList.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (_chatController.usersWithLastMessages.isEmpty) {
                      return Center(
                        child: Text(
                          "No messages found.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    final sortedList =
                        _chatController.usersWithLastMessages.toList()
                          ..sort((a, b) {
                            final aTime = DateTime.parse(
                              a['lastMessage']['createdAt'],
                            );
                            final bTime = DateTime.parse(
                              b['lastMessage']['createdAt'],
                            );
                            return bTime.compareTo(aTime); // latest first
                          });

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: sortedList.length,
                      itemBuilder: (context, index) {
                        final user = sortedList[index];
                        // return ListView.builder(
                        //   padding: EdgeInsets.zero,
                        //   physics: const AlwaysScrollableScrollPhysics(),
                        //   itemCount: _chatController.usersWithLastMessages.length,
                        //   itemBuilder: (context, index) {
                        //     final user = _chatController.usersWithLastMessages[index];
                        final userName =
                            user['user']['fullName'] ?? "Unknown User";
                        final lastMessage =
                            user['lastMessage']['message'] ?? "No message";
                        final lastMessageTime =
                            user['lastMessage']['createdAt'] ?? "";
                        final profilImage = user['user']['profileImage'] ?? "";

                        return ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: profilImage.isNotEmpty
                                    ? NetworkImage(profilImage)
                                    : const AssetImage(
                                        "assets/images/no_image.png",
                                      ) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                          subtitle: Text(
                            lastMessage,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                            ),
                          ),
                          //    trailing: Text(lastMessageTime.split("T").first),
                          trailing: Text(
                            textAlign: TextAlign.end,
                            "${lastMessageTime.split("T")[0]}\n${formatTo12Hour(lastMessageTime)}",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Get.to(
                              () => ChatScreenV2(
                                name: userName,
                                receiverId: user['user']['id'],
                                imageUrl: user['user']['profileImage'] ?? "",
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.containerDark),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chatting',
                style: GoogleFonts.poppins(
                  fontSize: SizeConfig.heightPercent(context, 3),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(thickness: 2, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
