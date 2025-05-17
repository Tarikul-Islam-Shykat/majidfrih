// lib/screens/product_detail_screen.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/app_bar.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/home/controller/product_controller.dart';
import 'package:prettyrini/feature/home/model/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final ProductController productController = Get.find<ProductController>();
  final ThemeController themeController = Get.find<ThemeController>();

  ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.isDarkMode;

    final Color iconTextColor = isDarkMode ? Colors.white : Colors.black;
    final Color bgColor = isDarkMode ? Colors.black : AppColors.primaryColor;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color descriptionBgColor = isDarkMode
        ? Colors.grey[900]!
        : AppColors.primaryColor.withOpacity(0.1);
    final Color categoryBgColor = isDarkMode
        ? Colors.amber.withOpacity(0.3)
        : Colors.amber.withOpacity(0.1);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background
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

          // Content
          SafeArea(
            child: Column(
              children: [
                buildAppBar("Jenny", textColor: iconTextColor),
                SizedBox(height: 20),
                _buildProductDetails(
                  textColor: textColor,
                  descriptionBgColor: descriptionBgColor,
                  categoryBgColor: categoryBgColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                    onTap: () {},
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Message",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails({
    required Color textColor,
    required Color descriptionBgColor,
    required Color categoryBgColor,
  }) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: descriptionBgColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Product Title and Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: product.categories.map((category) {
                          return Container(
                            decoration: BoxDecoration(
                              color: categoryBgColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            child: Text(
                              category,
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Description",
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: descriptionBgColor),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  child: Text(
                    product.description,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
