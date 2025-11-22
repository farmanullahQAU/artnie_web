import 'dart:math' as math;
import 'dart:ui'; // For image filters and backdrop filter

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/app_constants.dart';
import 'controllers/home_controller.dart';
import 'controllers/navigation_controller.dart';

// --- HELPER FUNCTIONS ---
Future<void> openPlayStore() async {
  final Uri url = Uri.parse(AppConstants.googlePlayUrl);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

Future<void> openUrl(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

// --- ENTRY POINT ---
void main() {
  // Initialize GetX controllers
  Get.put(HomeController());
  Get.put(NavigationController());

  runApp(const ArtnieApp());
}

// --- MAIN APP WIDGET ---
class ArtnieApp extends StatelessWidget {
  const ArtnieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppConstants.background,
        primaryColor: AppConstants.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppConstants.primary,
          secondary: AppConstants.accent,
          surface: AppConstants.surface,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: AppConstants.displayLargeSize,
            fontWeight: FontWeight.w900,
            color: AppConstants.textWhite,
            letterSpacing: -2.0,
            height: 1.1,
          ),
          displayMedium: TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: AppConstants.displayMediumSize,
            fontWeight: FontWeight.w800,
            color: AppConstants.textWhite,
            letterSpacing: -1.0,
          ),
          bodyLarge: TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: AppConstants.bodyLargeSize,
            color: AppConstants.textGrey,
            height: 1.6,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// --- RESPONSIVE LAYOUT HELPER ---
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 700 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop;
        } else if (constraints.maxWidth >= 700) {
          return tablet ?? desktop;
        } else {
          return mobile;
        }
      },
    );
  }
}

