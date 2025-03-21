import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _subtitleFadeAnimation;  // Yeni animasyon

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Alt başlık için gecikmeli animasyon
    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: const Icon(
                  Icons.forum_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),

            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'MEYDAN',
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 6,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                )
              /*   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ), */
              ),
            ),
             
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _subtitleFadeAnimation,  // _fadeAnimation yerine _subtitleFadeAnimation kullan
              child: Text(
                'Tartışmaya Açık Ol!',
                style: GoogleFonts.aBeeZee(
                  //letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.tertiary,
                )
               /*  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.amber.shade200,
                ), */
              ),
            ),
          ],
        ),
      ),
    );
  }
}