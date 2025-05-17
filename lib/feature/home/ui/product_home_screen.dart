import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/app_bar.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/home/controller/product_controller.dart';
import 'package:prettyrini/feature/home/ui/product_card.dart';
import 'package:prettyrini/feature/home/ui/product_details_screen.dart';

class ProductHomeScreen extends StatefulWidget {
  ProductHomeScreen({super.key});

  @override
  State<ProductHomeScreen> createState() => _ProductHomeScreenState();
}

class _ProductHomeScreenState extends State<ProductHomeScreen> {
  final ProductController productController = Get.put(ProductController());
  final ThemeController themeController = Get.find<ThemeController>();
  final String username = "Jenny";

  // To show/hide search bar
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      productController.searchQuery.value = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final Color iconTextColor = isDarkMode ? Colors.white : Colors.black;
      final Color titleTextColor = isDarkMode ? Colors.white : Colors.black;
      final Color bgColor = isDarkMode ? Colors.black : AppColors.primaryColor;
      final String bgImage =
          isDarkMode ? ImagePath.subscriptionLogo : ImagePath.subscriptionLogol;

      return Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                bgImage,
                fit: BoxFit.fill,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // AppBar or SearchBar depending on _isSearching
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _isSearching
                        ? _buildSearchBar(titleTextColor, iconTextColor)
                        : buildAppBar(username, textColor: iconTextColor),
                  ),
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
                      return _buildProductList(titleTextColor, isDarkMode);
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSearchBar(Color titleTextColor, Color iconTextColor) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(color: titleTextColor),
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(color: titleTextColor.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: iconTextColor.withOpacity(0.1),
              prefixIcon: Icon(Icons.search, color: titleTextColor),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: titleTextColor),
                      onPressed: () {
                        _searchController.clear();
                        productController.searchQuery.value = '';
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              productController.searchQuery.value = value;
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: iconTextColor),
          onPressed: _stopSearch,
        ),
      ],
    );
  }

  Widget _buildProductList(Color titleTextColor, bool isDarkMode) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Search Icon only when not searching
            if (!_isSearching)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Products nearby you",
                    style: GoogleFonts.poppins(
                      color: titleTextColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode ? Colors.white10 : Colors.grey.shade300,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: titleTextColor,
                      ),
                      onPressed: _startSearch,
                    ),
                  ),
                ],
              ),

            if (!_isSearching) const SizedBox(height: 16),

            // Product Grid showing filteredNearbyProducts
            Obx(() => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: productController.filteredNearbyProducts.length,
                  itemBuilder: (context, index) {
                    final product =
                        productController.filteredNearbyProducts[index];
                    return ProductCard(
                      isDarkMode: isDarkMode,
                      product: product,
                      onTap: () =>
                          Get.to(() => ProductDetailScreen(product: product)),
                    );
                  },
                )),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