// --- HOME PAGE ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final navController = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: AppConstants.background,
      extendBodyBehindAppBar: true,
      appBar: ResponsiveLayout.isMobile(context)
          ? AppBar(
              backgroundColor: AppConstants.background.withOpacity(0.7),
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.transparent),
                ),
              ),
              elevation: 0,
              centerTitle: false,

              title: //for mobile or table make it right aligned
                  ResponsiveLayout.isMobile(context) ||
                      ResponsiveLayout.isTablet(context)
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: _LogoText(fontSize: 22),
                    )
                  : _LogoText(fontSize: 22),
              iconTheme: const IconThemeData(color: Colors.white),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(90),
              child: DesktopNavBar(
                onScrollToFeatures: navController.scrollToFeatures,
                onScrollToRoadmap: navController.scrollToRoadmap,
                onScrollToDownload: navController.scrollToDownload,
              ),
            ),
      drawer: ResponsiveLayout.isMobile(context)
          ? MobileDrawer(
              onScrollToFeatures: () =>
                  navController.scrollToFeatures(closeDrawer: true),
              onScrollToRoadmap: () =>
                  navController.scrollToRoadmap(closeDrawer: true),
              onScrollToDownload: () =>
                  navController.scrollToDownload(closeDrawer: true),
            )
          : null,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            HeroSection(onDownloadTap: navController.scrollToDownload),

            _SectionDivider(),
            // --- NEW TESTIMONIALS SECTION INTEGRATED HERE ---
            Container(key: homeController.featuresKey),
            const FeaturesSection(),

            _SectionDivider(),

            Container(key: homeController.roadmapKey),
            const RoadmapSection(),

            _SectionDivider(),
            const TestimonialsSection(),

            Container(
              key: homeController.downloadKey,
              child: const CallToActionSection(),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // A subtle gradient divider
    return Container(
      height: 1,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppConstants.primary.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _LogoText extends StatelessWidget {
  final double fontSize;
  const _LogoText({this.fontSize = 28});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          // decoration: BoxDecoration(
          //   gradient: AppConstants.primaryGradient,
          //   borderRadius: BorderRadius.circular(10),
          //   boxShadow: [
          //     BoxShadow(
          //       color: AppConstants.primary.withOpacity(0.4),
          //       blurRadius: 12,
          //     ),
          //   ],
          // ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              'assets/appIcon.png',
              width: 55,
              height: 55,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        Text(
          AppConstants.appName,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

// --- NAVIGATION ---

class DesktopNavBar extends StatelessWidget {
  final VoidCallback onScrollToFeatures;
  final VoidCallback onScrollToRoadmap;
  final VoidCallback onScrollToDownload;

  const DesktopNavBar({
    super.key,
    required this.onScrollToFeatures,
    required this.onScrollToRoadmap,
    required this.onScrollToDownload,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          decoration: BoxDecoration(
            color: AppConstants.background.withOpacity(0.6),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppConstants.maxContentWidth,
              ),
              child: Row(
                children: [
                  const _LogoText(),
                  const Spacer(),
                  _NavItem(
                    title: AppConstants.navItems[0],
                    onTap: onScrollToFeatures,
                  ),
                  const SizedBox(width: 40),
                  _NavItem(
                    title: AppConstants.navItems[1],
                    onTap: onScrollToRoadmap,
                  ),
                  const SizedBox(width: 50),
                  _GradientButton(
                    text: AppConstants.navDownloadButton,
                    onTap: openPlayStore,
                    isSmall: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem({required this.title, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isHovered ? AppConstants.accent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              color: isHovered ? Colors.white : Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: 15,
              fontFamily: AppConstants.fontFamily,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class MobileDrawer extends StatelessWidget {
  final VoidCallback onScrollToFeatures;
  final VoidCallback onScrollToRoadmap;
  final VoidCallback onScrollToDownload;

  const MobileDrawer({
    super.key,
    required this.onScrollToFeatures,
    required this.onScrollToRoadmap,
    required this.onScrollToDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppConstants.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppConstants.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const _LogoText(),
                const SizedBox(height: 12),
                Text(
                  AppConstants.appVersion,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontFamily: 'Monospace',
                  ),
                ),
              ],
            ),
          ),
          _DrawerTile(
            icon: Icons.star_outline,
            title: AppConstants.navItems[0],
            onTap: onScrollToFeatures,
          ),
          _DrawerTile(
            icon: Icons.map_outlined,
            title: AppConstants.navItems[1],
            onTap: onScrollToRoadmap,
          ),
          const Divider(color: Colors.white10),
          _DrawerTile(
            icon: Icons.download_rounded,
            title: "Get App",
            onTap: openPlayStore,
            color: AppConstants.accent,
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white70),
      title: Text(
        title,
        style: TextStyle(color: color ?? Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}

// --- SECTIONS ---

class HeroSection extends StatelessWidget {
  final VoidCallback onDownloadTap;
  const HeroSection({super.key, required this.onDownloadTap});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background Elements
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppConstants.primary.withOpacity(0.15),
              // filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppConstants.accent.withOpacity(0.05),
              // filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            ),
          ),
        ),

        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: isDesktop ? screenHeight * 0.9 : screenHeight * 0.85,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 100 : 24,
            vertical: isDesktop ? 120 : 80,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppConstants.maxContentWidth,
              ),
              child: Flex(
                direction: isDesktop ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text Content
                  Expanded(
                    flex: isDesktop ? 5 : 0,
                    child: Column(
                      crossAxisAlignment: isDesktop
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppConstants.accent.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(50),
                            color: AppConstants.accent.withOpacity(0.05),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bolt,
                                color: AppConstants.accent,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                AppConstants.heroBadgeText,
                                style: TextStyle(
                                  color: AppConstants.accent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Title with proper mobile alignment
                        isDesktop
                            ? RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: AppConstants.heroTitleLine1,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.displayLarge,
                                    ),
                                    WidgetSpan(
                                      child: ShaderMask(
                                        shaderCallback: (rect) => AppConstants
                                            .primaryGradient
                                            .createShader(rect),
                                        child: Text(
                                          AppConstants.heroTitleLine2,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.displayLarge,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppConstants.heroTitleLine1.trim(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          fontSize: 42,
                                          height: 1.1,
                                          letterSpacing: -1.0,
                                        ),
                                  ),
                                  ShaderMask(
                                    shaderCallback: (rect) => AppConstants
                                        .primaryGradient
                                        .createShader(rect),
                                    child: Text(
                                      AppConstants.heroTitleLine2,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                            fontSize: 42,
                                            height: 1.1,
                                            letterSpacing: -1.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 24),
                        Text(
                          AppConstants.heroSubtitle,
                          textAlign: isDesktop
                              ? TextAlign.left
                              : TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 48),
                        Wrap(
                          alignment: isDesktop
                              ? WrapAlignment.start
                              : WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _GradientButton(
                              text: AppConstants.heroCtaPrimary,
                              icon: Icons.android,
                              onTap: openPlayStore,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: isDesktop
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppConstants.warning,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppConstants.heroRating,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Visual Content
                  if (isDesktop) const Spacer(flex: 1),
                  if (!isDesktop) const SizedBox(height: 80),

                  Expanded(flex: isDesktop ? 6 : 0, child: _HeroVisual3D()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroVisual3D extends StatefulWidget {
  @override
  State<_HeroVisual3D> createState() => _HeroVisual3DState();
}

class _HeroVisual3DState extends State<_HeroVisual3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Main Phone Frame Simulation
              Transform.translate(
                offset: Offset(0, 8 * math.sin(_controller.value * math.pi)),
                child: Transform.rotate(
                  angle: -0.05,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    // width: 500,
                    // height: 600,
                    child: Image.asset(
                      'assets/artnie_1.png',
                      // cacheWidth: 500,
                      // cacheHeight: 600,
                      filterQuality: FilterQuality.medium,
                    ),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(40),
                    //   color: AppConstants.surface,
                    //   border: Border.all(
                    //     color: Colors.white.withOpacity(0.1),
                    //     width: 2,
                    //   ),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: AppConstants.primary.withOpacity(0.3),
                    //       blurRadius: 60,
                    //       spreadRadius: -10,
                    //     ),
                    //     BoxShadow(
                    //       color: Colors.black.withOpacity(0.5),
                    //       blurRadius: 30,
                    //       offset: const Offset(0, 20),
                    //     ),
                    //   ],
                    //   image: const DecorationImage(
                    //     image: AssetImage('assets/artnie_1.png'),
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                  ),
                ),
              ),

              // Floating Feature Cards
              Positioned(
                right: -100,
                bottom: 120 + (10 * _controller.value),
                child: _FloatingGlassCard(
                  icon: Icons.auto_fix_high,
                  title: "Coming Soon",
                  subtitle: "AI Enhanced",
                  color: AppConstants.accent,
                ),
              ),
              // Positioned(
              //   left: -130,
              //   top: 180 - (8 * _controller.value),
              //   child: _FloatingGlassCard(
              //     icon: Icons.layers,
              //     title: "Smart Layers",
              //     subtitle: "Non-destructive editing",
              //     color: AppConstants.primary,
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}

class _FloatingGlassCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _FloatingGlassCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.surfaceHighlight.withOpacity(0.7),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 24,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Column(
            children: [
              Text(
                AppConstants.featuresTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              Text(
                AppConstants.featuresSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 80),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Show 3 columns on desktop, 2 on tablet, 1 on mobile
                  int crossAxisCount = ResponsiveLayout.isDesktop(context)
                      ? 3
                      : (ResponsiveLayout.isTablet(context) ? 2 : 1);
                  double spacing = 30;

                  double cardWidth =
                      (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                      crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    alignment: WrapAlignment.center,
                    children: AppConstants.features
                        .map(
                          (feature) => _FeatureCard(
                            icon: feature.icon,
                            title: feature.title,
                            description: feature.description,
                            width: cardWidth,
                            color: feature.color,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- NEW ROADMAP SECTION ---
class RoadmapSection extends StatelessWidget {
  const RoadmapSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 120 : 80,
        horizontal: isDesktop ? 100 : 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.background,
            AppConstants.surface.withOpacity(0.3),
            AppConstants.background,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Column(
            children: [
              // Header Section
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.primary.withOpacity(0.15),
                          AppConstants.accent.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppConstants.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timeline,
                          color: AppConstants.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppConstants.roadmapBadge,
                          style: TextStyle(
                            color: AppConstants.primary,
                            fontSize: 12,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    AppConstants.roadmapTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: isDesktop ? 600 : double.infinity,
                    child: Text(
                      AppConstants.roadmapSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppConstants.textGrey,
                        height: 1.7,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),

              // Roadmap Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  // Show 3 columns on desktop, 2 on tablet, 1 on mobile
                  int crossAxisCount = ResponsiveLayout.isDesktop(context)
                      ? 3
                      : (ResponsiveLayout.isTablet(context) ? 2 : 1);
                  double spacing = 30;

                  double cardWidth =
                      (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                      crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    alignment: WrapAlignment.center,
                    children: AppConstants.roadmapItems
                        .asMap()
                        .entries
                        .map(
                          (entry) => _RoadmapCard(
                            width: cardWidth,
                            title: entry.value.title,
                            description: entry.value.description,
                            status: entry.value.status,
                            icon: entry.value.icon,
                            progress: entry.value.progress,
                            index: entry.key,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoadmapCard extends StatefulWidget {
  final double width;
  final String title;
  final String description;
  final String status;
  final IconData icon;
  final double progress;
  final int index;

  const _RoadmapCard({
    required this.width,
    required this.title,
    required this.description,
    required this.status,
    required this.icon,
    required this.progress,
    required this.index,
  });

  @override
  State<_RoadmapCard> createState() => _RoadmapCardState();
}

class _RoadmapCardState extends State<_RoadmapCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Color getStatusColor() {
    if (widget.progress > 0.8) return AppConstants.accent;
    if (widget.progress > 0.5) return AppConstants.primary;
    return AppConstants.warning;
  }

  String getStatusIcon() {
    if (widget.progress > 0.8) return '🚀';
    if (widget.progress > 0.5) return '⚡';
    return '📋';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor();

    return RepaintBoundary(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: AppConstants.animationDuration,
            curve: Curves.easeOutCubic,
            width: widget.width,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.surfaceHighlight,
                  AppConstants.surfaceHighlight.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isHovered
                    ? statusColor.withOpacity(0.4)
                    : Colors.white.withOpacity(0.08),
                width: isHovered ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                if (isHovered)
                  BoxShadow(
                    color: statusColor.withOpacity(0.2),
                    blurRadius: 40,
                    offset: const Offset(0, 12),
                  ),
              ],
            ),
            transform: Matrix4.identity()
              ..translate(0.0, isHovered ? -8.0 : 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Icon Container
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            statusColor.withOpacity(0.2),
                            statusColor.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(widget.icon, color: statusColor, size: 28),
                    ),
                    const Spacer(),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: statusColor.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            getStatusIcon(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  widget.description,
                  style: TextStyle(
                    color: AppConstants.textGrey,
                    fontSize: 15,
                    height: 1.6,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CallToActionSection extends StatelessWidget {
  const CallToActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppConstants.maxContentWidth,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          padding: const EdgeInsets.all(1), // For gradient border
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
              colors: [
                AppConstants.primary.withOpacity(0.5),
                AppConstants.accent.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A10),
              borderRadius: BorderRadius.circular(39),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.rocket_launch,
                  color: AppConstants.accent,
                  size: 48,
                ),
                const SizedBox(height: 24),
                Text(
                  AppConstants.ctaTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.ctaSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                ),
                const SizedBox(height: 40),
                _GradientButton(
                  text: AppConstants.ctaButtonText,
                  icon: Icons.android,
                  onTap: openPlayStore,
                  isLarge: true,
                ),
                const SizedBox(height: 20),
                Text(
                  AppConstants.ctaFooter,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 40, left: 40, right: 40),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        color: const Color(0xFF020205),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Column(
            children: [
              const _LogoText(fontSize: 24),
              const SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 40,
                runSpacing: 20,
                children: AppConstants.footerLinks
                    .map((link) => _FooterLink(link))
                    .toList(),
              ),
              const SizedBox(height: 60),
              Text(
                "© ${AppConstants.copyrightYear} ${AppConstants.companyName}. All rights reserved.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);

  String? _getUrlForLink(String linkText) {
    switch (linkText) {
      case 'Privacy Policy':
        return AppConstants.privacyPolicyUrl;
      case 'Terms of Service':
        return AppConstants.termsOfServiceUrl;
      case 'Developer':
        return AppConstants.developerPortfolioUrl;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = _getUrlForLink(text);
    return InkWell(
      onTap: url != null ? () => openUrl(url) : null,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 15,
          decoration: url != null ? TextDecoration.underline : null,
          decorationColor: Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}

// --- WIDGET HELPERS ---

class _GradientButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isSmall;
  final bool isLarge;

  const _GradientButton({
    required this.text,
    this.icon,
    required this.onTap,
    this.isSmall = false,
    this.isLarge = false,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    double paddingH = widget.isSmall ? 20 : (widget.isLarge ? 40 : 32);
    double paddingV = widget.isSmall ? 12 : (widget.isLarge ? 22 : 18);
    double fontSize = widget.isSmall ? 14 : (widget.isLarge ? 18 : 16);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => controller.forward(),
      onExit: (_) => controller.reverse(),
      child: ScaleTransition(
        scale: scaleAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: paddingH,
              vertical: paddingV,
            ),
            decoration: BoxDecoration(
              gradient: AppConstants.primaryGradient,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: fontSize + 4),
                  const SizedBox(width: 12),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          decoration: BoxDecoration(
            color: isHovered
                ? Colors.white.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white70),
              const SizedBox(width: 12),
              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final double width;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.width,
    required this.color,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: AppConstants.animationDuration,
        width: widget.width,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppConstants.surfaceHighlight,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered
                ? widget.color.withOpacity(0.5)
                : Colors.white.withOpacity(0.05),
          ),
          boxShadow: [
            if (isHovered)
              BoxShadow(
                color: widget.color.withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(widget.icon, size: 28, color: widget.color),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.6),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- DUMMY CONSTANTS FOR TESTIMONIALS (For this file's context only) ---
class DummyTestimonial {
  final String quote;
  final String name;
  final String role;
  // In a real project, AppConstants.dart would hold the actual data
  const DummyTestimonial(this.quote, this.name, this.role);
}

const List<DummyTestimonial> dummyTestimonials = [
  DummyTestimonial(
    "Artnie transformed my editing workflow. The AI tools are incredibly powerful and easy to use. A must-have for any creative!",
    "Alexia Chen",
    "Digital Artist & Influencer",
  ),
  DummyTestimonial(
    "The non-destructive editing is a game-changer. It feels like a desktop app on my phone. Highly recommend for professional use.",
    "Marcus Jones",
    "Professional Photographer",
  ),
  DummyTestimonial(
    "Fast, intuitive, and the best interface I’ve seen on a mobile editor. It makes complex tasks feel simple.",
    "Sofia Rodriguez",
    "UI/UX Designer",
  ),
  DummyTestimonial(
    "Fast, intuitive, and the best interface I’ve seen on a mobile editor. It makes complex tasks feel simple.",
    "Sofia Rodriguez",
    "UI/UX Designer",
  ),
  DummyTestimonial(
    "Fast, intuitive, and the best interface I’ve seen on a mobile editor. It makes complex tasks feel simple.",
    "Sofia Rodriguez",
    "UI/UX Designer",
  ),
];

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 120 : 80,
        horizontal: isDesktop ? 100 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Column(
            children: [
              // Header
              const Icon(
                Icons.format_quote_rounded,
                color: AppConstants.accent,
                size: 40,
              ),
              const SizedBox(height: 16),
              Text(
                "Trusted by Creators Worldwide", // Placeholder for AppConstants.testimonialsTitle
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: isDesktop ? 600 : double.infinity,
                child: Text(
                  "Hear what our users are saying about the power and simplicity of Artnie.", // Placeholder for AppConstants.testimonialsSubtitle
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(height: 80),

              // Testimonials Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  // Show 3 columns on desktop, 2 on tablet, 1 on mobile
                  int crossAxisCount = ResponsiveLayout.isDesktop(context)
                      ? 3
                      : (ResponsiveLayout.isTablet(context) ? 2 : 1);
                  double spacing = 30;

                  double cardWidth =
                      (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                      crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    alignment: WrapAlignment.center,
                    children:
                        dummyTestimonials // Using dummy list here
                            .map(
                              (testimonial) => _TestimonialCard(
                                testimonial: testimonial,
                                width: cardWidth,
                              ),
                            )
                            .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final DummyTestimonial testimonial;
  final double width;

  const _TestimonialCard({required this.testimonial, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(
          0xFF1E1E28,
        ).withOpacity(0.8), // Placeholder for AppConstants.surfaceLight
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rate_rounded,
            color: AppConstants.warning,
            size: 20,
          ),
          const SizedBox(height: 20),
          Text(
            '“${testimonial.quote}”',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              // Placeholder for Avatar Image
              // ClipOval(
              //   child: Image.asset(
              //     testimonial.avatarAsset,
              //     width: 40,
              //     height: 40,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              // const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testimonial.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    testimonial.role,
                    style: TextStyle(
                      color: AppConstants.textGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// --- EN