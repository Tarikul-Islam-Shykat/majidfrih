import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/feature/chat/service/chat_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  final WebSocketService _socketService = WebSocketService();

  var usersWithLastMessages = [].obs;
  var chats = [].obs;

  // Loading states
  var isLoadingChats = true.obs;
  var isLoadingUserList = false.obs;
  var isRefreshingUserList = false.obs;
  var isSendingMessage = false.obs;

  void connectSocket(String url, String token) {
    _socketService.connect(url, token);
    _socketService.messages.listen((message) {
      _handleMessage(message);
    });
    fetchUserList();
  }

  void _handleMessage(dynamic message) {
    if (kDebugMode) {
      print("Received WebSocket message: $message");
    }

    final data = jsonDecode(message);

    switch (data['event']) {
      case "messageList":
        usersWithLastMessages.value = data['data'];
        // Stop loading states for user list operations
        isLoadingUserList.value = false;
        isRefreshingUserList.value = false;
        break;
      case "fetchChats":
        chats.value = data['data'];
        isLoadingChats.value = false;
        break;
      case "message":
        chats.add(data['data']);
        chats.refresh();
        // Stop sending message loading state
        isSendingMessage.value = false;
        break;
      default:
        if (kDebugMode) {
          print("Unknown event type: ${data['event']}");
        }
    }
  }

  void fetchUserList() {
    isLoadingUserList.value = true;
    _socketService.sendMessage("messageList", {});
  }

  Future<void> refreshUserList() async {
    isRefreshingUserList.value = true;
    usersWithLastMessages.clear();
    fetchUserList();
  }

  void fetchChats(String receiverId) {
    isLoadingChats.value = true;
    _socketService.sendMessage("fetchChats", {"receiverId": receiverId});
  }

  void sendMessage(String receiverId, String message, {List<String>? images}) {
    isSendingMessage.value = true;
    final payload = {
      "receiverId": receiverId,
      "message": message,
      "images": images ?? [],
    };
    _socketService.sendMessage("message", payload);
  }

  @override
  void onClose() {
    _socketService.close();
    super.onClose();
  }

  @override
  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (kDebugMode) {
      print("Initializing WebSocket connection...");
    }

    if (token != null) {
      connectSocket(Urls.websocketUrl, token);
    } else {
      if (kDebugMode) {
        print("No token found.");
      }
    }

    super.onInit();
  }
}
/*
class ChatController extends GetxController {
  final WebSocketService _socketService = WebSocketService();

  var usersWithLastMessages = [].obs;
  var chats = [].obs;
  var isLoadingChats = true.obs;

  void connectSocket(String url, String token) {
    _socketService.connect(url, token);
    _socketService.messages.listen((message) {
      _handleMessage(message);
    });
    fetchUserList();
  }

  void _handleMessage(dynamic message) {
    if (kDebugMode) {
      print("Received WebSocket message: $message");
    }

    final data = jsonDecode(message);

    switch (data['event']) {
      case "messageList":
        usersWithLastMessages.value = data['data'];
        break;
      case "fetchChats":
        chats.value = data['data'];
        isLoadingChats.value = false;
        break;
      case "message":
        chats.add(data['data']);
        chats.refresh();
        break;
      default:
        if (kDebugMode) {
          print("Unknown event type: ${data['event']}");
        }
    }
  }

  void fetchUserList() {
    _socketService.sendMessage("messageList", {});
  }

  Future<void> refreshUserList() async {
    usersWithLastMessages.clear();
    fetchUserList();
  }

  void fetchChats(String receiverId) {
    isLoadingChats.value = true;
    _socketService.sendMessage("fetchChats", {"receiverId": receiverId});
  }

  void sendMessage(String receiverId, String message, {List<String>? images}) {
    final payload = {
      "receiverId": receiverId,
      "message": message,
      "images": images ?? [],
    };
    _socketService.sendMessage("message", payload);
  }

  @override
  void onClose() {
    _socketService.close();
    super.onClose();
  }

  @override
  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (kDebugMode) {
      print("Initializing WebSocket connection...");
    }

    if (token != null) {
      connectSocket(Urls.websocketUrl, token);
    } else {
      if (kDebugMode) {
        print("No token found.");
      }
    }

    super.onInit();
  }
}

*/