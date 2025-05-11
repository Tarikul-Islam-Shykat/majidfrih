// lib/screens/product_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/app_bar.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/feature/home/controller/product_controller.dart';
import 'package:prettyrini/feature/home/ui/product_card.dart';
import 'package:prettyrini/feature/home/ui/product_details_screen.dart';

class ProductHomeScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final String username = "Jenny"; // This could come from user authentication

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          // Your existing background
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Image.asset(
              ImagePath.subscriptionLogo,
              fit: BoxFit.fill,
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                buildAppBar(username),
                const SizedBox(height: 20),
                Expanded(
                  child: Obx(() {
                    if (productController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }
                    return _buildProductList();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Product nearby you",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey.shade800),
                  child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grid of products
            Obx(() => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: productController.nearbyProducts.length,
                  itemBuilder: (context, index) {
                    final product = productController.nearbyProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () =>
                          Get.to(() => ProductDetailScreen(product: product)),
                    );
                  },
                )),

            const SizedBox(height: 80), // Space for bottom navigation
          ],
        ),
      ),
    );
  }
}
