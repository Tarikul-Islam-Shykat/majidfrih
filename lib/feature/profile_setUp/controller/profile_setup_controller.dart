import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileEditController extends GetxController {
  // Form controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Observables
  var isUpdateLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedImage = Rxn<File>();
  var isUserNameValid = true.obs;
  var isPhoneNumberValid = true.obs;

  // Image picker
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Get arguments if passed
    if (Get.arguments != null) {
      if (Get.arguments['email'] != null) {
        emailController.text = Get.arguments['email'];
      }
      if (Get.arguments['number'] != null) {
        phoneNumberController.text = Get.arguments['number'];
      }
      if (Get.arguments['userName'] != null) {
        userNameController.text = Get.arguments['userName'];
      }
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Validation methods
  bool validateForm() {
    bool isValid = true;

    // Validate username
    if (userNameController.text.trim().isEmpty) {
      isUserNameValid.value = false;
      isValid = false;
    } else {
      isUserNameValid.value = true;
    }

    // Validate phone number
    if (phoneNumberController.text.trim().isEmpty) {
      isPhoneNumberValid.value = false;
      isValid = false;
    } else {
      isPhoneNumberValid.value = true;
    }

    return isValid;
  }

  // Image picker methods
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        log("Image selected: ${pickedFile.path}");
      }
    } catch (e) {
      log("Error picking image: $e");
      errorMessage.value = 'Error selecting image: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        log("Image captured: ${pickedFile.path}");
      }
    } catch (e) {
      log("Error capturing image: $e");
      errorMessage.value = 'Error capturing image: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showImagePickerDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Update profile method
  Future<bool> updateProfile() async {
    if (!validateForm()) {
      return false;
    }

    try {
      log("updateProfile started with multipart request");
      isUpdateLoading.value = true;
      errorMessage.value = '';

      SharedPreferences sh = await SharedPreferences.getInstance();
      String? token = sh.getString("token");

      log("Token: $token");

      // Prepare profile data
      var profileData = {
        "fullName": userNameController.text.trim(),
        "phoneNumber": phoneNumberController.text.trim(),
        "email": emailController.text.trim(),
      };

      log("Profile Data: ${jsonEncode(profileData)}");

      final request = http.MultipartRequest(
        'PUT', // or 'POST' depending on your API
        Uri.parse("${Urls.baseUrl}/users/profile"),
      );

      request.headers.addAll({
        'Authorization': "$token", // Added Bearer prefix
      });

      // Add profile data as JSON string
      request.fields['profileData'] = jsonEncode(profileData);

      // Add profile image if selected
      if (selectedImage.value != null) {
        var imageBytes = await selectedImage.value!.readAsBytes();
        var imageFile = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        request.files.add(imageFile);
        log("Profile image added to request");
      }

      log("Sending profile update request...  ${token}");
      log("Request fields: ${request.fields}");
      log("Request files: ${request.files.length}");

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      log("Response Status Code: ${response.statusCode}");
      log("Response Headers: ${response.headers}");
      log("Response Body: $responseString");

      final responseJson = json.decode(responseString);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseJson['success'] == true) {
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        errorMessage.value =
            responseJson['message'] ?? 'Failed to update profile';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      log("Error updating profile: $e");
      errorMessage.value = 'Error updating profile: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isUpdateLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    userNameController.clear();
    phoneNumberController.clear();
    // Don't clear email as it comes from arguments
    selectedImage.value = null;
    isUserNameValid.value = true;
    isPhoneNumberValid.value = true;
    errorMessage.value = '';
  }

  // Fill test data for debugging
  void fillTestData() {
    userNameController.text = "efaz";
    phoneNumberController.text = "+1234567890";
  }
}
