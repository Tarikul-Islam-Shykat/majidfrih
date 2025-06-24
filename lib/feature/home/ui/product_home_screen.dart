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
          // Country/Currency and Language Selectors
          // _buildNarrowScreenSelectors(),
          // screenWidth > 600
          //     ? _buildWideScreenSelectors()
          //     : _buildNarrowScreenSelectors(),
          _buildCountryDropdown(),
          // Currency Display
          SizedBox(height: 8.h),
          // Obx(() => Container(
          //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          //       decoration: BoxDecoration(
          //         color: AppColors.primaryColor.withOpacity(0.2),
          //         borderRadius: BorderRadius.circular(20.r),
          //         border: Border.all(
          //             color: AppColors.primaryColor.withOpacity(0.5)),
          //       ),
          //       child: Text(
          //         'Currency: ${productController.selectedCurrency.value}',
          //         style: GoogleFonts.poppins(
          //           color: Colors.white,
          //           fontSize: 12.sp,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     )),
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
                        onPressed: () {},
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
                  itemCount: productController.nearbyProducts.length,
                  itemBuilder: (context, index) {
                    final product = productController.nearbyProducts[index];
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
}

/*
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

          // Content
          SafeArea(
            child: Column(
              children: [
                //   buildAppBar(username),
                const SizedBox(height: 10),
                _buildLocationLanguageSelector(),
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

  Widget _buildLocationLanguageSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // Country/Currency Selector
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(() => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: productController.selectedCountry.value,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 14.sp),
                        dropdownColor: Colors.grey[800],
                        items: productController.availableCountries
                            .map((String country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            productController.changeCountry(newValue);
                          }
                        },
                      ),
                    )),
              ),
              const SizedBox(width: 16),
              // Language Selector
              Icon(Icons.language, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(() => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: productController.selectedLanguage.value,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 14.sp),
                        dropdownColor: Colors.grey[800],
                        items: productController.availableLanguages
                            .map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            productController.changeLanguage(newValue);
                          }
                        },
                      ),
                    )),
              ),
            ],
          ),

          // Currency Display
          const SizedBox(height: 8),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      'Currency: ${productController.selectedCurrency.value}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )),
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
                Obx(() => Text(
                      productController.getTranslatedText("Product nearby you"),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    )),
                Row(
                  children: [
                    // Refresh button
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade800),
                      child: IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          productController.refreshData();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Search button
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
                    return EnhancedProductCard(
                        product: product,
                        controller: productController,
                        onTap: () {}
                        // onTap: () =>
                        //     Get.to(() => ProductDetailScreen(product: product)),
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

*/
