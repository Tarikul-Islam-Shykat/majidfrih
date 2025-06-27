// // lib/screens/product_home_screen.dart

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
  final EnhancedProductController productController =
      Get.put(EnhancedProductController());
  final String username = "Jenny";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          // Background
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Image.asset(
              ImagePath.subscriptionLogo,
              fit: BoxFit.fill,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                buildAppBar("Jenny", textColor: Colors.white),
                const SizedBox(height: 10),
                _buildLocationLanguageSelector(context),
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
                    return _buildProductList(context);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationLanguageSelector(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildCountryDropdown(),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildWideScreenSelectors() {
    return Row(
      children: [
        // Country Selector
        Icon(Icons.location_on, color: Colors.white, size: 20.w),
        SizedBox(width: 8.w),
        Expanded(
          flex: 2,
          child: _buildCountryDropdown(),
        ),
        SizedBox(width: 16.w),
        // Language Selector
        Icon(Icons.language, color: Colors.white, size: 20.w),
        SizedBox(width: 8.w),
        // Expanded(
        //   flex: 2,
        //   child: _buildLanguageDropdown(),
        // ),
      ],
    );
  }

  Widget _buildNarrowScreenSelectors() {
    return Column(
      children: [
        // Country Selector Row
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.white, size: 20.w),
            SizedBox(width: 8.w),
            Expanded(child: _buildCountryDropdown()),
          ],
        ),
        SizedBox(height: 12.h),
        // // Language Selector Row
        // Row(
        //   children: [
        //     Icon(Icons.language, color: Colors.white, size: 20.w),
        //     SizedBox(width: 8.w),
        //     Expanded(child: _buildLanguageDropdown()),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: productController.selectedCountry.value,
              icon:
                  Icon(Icons.arrow_drop_down, color: Colors.white, size: 20.w),
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
              dropdownColor: Colors.grey[800],
              isExpanded: true,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              items: productController.availableCountries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(
                    country,
                    style: GoogleFonts.poppins(fontSize: 13.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  productController.changeCountry(newValue);
                }
              },
            ),
          )),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: productController.selectedLanguage.value,
              icon:
                  Icon(Icons.arrow_drop_down, color: Colors.white, size: 20.w),
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
              dropdownColor: Colors.grey[800],
              isExpanded: true,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              items:
                  productController.availableLanguages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(
                    language,
                    style: GoogleFonts.poppins(fontSize: 13.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  productController.changeLanguage(newValue);
                }
              },
            ),
          )),
    );
  }

  Widget _buildProductList(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;

    // Responsive grid count
    if (screenWidth > 1200) {
      crossAxisCount = 4;
    } else if (screenWidth > 800) {
      crossAxisCount = 3;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Product nearby you",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Refresh button
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade800.withOpacity(0.8)),
                      child: IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 20.w,
                        ),
                        onPressed: () {
                          productController.refreshData();
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Search button
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade800.withOpacity(0.8)),
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20.w,
                        ),
                        onPressed: () {
                          _showSearchDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Grid of products
            Obx(() => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                  ),
                  //  itemCount: productController.nearbyProducts.length,
                  itemCount: productController.isSearching.value
                      ? productController.filteredProducts.length
                      : productController.nearbyProducts.length,
                  itemBuilder: (context, index) {
                    final product = productController.isSearching.value
                        ? productController.filteredProducts[index]
                        : productController.nearbyProducts[index];
                    return EnhancedProductCard(
                      product: product,
                      controller: productController,
                      // onTap: () {}
                      onTap: () =>
                          Get.to(() => ProductDetailScreen(product: product)),
                    );
                  },
                )),

            SizedBox(height: 80.h), // Space for bottom navigation
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Search Products',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: TextField(
          controller: searchController,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter product name...',
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
          onChanged: (value) {
            productController.searchProducts(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              productController.clearSearch();
              Navigator.pop(context);
            },
            child:
                Text('Clear', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done',
                style: GoogleFonts.poppins(color: AppColors.primaryColor)),
          ),
        ],
      ),
    );
  }
}
