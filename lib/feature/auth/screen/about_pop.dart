import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/feature/auth/controller/about%20_controlleer.dart';

class AboutUsPopup extends StatelessWidget {
  static const LinearGradient gradientColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 131, 131, 131),
      Color.fromARGB(255, 52, 51, 53),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AboutUsController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient background
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: gradientColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  // App Logo/Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.storefront_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    textAlign: TextAlign.center,
                    'Welcome to \nHand To Hand',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    textAlign: TextAlign.center,
                    'Global marketplace connecting communities',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Description
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Hand To Hand is a revolutionary marketplace where people discover, share, and connect over amazing products from around the world.\n\nBrowse listings, chat with sellers in your language, and make deals in person - all while supporting local communities across 20+ countries.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF4A5568),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 24),

                    // Key Features Section
                    Text(
                      'What Makes Hand To Hand Special:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 16),

                    _buildFeatureItem(
                      Icons.language_outlined,
                      'Universal Communication',
                      'Chat in any language with real-time translation',
                    ),
                    _buildFeatureItem(
                      Icons.attach_money_outlined,
                      'Live Currency Conversion',
                      'See prices in your local currency instantly',
                    ),
                    _buildFeatureItem(
                      Icons.handshake_outlined,
                      'Meet & Deal Locally',
                      'Connect in person, buy with confidence',
                    ),
                    _buildFeatureItem(
                      Icons.public_outlined,
                      '20+ Countries Supported',
                      'Global reach, local connection',
                    ),
                    _buildFeatureItem(
                      Icons.no_accounts_outlined,
                      'No Platform Fees',
                      'Keep 100% of your earnings (most categories)',
                    ),

                    SizedBox(height: 24),

                    // How It Works Section
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF4CAF50).withOpacity(0.1),
                            Color(0xFF2196F3).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xFF4CAF50).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: gradientColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'How It Works:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildStepItem('1', 'Browse & Discover',
                              'Find amazing products from sellers worldwide'),
                          _buildStepItem('2', 'Chat & Negotiate',
                              'Communicate in your language, discuss details'),
                          _buildStepItem('3', 'Meet & Purchase',
                              'Arrange meetup, inspect, and buy in person'),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Categories Section
                    Text(
                      'Popular Categories:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildCategoryCard(
                            Icons.directions_car_outlined,
                            'Cars & Vehicles',
                            'Premium listing',
                            Colors.red,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildCategoryCard(
                            Icons.shopping_bag_outlined,
                            'Retail Products',
                            'Premium listing',
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCategoryCard(
                            Icons.home_outlined,
                            'Home & Garden',
                            'Free listing',
                            Colors.green,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildCategoryCard(
                            Icons.phone_android_outlined,
                            'Electronics',
                            'Free listing',
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Global Reach Section
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF9C27B0).withOpacity(0.1),
                            Color(0xFF673AB7).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xFF9C27B0).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.public,
                                color: Color(0xFF9C27B0),
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Global Community',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Connect with buyers and sellers across France, Germany, UK, USA, Canada, Australia, Japan, India, Brazil, and 10+ more countries!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A5568),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Call to Action
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: gradientColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4CAF50).withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        'Start connecting with your community today! 🌍✨',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Container(
              padding: EdgeInsets.all(24),
              child: GestureDetector(
                onTap: controller.closePopup,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: gradientColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4CAF50).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Explore Hand To Hand',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Color(0xFF4CAF50),
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Color(0xFF10B981),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String step, String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: gradientColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                step,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// // Usage in your main app or home screen
// class AppInitializer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Initialize the AboutUsController
//     Get.put(AboutUsController());
    
//     return YourMainAppContent(); // Your actual home screen content
//   }
// }

// Example of how to integrate in your main app
// class YourMainAppContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MajidFirh'),
//         actions: [
//           // Optional: Add a button to manually show About Us
//           IconButton(
//             icon: Icon(Icons.info_outline),
//             onPressed: () {
//               final controller = Get.find<AboutUsController>();
//               controller.showAboutUsManually();
//             },
//           ),
//         ],