import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const WorkPalApp());
}

class WorkPalApp extends StatelessWidget {
  const WorkPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkPal - Connect Artisans & Customers',
      theme: ThemeData(
        primaryColor: const Color(0xff260273),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff260273)),
        useMaterial3: true,
      ),
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isMobile = size.width < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xff260273),
              const Color(0xff260273).withOpacity(0.8),
              const Color(0xff4a0e4e),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.1),
                    
                    // App Icon with Pulse Animation
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: isMobile ? 120 : 150,
                            height: isMobile ? 120 : 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                'assets/AppIconn.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Icon(
                                      Icons.work,
                                      size: 60,
                                      color: const Color(0xff260273),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // App Name
                    Text(
                      'WorkPal',
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 48 : 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tagline
                    Text(
                      'Connect Artisans & Customers Locally',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 18 : 24,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Description
                    Text(
                      'The social media platform where skilled artisans\nmeet customers who need their services',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: size.height * 0.08),

                    // Download Buttons
                    if (isMobile)
                      Column(
                        children: [
                          _buildDownloadButton(
                            'Visit Web App',
                            Icons.web,
                            () => _launchUrl('https://workpalweb.vercel.app'),
                            isMobile,
                          ),
                          const SizedBox(height: 16),
                          _buildDownloadButton(
                            'Download for Android',
                            Icons.android,
                            () => _launchUrl('https://play.google.com/store'),
                            isMobile,
                          ),
                          const SizedBox(height: 16),
                          _buildDownloadButton(
                            'Download for iOS',
                            Icons.apple,
                            () => _launchUrl('https://apps.apple.com'),
                            isMobile,
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDownloadButton(
                            'Visit Web App',
                            Icons.web,
                            () => _launchUrl('https://workpalweb.vercel.app'),
                            isMobile,
                          ),
                          const SizedBox(width: 20),
                          _buildDownloadButton(
                            'Download for Android',
                            Icons.android,
                            () => _launchUrl('https://play.google.com/store'),
                            isMobile,
                          ),
                          const SizedBox(width: 20),
                          _buildDownloadButton(
                            'Download for iOS',
                            Icons.apple,
                            () => _launchUrl('https://apps.apple.com'),
                            isMobile,
                          ),
                        ],
                      ),

                    SizedBox(height: size.height * 0.1),

                    // Footer
                    Text(
                      '© 2024 WorkPal. All rights reserved.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
    bool isMobile,
  ) {
    return Container(
      width: isMobile ? double.infinity : 250,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: const Color(0xff260273),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff260273),
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