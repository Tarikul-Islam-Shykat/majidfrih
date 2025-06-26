// lib/screens/post_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import 'package:prettyrini/feature/post/CONTROLLER/post_controller.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Background
              // SizedBox(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height,
              //   child: Image.asset(
              //     ImagePath.subscriptionLogo,
              //     fit: BoxFit.fill,
              //   ),
              // ),

              // Content
              Column(
                children: [
                  SizedBox(height: 20),
                  Column(
                    children: [
                      // Image selection container
                      Obx(() => GestureDetector(
                            onTap: () {
                              if (postController.selectedImage.value == null) {
                                postController.showImagePickerDialog();
                              }
                            },
                            child: Container(
                              height: 120.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: postController.selectedImage.value == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Add Product Image",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: Image.file(
                                            postController.selectedImage.value!,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                onTap: () => postController
                                                    .showImagePickerDialog(),
                                                child: Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () => postController
                                                    .removeSelectedImage(),
                                                child: Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          )),
                      SizedBox(height: 20),
                      // Replace the existing Country Dropdown section with this code

                      // Country Horizontal List
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5, bottom: 12),
                              child: Text(
                                "Select Country",
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              height: 90,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: PostController
                                    .countryCurrencyMap.keys.length,
                                itemBuilder: (context, index) {
                                  final countries = PostController
                                      .countryCurrencyMap.keys
                                      .toList();
                                  final country = countries[index];
                                  final currency = PostController
                                      .countryCurrencyMap[country]!;
                                  final isSelected =
                                      postController.selectedCountry.value ==
                                          country;

                                  // Generate random colors for each country
                                  final colors = [
                                    [
                                      Color(0xFF667EEA),
                                      Color(0xFF764BA2)
                                    ], // Purple-Blue gradient
                                    [
                                      Color(0xFF12C2E9),
                                      Color(0xFFC471ED)
                                    ], // Cyan-Pink gradient
                                    [
                                      Color(0xFF11998E),
                                      Color(0xFF38EF7D)
                                    ], // Teal-Green gradient
                                    [
                                      Color(0xFFFA709A),
                                      Color(0xFFFEE140)
                                    ], // Pink-Yellow gradient
                                    [
                                      Color(0xFFFC466B),
                                      Color(0xFF3F5EFB)
                                    ], // Red-Blue gradient
                                    [
                                      Color(0xFFFFCE00),
                                      Color(0xFFFE4880)
                                    ], // Yellow-Pink gradient
                                    [
                                      Color(0xFF4ECDC4),
                                      Color(0xFF44A08D)
                                    ], // Turquoise-Green gradient
                                    [
                                      Color(0xFFF093FB),
                                      Color(0xFFF5576C)
                                    ], // Purple-Red gradient
                                    [
                                      Color(0xFF4FACFE),
                                      Color(0xFF00F2FE)
                                    ], // Blue-Cyan gradient
                                    [
                                      Color(0xFF43E97B),
                                      Color(0xFF38F9D7)
                                    ], // Green-Mint gradient
                                    [
                                      Color(0xFFFA8BFF),
                                      Color(0xFF2BD2FF)
                                    ], // Pink-Blue gradient
                                    [
                                      Color(0xFF52ACFF),
                                      Color(0xFFFFE32C)
                                    ], // Blue-Yellow gradient
                                    [
                                      Color(0xFFFF5F6D),
                                      Color(0xFFFFC371)
                                    ], // Red-Orange gradient
                                    [
                                      Color(0xFF667EEA),
                                      Color(0xFF764BA2)
                                    ], // Purple-Blue gradient
                                    [
                                      Color(0xFF96DEDA),
                                      Color(0xFF50C9C3)
                                    ], // Light-Dark Teal gradient
                                    [
                                      Color(0xFFFC354C),
                                      Color(0xFF0ABFBC)
                                    ], // Red-Teal gradient
                                    [
                                      Color(0xFFB224EF),
                                      Color(0xFF7579FF)
                                    ], // Purple-Blue gradient
                                    [
                                      Color(0xFF00C9FF),
                                      Color(0xFF92FE9D)
                                    ], // Blue-Green gradient
                                    [
                                      Color(0xFFFF7F7F),
                                      Color(0xFFFF7F50)
                                    ], // Light Red-Coral gradient
                                    [
                                      Color(0xFF74B9FF),
                                      Color(0xFF0984E3)
                                    ], // Light-Dark Blue gradient
                                  ];

                                  final colorPair =
                                      colors[index % colors.length];

                                  return GestureDetector(
                                    onTap: () => postController
                                        .onCountryChanged(country),
                                    child: Container(
                                      width: 160,
                                      margin: EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: isSelected
                                              ? [
                                                  Colors.white,
                                                  Colors.grey.shade100
                                                ]
                                              : colorPair,
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: isSelected
                                            ? Border.all(
                                                color: Colors.white, width: 3)
                                            : null,
                                        boxShadow: [
                                          BoxShadow(
                                            color: isSelected
                                                ? Colors.white.withOpacity(0.4)
                                                : colorPair[0].withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          // Selected indicator
                                          if (isSelected)
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                              ),
                                            ),

                                          // Content
                                          Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Country name
                                                Text(
                                                  country,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: isSelected
                                                        ? Colors.black87
                                                        : Colors.white,
                                                    height: 1.2,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 6),

                                                // Currency info
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? Colors.blue.shade100
                                                        : Colors.white
                                                            .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(width: 2),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // Product Name
                      CustomAuthField(
                        controller: postController.productNameController,
                        hintText: "Product Name",
                        maxLines: 1,
                      ),
                      SizedBox(height: 20),

                      // Product Price with Currency
                      Row(
                        children: [
                          Expanded(
                            child: CustomAuthField(
                              controller: postController.productPriceController,
                              hintText: "Product Price",
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Obx(() => Text(
                                  "${postController.currencySymbol.value} ${postController.selectedCurrency.value}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Product Description
                      CustomAuthField(
                        controller: postController.productDescriptionController,
                        hintText: "Product Description",
                        maxLines: 5,
                        radiusValue2: 20,
                        radiusValue: 20,
                      ),
                      SizedBox(height: 20),
                      // Replace the existing Category Dropdown section with this code

                      // Category Horizontal List
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5, bottom: 12),
                              child: Text(
                                "Select Category",
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Obx(() {
                              if (postController.isCategoryLoading.value) {
                                return Container(
                                  height: 60,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Loading categories...",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              // Filter out categories that start with "test" (case insensitive)
                              final filteredCategories = postController
                                  .categories
                                  .where((category) => !category.title
                                      .toLowerCase()
                                      .startsWith('test'))
                                  .toList();

                              if (filteredCategories.isEmpty) {
                                return Container(
                                  height: 60,
                                  child: Center(
                                    child: Text(
                                      "No categories available",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }

                              return Container(
                                height: 85,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: filteredCategories.length,
                                  itemBuilder: (context, index) {
                                    final category = filteredCategories[index];
                                    final isSelected = postController
                                            .selectedCategory.value?.id ==
                                        category.id;

                                    // Generate random colors for each category
                                    final colors = [
                                      [
                                        Color(0xFF6366F1),
                                        Color(0xFF8B5CF6)
                                      ], // Purple gradient
                                      [
                                        Color(0xFF06B6D4),
                                        Color(0xFF3B82F6)
                                      ], // Blue gradient
                                      [
                                        Color(0xFF10B981),
                                        Color(0xFF059669)
                                      ], // Green gradient
                                      [
                                        Color(0xFFEF4444),
                                        Color(0xFFDC2626)
                                      ], // Red gradient
                                      [
                                        Color(0xFFF59E0B),
                                        Color(0xFFD97706)
                                      ], // Orange gradient
                                      [
                                        Color(0xFFEC4899),
                                        Color(0xFFBE185D)
                                      ], // Pink gradient
                                      [
                                        Color(0xFF8B5A2B),
                                        Color(0xFF92400E)
                                      ], // Brown gradient
                                      [
                                        Color(0xFF6B7280),
                                        Color(0xFF374151)
                                      ], // Gray gradient
                                    ];

                                    final colorPair =
                                        colors[index % colors.length];

                                    return GestureDetector(
                                      onTap: () {
                                        postController
                                            .onCategoryChanged(category);
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 140,
                                        margin: EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: isSelected
                                                ? [
                                                    Colors.white,
                                                    Colors.grey.shade100
                                                  ] // ← WHITE BACKGROUND WHEN SELECTED
                                                : colorPair, // ← COLORED GRADIENT WHEN NOT SELECTED
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: isSelected
                                              ? Border.all(
                                                  color: Colors.white,
                                                  width:
                                                      3) // ← WHITE BORDER WHEN SELECTED
                                              : null,
                                          boxShadow: [
                                            BoxShadow(
                                              color: isSelected
                                                  ? Colors.white.withOpacity(
                                                      0.3) // ← WHITE SHADOW WHEN SELECTED
                                                  : colorPair[0]
                                                      .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            // Selected indicator
                                            if (isSelected)
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),

                                            // Content
                                            Padding(
                                              padding: EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    category.title,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: isSelected
                                                          ? Colors.black87
                                                          : Colors.white,
                                                      height: 1.2,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 6),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 3),
                                                    decoration: BoxDecoration(
                                                      color: category
                                                              .isNeedToPay
                                                          ? (isSelected
                                                              ? Colors.orange
                                                                  .shade100
                                                              : Colors.white
                                                                  .withOpacity(
                                                                      0.2))
                                                          : (isSelected
                                                              ? Colors.green
                                                                  .shade100
                                                              : Colors.white
                                                                  .withOpacity(
                                                                      0.2)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Text(
                                                      category.isNeedToPay
                                                          ? "${category.amount} ${category.moneyCode}"
                                                          : "Free",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            category.isNeedToPay
                                                                ? (isSelected
                                                                    ? Colors
                                                                        .orange
                                                                        .shade800
                                                                    : Colors
                                                                        .white)
                                                                : (isSelected
                                                                    ? Colors
                                                                        .green
                                                                        .shade800
                                                                    : Colors
                                                                        .white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      // Show category fee if applicable (keep this part the same)
                      Obx(() {
                        if (postController.selectedCategory.value != null &&
                            postController
                                .selectedCategory.value!.isNeedToPay) {
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade100,
                                  Colors.orange.shade50
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.info_outline,
                                      color: Colors.white, size: 16),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Category Fee Required",
                                        style: GoogleFonts.poppins(
                                          color: Colors.orange.shade800,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "This category requires a fee of ${postController.selectedCategory.value!.amount} ${postController.selectedCategory.value!.moneyCode}",
                                        style: GoogleFonts.poppins(
                                          color: Colors.orange.shade700,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox();
                      }),

                      // Category Dropdown
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(color: Colors.grey.shade300),
                      //   ),
                      //   child: Obx(() {
                      //     if (postController.isCategoryLoading.value) {
                      //       return Container(
                      //         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      //         child: Row(
                      //           children: [
                      //             SizedBox(
                      //               width: 20,
                      //               height: 20,
                      //               child: CircularProgressIndicator(strokeWidth: 2),
                      //             ),
                      //             SizedBox(width: 10),
                      //             Text("Loading categories..."),
                      //           ],
                      //         ),
                      //       );
                      //     }

                      //     return DropdownButtonFormField<CategoryModel>(
                      //       value: postController.selectedCategory.value,
                      //       decoration: InputDecoration(
                      //         labelText: 'Select Category',
                      //         labelStyle: TextStyle(color: Colors.grey.shade600),
                      //         border: InputBorder.none,
                      //         contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      //       ),
                      //       dropdownColor: Colors.white,
                      //       isExpanded: true,
                      //       items: postController.categories
                      //           .map((CategoryModel category) => DropdownMenuItem<CategoryModel>(
                      //                 value: category,
                      //                 child: Container(
                      //                   child: Column(
                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       Text(
                      //                         category.title,
                      //                         style: TextStyle(
                      //                           color: Colors.black,
                      //                           fontWeight: FontWeight.w500,
                      //                         ),
                      //                         overflow: TextOverflow.ellipsis,
                      //                       ),
                      //                       SizedBox(height: 2),
                      //                       if (category.isNeedToPay)
                      //                         Text(
                      //                           "Fee: ${category.amount} ${category.moneyCode}",
                      //                           style: TextStyle(
                      //                             color: Colors.orange,
                      //                             fontSize: 11,
                      //                           ),
                      //                         )
                      //                       else
                      //                         Text(
                      //                           "Free",
                      //                           style: TextStyle(
                      //                             color: Colors.green,
                      //                             fontSize: 11,
                      //                           ),
                      //                         ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ))
                      //           .toList(),
                      //       onChanged: (CategoryModel? newValue) {
                      //         postController.onCategoryChanged(newValue);
                      //       },
                      //     );
                      //   }),
                      // ),

                      // // // Show category fee if applicable
                      // Obx(() {
                      //   if (postController.selectedCategory.value != null &&
                      //       postController.selectedCategory.value!.isNeedToPay) {
                      //     return Container(
                      //       margin: EdgeInsets.only(top: 10),
                      //       padding: EdgeInsets.all(10),
                      //       decoration: BoxDecoration(
                      //         color: Colors.orange.shade100,
                      //         borderRadius: BorderRadius.circular(8),
                      //         border: Border.all(color: Colors.orange.shade300),
                      //       ),
                      //       child: Row(
                      //         children: [
                      //           Icon(Icons.info_outline, color: Colors.orange, size: 20),
                      //           SizedBox(width: 8),
                      //           Expanded(
                      //             child: Text(
                      //               "This category requires a fee of ${postController.selectedCategory.value!.amount} ${postController.selectedCategory.value!.moneyCode}",
                      //               style: TextStyle(
                      //                 color: Colors.orange.shade800,
                      //                 fontSize: 12.sp,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   }
                      //   return SizedBox();
                      // }),

                      // SizedBox(height: 30), // Extra space at bottom to prevent overflow
                    ],
                  ),

                  // Post Button
                  Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    child: Obx(() => CustomButton(
                          onTap: postController.isPostLoading.value
                              ? null
                              : () => postController.postProduct(),
                          title: postController.isPostLoading.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Posting...",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.post_add,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Post",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        )),
                  ),

                  SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
