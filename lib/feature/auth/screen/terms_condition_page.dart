import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/feature/auth/controller/terms_controller.dart';

/*
final result = await Get.to(() => TermsAndConditionsPage());
if (result == true) {
  // User accepted terms
  print("Terms accepted!");
}
*/
// GetX Controller

class TermsAndConditionsPage extends StatelessWidget {
  final TermsController controller = Get.put(TermsController());

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradientColor),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: gradientColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.description_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Timelify Terms and Conditions',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Please read these terms carefully before using our services',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF718096),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Terms Content
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: SingleChildScrollView(
                            controller: controller.scrollController,
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSection('1. Introduction',
                                    'Welcome to our digital marketplace platform (the "Platform"), designed to facilitate the listing, discovery, and sale of products between users and sellers. These Terms and Conditions constitute a legal agreement between you (the "User") and the Platform operator and govern your access to and use of our website, mobile application, and related services.\n\nBy accessing or using any part of the Platform, you agree to be bound by these Terms. If you do not agree to all of the Terms, you may not access the Platform.'),
                                _buildSection('2. Description of Services',
                                    'The Platform acts as a digital intermediary facilitating the connection between buyers and sellers. The Platform does not manufacture, own, sell, resell, or distribute any products listed on the marketplace. We do not endorse, guarantee, or assume responsibility for any products, services, or content posted by users.'),
                                _buildSection(
                                    '3. User Obligations and Content Responsibility',
                                    'You agree that your use of the Platform is solely at your own risk and responsibility. As a user, you:\n\n• Must be at least 18 years old and have the legal capacity to enter into binding contracts\n• Must provide accurate, complete, and up-to-date registration information\n• Are solely responsible for all content, products, listings, and materials you upload, post, or transmit through the Platform\n• Warrant that all products you list comply with applicable laws and regulations\n• Acknowledge that you are fully responsible for verifying the legality, authenticity, and quality of any products before listing or purchasing\n• Agree not to upload, list, or sell any illegal, counterfeit, stolen, or prohibited items\n• Agree not to use the platform for any unlawful, harmful, fraudulent, or abusive activities'),
                                _buildSection(
                                    '4. Prohibited Content and Products',
                                    'Users are strictly prohibited from listing or selling:\n• Illegal drugs, weapons, or controlled substances\n• Counterfeit, stolen, or pirated goods\n• Items that violate intellectual property rights\n• Adult content or services\n• Any products prohibited by local, national, or international law\n• Hazardous materials or dangerous goods\n• Products that may cause harm to persons or property\n\nThe Platform reserves the right to remove any listing or content without notice and terminate accounts that violate these restrictions.'),
                                _buildSection('5. Platform Role and Disclaimer',
                                    'The Platform is not a party to any transaction between buyers and sellers. We do not:\n• Verify the identity, credentials, or legitimacy of users\n• Inspect, test, or validate any products listed\n• Guarantee the accuracy of product descriptions or listings\n• Control the quality, safety, legality, or availability of products\n• Participate in or oversee actual transactions between users\n\nAll transactions are conducted entirely between users at their own risk.'),
                                _buildSection(
                                    '6. Intellectual Property and Content',
                                    'Users retain ownership of content they upload but grant the Platform a non-exclusive, worldwide, royalty-free license to use, display, and distribute such content for platform operations. Users warrant they have all necessary rights to grant this license and that their content does not infringe on third-party rights.'),
                                _buildSection('7. Payment Processing',
                                    'All payments are processed through third-party payment processors. The Platform does not collect, store, or have access to payment card information and cannot be held liable for:\n• Payment processing errors or failures\n• Financial losses, fraud, or unauthorized transactions\n• Disputes between buyers and sellers regarding payments\n• Chargebacks, refunds, or payment-related issues\n\nPayment disputes must be resolved directly between transaction parties.'),
                                _buildSection('8. Limitation of Liability',
                                    'To the fullest extent permitted by law, the Platform and its operators shall not be liable for:\n• Any indirect, incidental, special, consequential, or punitive damages\n• Any loss of profits, revenue, data, or business opportunities\n• Any claims arising from user-generated content, product listings, or transactions\n• Any illegal, counterfeit, or prohibited items listed by users\n• Any personal injury, property damage, or losses resulting from product use\n• Any violations of law committed by platform users\n\nIn no event shall the Platform\'s total liability exceed the fees paid by you (if any) for using the platform within the last 12 months.'),
                                _buildSection('9. Indemnification',
                                    'You agree to indemnify, defend, and hold harmless the Platform and its operators from any claims, damages, losses, costs, or expenses (including legal fees) arising from:\n• Your use of the Platform\n• Your violation of these Terms\n• Your listings, products, or content\n• Any illegal or prohibited activities conducted through your account\n• Any third-party claims related to your products or services'),
                                _buildSection(
                                    '10. Content Moderation and Removal',
                                    'While the Platform may monitor content and listings, we are under no obligation to do so. We reserve the right to:\n• Remove any content or listings without notice\n• Suspend or terminate accounts that violate these Terms\n• Cooperate with law enforcement investigations\n• Take any action deemed necessary to protect the Platform and its users\n\nUsers acknowledge that content moderation is conducted on a best-effort basis and the Platform cannot guarantee the removal of all prohibited content.'),
                                _buildSection(
                                    '11. Account Security and Termination',
                                    'You are solely responsible for:\n• Maintaining the confidentiality of your account credentials\n• All activities that occur under your account\n• Notifying us immediately of any unauthorized use\n\nWe may suspend or terminate your access at any time, with or without cause or notice, including for breach of these Terms, suspected illegal activity, or misuse of the Platform.'),
                                _buildSection('12. Compliance with Laws',
                                    'Users must comply with all applicable local, national, and international laws and regulations. The Platform disclaims any responsibility for users\' legal compliance and strongly advises users to seek legal counsel regarding their obligations.'),
                                _buildSection(
                                    '13. Governing Law and Dispute Resolution',
                                    'These Terms shall be governed by the laws of the Republic of South Africa, without regard to conflict of law provisions. Any disputes shall be subject to the exclusive jurisdiction of the courts located in South Africa.'),
                                _buildSection('14. Changes to Terms',
                                    'We reserve the right to modify these Terms at any time. Continued use of the Platform after changes constitutes acceptance of the modified Terms.'),
                                _buildSection('15. Contact Information',
                                    'For questions about these Terms or to report violations, contact us at:\n\nEmail: [Your Email Address]\nAddress: [Your Business Address]'),
                                SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Bottom Section with Checkbox and Button
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Checkbox
                            Obx(() => GestureDetector(
                                  onTap: controller.toggleAcceptance,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: controller.isAccepted.value
                                                ? Color(0xFF7B4BF5)
                                                : Color(0xFFE2E8F0),
                                            width: 2,
                                          ),
                                          color: controller.isAccepted.value
                                              ? Color(0xFF7B4BF5)
                                              : Colors.white,
                                        ),
                                        child: controller.isAccepted.value
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              )
                                            : null,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'I have read and agree to the Terms and Conditions',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF4A5568),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),

                            SizedBox(height: 20),

                            // Accept Button
                            Obx(() => GestureDetector(
                                  onTap: controller.acceptTerms,
                                  child: Container(
                                    width: double.infinity,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: controller.isAccepted.value
                                          ? gradientColor
                                          : LinearGradient(
                                              colors: [
                                                Color(0xFFE2E8F0),
                                                Color(0xFFE2E8F0)
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: controller.isAccepted.value
                                          ? [
                                              BoxShadow(
                                                color: Color(0xFF7B4BF5)
                                                    .withOpacity(0.3),
                                                blurRadius: 12,
                                                offset: Offset(0, 6),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Accept & Continue',
                                        style: TextStyle(
                                          color: controller.isAccepted.value
                                              ? Colors.white
                                              : Color(0xFF9CA3AF),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
              height: 1.4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4A5568),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
