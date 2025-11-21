import 'package:flutter/material.dart';

/// App-wide constants for easy updates
class AppConstants {
  // App Information
  static const String appName = 'Artnie';
  static const String appTitle = 'Artnie - Smart & Easy Design App';
  static const String appVersion = 'v2.0.0 (Beta)';
  static const String appDescription =
      'Create posters, invitations, cards, flyers, and social media posts in just a few taps. Design anything — even offline after your data is loaded once.';
  static const String companyName = 'Artnie App';
  static const String copyrightYear = '2025';

  // Colors
  static const Color background = Color(0xFF05050A); // Deepest Black
  static const Color surface = Color(0xFF0F0F16); // Dark surface
  static const Color surfaceHighlight = Color(0xFF1A1A24); // Lighter surface
  static const Color primary = Color(0xFF7000FF); // Electric Purple
  static const Color accent = Color(0xFF00E5FF); // Cyan
  static const Color warning = Color(0xFFFFD600); // Gold for "In Progress"
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFA0A0B0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7000FF), Color(0xFF9D46FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient textGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFE0E0FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Typography
  static const String fontFamily = 'Sans';
  static const double displayLargeSize = 64.0;
  static const double displayMediumSize = 40.0;
  static const double bodyLargeSize = 18.0;

  // Spacing
  static const double spacingXS = 8.0;
  static const double spacingS = 12.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  static const double spacingXXXL = 60.0;
  static const double spacingHuge = 80.0;
  static const double spacingMassive = 100.0;

  // Responsive Breakpoints
  static const double mobileBreakpoint = 700.0;
  static const double tabletBreakpoint = 1100.0;
  static const double maxContentWidth =
      1400.0; // Max width for very large screens

  // Hero Section
  static const String heroBadgeText = 'Smart & Easy Design';
  static const String heroTitleLine1 = 'Design Like a Pro\n';
  static const String heroTitleLine2 = 'Anytime, Anywhere.';
  static const String heroSubtitle =
      'Create stunning posters, invitations, cards, flyers, and social media posts in just a few taps. Hundreds of ready-to-use templates and simple editing tools — works offline too!';
  static const String heroCtaPrimary = 'Get on Google Play';
  static const String heroCtaSecondary = 'View Changelog';
  static const String heroRating = '4.9/5 rating based on 10k+ reviews';

  // Features Section
  static const String featuresTitle = 'Everything You Need to Design';
  static const String featuresSubtitle =
      'Powerful features that make design simple, fast, and accessible to everyone.';

  // Feature Cards
  static const List<FeatureCardData> features = [
    FeatureCardData(
      icon: Icons.dashboard_customize,
      title: 'Hundreds of Templates',
      description:
          'Beautiful ready-to-use templates for birthdays, weddings, business promotions, job posts, school events, and more.',
      color: Color(0xFF2196F3),
    ),
    FeatureCardData(
      icon: Icons.edit,
      title: 'Complete Design Freedom',
      description:
          'Edit text, colors, fonts, icons, and images with a clean, user-friendly interface. Start from scratch or customize templates.',
      color: primary,
    ),
    FeatureCardData(
      icon: Icons.offline_bolt,
      title: 'Works Offline',
      description:
          'Design anytime, anywhere — even without internet after your data is loaded once. Save locally or use built-in backup.',
      color: Color(0xFFFF4081),
    ),
  ];

  // Roadmap Section
  static const String roadmapBadge = 'ROADMAP';
  static const String roadmapTitle = 'What\'s Coming Next';
  static const String roadmapSubtitle =
      'Our commitment to innovation drives continuous improvement. Explore upcoming features designed to elevate your creative workflow.';

  // Roadmap Cards
  static const List<RoadmapCardData> roadmapItems = [
    RoadmapCardData(
      title: 'AI-Powered Design Creation',
      description:
          'Create stunning, fully editable designs with AI assistance. Generate professional layouts, color schemes, and compositions tailored to your needs in seconds. Perfect for posters, invitations, cards, and social media posts.',
      status: 'In Development',
      icon: Icons.auto_awesome,
      progress: 0.75,
    ),
    RoadmapCardData(
      title: 'Multi-Language Support',
      description:
          'Access Artnie in your native language. Full localization for 20+ languages including RTL support for Arabic, Hebrew, and more. Design in the language you\'re most comfortable with.',
      status: 'Coming Soon',
      icon: Icons.language,
      progress: 0.65,
    ),
    RoadmapCardData(
      title: 'Professional Built-in Templates',
      description:
          'Expanding our library with thousands of professionally designed templates. From birthdays and weddings to business promotions and school events — all fully customizable with custom canvas sizes (square, portrait, landscape).',
      status: 'In Development',
      icon: Icons.dashboard_customize,
      progress: 0.85,
    ),
  ];

  // CTA Section
  static const String ctaTitle = 'Start Creating Beautiful Designs';
  static const String ctaSubtitle =
      'Perfect for business owners, students, and creative users. Design like a pro — anytime, anywhere.';
  static const String ctaButtonText = 'Download on Google Play';
  static const String ctaFooter = 'Free Forever • No Credit Card Required';

  // Footer
  static const List<String> footerLinks = [
    // 'Features',
    // 'Roadmap',
    'Privacy Policy',
    'Terms of Service',
    'Developer',
    // 'Twitter',
    // 'Instagram',
  ];

  // Navigation
  static const List<String> navItems = ['Features', 'Roadmap'];
  static const String navDownloadButton = 'Download';

  // URLs
  static const String googlePlayUrl =
      'https://play.google.com/store/apps/details?id=com.inkkaro.app&pcampaignid=web_share';
  static const String heroImageUrl =
      'https://images.unsplash.com/photo-1611162617474-5b21e879e113?auto=format&fit=crop&q=80&w=1000';

  static const String privacyPolicyUrl =
      'https://sites.google.com/view/privacy-policy-artnie/home';
  static const String termsOfServiceUrl =
      'https://sites.google.com/view/terms-of-service-artnie/home';
  static const String developerPortfolioUrl = 'https://farmanullah.web.app';

  // Animation Durations
  static const Duration scrollDuration = Duration(milliseconds: 1000);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration buttonAnimationDuration = Duration(milliseconds: 100);
  static const Duration heroAnimationDuration = Duration(seconds: 5);

  // Hero Visual
  static const double heroPhoneWidth = 320.0;
  static const double heroPhoneHeight = 600.0;
  static const double heroPhoneBorderRadius = 40.0;

  // Padding
  static const EdgeInsets desktopPadding = EdgeInsets.symmetric(
    horizontal: 100,
    vertical: 120,
  );
  static const EdgeInsets mobilePadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 80,
  );
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: 100,
    vertical: 100,
  );
  static const EdgeInsets mobileSectionPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 100,
  );
}

/// Feature card data model
class FeatureCardData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const FeatureCardData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

/// Roadmap card data model
class RoadmapCardData {
  final String title;
  final String description;
  final String status;
  final IconData icon;
  final double progress;

  const RoadmapCardData({
    required this.title,
    required this.description,
    required this.status,
    required this.icon,
    required this.progress,
  });
}
