import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsController extends GetxController {
  var isAccepted = false.obs;
  var scrollController = ScrollController();
  var hasScrolledToBottom = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      hasScrolledToBottom.value = true;
    }
  }

  void toggleAcceptance() {
    isAccepted.value = !isAccepted.value;
  }

  void acceptTerms() {
    if (isAccepted.value) {
      Get.back(result: true);
    } else {
      Get.snackbar(
        'Terms Required',
        'Please accept the terms and conditions to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
