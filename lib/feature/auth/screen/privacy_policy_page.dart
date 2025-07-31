import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/feature/auth/controller/privacy_policy_controller.dart';
import 'package:prettyrini/feature/auth/screen/privacy_policy_page.dart';

/*
final result = await Get.to(() => PrivacyPolicyPage());
if (result == true) {
  // User accepted privacy policy
  print("Privacy policy accepted!");
}
*/
class PrivacyPolicyPage extends StatelessWidget {
  final PrivacyPolicyController controller = Get.put(PrivacyPolicyController());

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
                        'Privacy Policy',
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
                                Icons.privacy_tip_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Effective Date: 1 August 2025\nHand To Hand- Registered in Franch',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF718096),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Privacy Policy Content
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
                                    'We value your trust and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, store, and share your data when you use our marketplace platform. It applies to all users, including buyers and sellers operating within the European Union and France.'),
                                _buildSection('2. Who We Are',
                                    'We operate a digital marketplace platform that connects buyers and sellers for the listing, discovery, and sale of products. We are based in France and facilitate transactions between independent parties while ensuring compliance with French data protection laws and the General Data Protection Regulation (GDPR).'),
                                _buildSection('3. Information We Collect',
                                    '3.1. Information You Provide\n\nBuyers:\n• Full name, phone number, email address\n• Shipping and billing addresses\n• Payment information (processed securely through third parties)\n• Purchase history and preferences\n\nSellers:\n• Personal/Business name and contact details\n• Identity verification documents (required by French law)\n• SIRET number or business registration details\n• Tax identification numbers (TVA)\n• Banking and payment information\n• Product listings, descriptions, and images\n• Business operating details\n\nBoth Users:\n• Account login credentials\n• Messages and communications\n• Ratings, reviews, and feedback\n• Support inquiries and correspondence\n\n3.2. Automatically Collected Information\n• Device and browser information\n• IP address and location data\n• Website usage patterns and analytics\n• Cookies and similar tracking technologies\n• Transaction and behavioral data'),
                                _buildSection('4. How We Use Your Information',
                                    'We process your data for the following purposes:\n• Creating and managing user accounts\n• Facilitating product listings and transactions\n• Processing payments and managing refunds\n• Providing customer support and platform updates\n• Verifying seller identities (legal requirement in France)\n• Preventing fraud and ensuring platform security\n• Analyzing usage to improve platform features\n• Complying with French tax and commercial regulations\n• Sending transactional and marketing communications (with consent)\n• Resolving disputes between buyers and sellers'),
                                _buildSection(
                                    '5. Legal Basis for Processing (GDPR Article 6)',
                                    'Under the GDPR and French data protection laws, we process your data based on:\n• Your explicit consent (Article 6(1)(a))\n• Performance of a contract with you (Article 6(1)(b))\n• Compliance with legal obligations under French law (Article 6(1)(c))\n• Our legitimate interests in operating the platform (Article 6(1)(f))\n• Protection of vital interests where applicable (Article 6(1)(d))'),
                                _buildSection('6. Data Sharing and Disclosure',
                                    'We share your information only when necessary with:\n• Other platform users (buyers/sellers) for transaction purposes\n• Payment processors (Stripe, PayPal, French banking partners)\n• Identity verification services (required by French regulations)\n• Cloud hosting and technical service providers (EU-based)\n• Legal authorities when required by French or EU law\n• Tax authorities (Direction générale des Finances publiques)\n• Auditors and professional advisors\n• Potential buyers in case of business transfer\n\nWe never sell your personal data to third parties for marketing purposes.'),
                                _buildSection('7. International Data Transfers',
                                    'Your data is primarily processed within the European Economic Area (EEA). When transfers outside the EEA are necessary, we ensure adequate protection through:\n• European Commission adequacy decisions\n• Standard Contractual Clauses (SCCs)\n• Binding Corporate Rules\n• Your explicit consent where required'),
                                _buildSection('8. Data Retention',
                                    'We retain your personal data only as long as necessary for:\n• Active account management\n• Legal obligations under French commercial law (typically 5-10 years)\n• Tax and accounting requirements\n• Fraud prevention and dispute resolution\n\nYou may request earlier deletion unless retention is required by French law.'),
                                _buildSection('9. Your Rights Under GDPR',
                                    'As a data subject, you have the following rights:\n• Right of access (Article 15) - obtain copies of your data\n• Right to rectification (Article 16) - correct inaccurate data\n• Right to erasure (Article 17) - request deletion\n• Right to restrict processing (Article 18)\n• Right to data portability (Article 20) - receive data in portable format\n• Right to object (Article 21) - object to processing\n• Right to withdraw consent (Article 7(3))\n• Right not to be subject to automated decision-making (Article 22)\n\nTo exercise these rights, contact us at: [privacy@yourplatform.fr]'),
                                _buildSection(
                                    '10. Data Protection Officer (DPO)',
                                    'For platforms processing large amounts of personal data, we have appointed a Data Protection Officer as required by GDPR Article 37. You may contact our DPO directly for privacy-related matters:\n\nEmail: dpo@[yourplatform].fr\nAddress: [Your French Business Address]'),
                                _buildSection('11. Security Measures',
                                    'We implement appropriate technical and organizational measures to protect your data:\n• End-to-end encryption for sensitive data\n• Secure servers located within the EU\n• Regular security audits and penetration testing\n• Access controls and staff training\n• Incident response procedures\n• Compliance with French cybersecurity requirements\n\nHowever, no system is completely immune to security risks.'),
                                _buildSection('12. Cookies and Tracking',
                                    'We use cookies and similar technologies as permitted by French law (Article 82 of the Data Protection Act). Our cookie policy covers:\n• Essential cookies for platform functionality\n• Analytics cookies (with consent)\n• Marketing cookies (with explicit consent)\n• Third-party cookies from payment processors\n\nYou can manage cookie preferences through your browser settings or our cookie consent tool.'),
                                _buildSection('13. Age Restrictions',
                                    'Our platform is intended for users aged 16 and older, in compliance with GDPR Article 8. Users under 18 may require parental consent for certain activities as per French civil law.'),
                                _buildSection('14. Breach Notification',
                                    'In accordance with GDPR Article 33-34, we will:\n• Notify the French data protection authority (CNIL) within 72 hours of discovering a breach\n• Inform affected users without undue delay if high risk is involved\n• Maintain records of all data breaches'),
                                _buildSection(
                                    '15. Indemnity & Limitation of Liability',
                                    '15.1 Indemnity\nBy using our platform, you agree to indemnify and hold us harmless from claims, damages, and expenses arising from:\n• Your use or misuse of the platform\n• Disputes with other users\n• Breach of this Privacy Policy or Terms of Service\n• Content you submit or illegal activities\n• Non-compliance with French commercial regulations\n\n15.2 Limitation of Liability\nWe provide a marketplace platform and are not responsible for:\n• Quality, legality, or safety of listed products\n• Actions of buyers or sellers\n• Transaction disputes or payment issues\n• Compliance with product safety regulations by sellers\n\nOur liability is limited to the maximum extent permitted by French law.'),
                                _buildSection(
                                    '16. Complaints and Supervisory Authority',
                                    'If you believe we have not handled your personal data in accordance with this policy, you have the right to lodge a complaint with:\n\nCommission Nationale de l\'Informatique et des Libertés (CNIL)\n3 Place de Fontenoy - TSA 80715\n75334 PARIS CEDEX 07\nTelephone: +33 1 53 73 22 22\nWebsite: www.cnil.fr'),
                                _buildSection('17. Changes to This Policy',
                                    'We may update this Privacy Policy to reflect changes in our practices or legal requirements. We will:\n• Notify you of material changes via email or platform notification\n• Publish the updated policy on our website\n• Obtain fresh consent where required by law\n• Maintain previous versions for reference'),
                                _buildSection('18. Contact Information',
                                    'For privacy-related questions, requests, or concerns:\n\nData Controller: [Company Name]\nEmail: privacy@[yourplatform].fr\nAddress: [Your French Business Address]\nPhone: [French Phone Number]\nWebsite: [www.yourplatform.fr]\n\nResponse time: We aim to respond within 30 days as required by GDPR.'),
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
                                          'I have read and agree to the Privacy Policy',
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
                                  onTap: controller.acceptPolicy,
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
