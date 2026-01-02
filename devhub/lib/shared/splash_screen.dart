import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../navigation/app_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _flashController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  
  late Animation<double> _flash;
  late Animation<double> _logoScale;
  late Animation<double> _glowIntensity;
  late Animation<double> _textOpacity;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    
    // Flash animation - quick bright flash
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flash = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 2),
    ]).animate(CurvedAnimation(parent: _flashController, curve: Curves.easeOut));
    
    // Logo slam animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 0.9), weight: 3),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
    
    _glowIntensity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.6), weight: 2),
    ]).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
    
    // Text reveal
    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _textOpacity = CurvedAnimation(parent: _textController, curve: Curves.easeIn);
    
    // Pulse effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulse = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _startAnimations();
  }

  void _startAnimations() async {
    // Brief pause then flash
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Flash and logo slam together
    _flashController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _logoController.forward();
    
    // Pulse while waiting
    _pulseController.repeat(reverse: true);
    
    // Text appears
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
    
    // Navigate after animation
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, _) => const AppNavigation(),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  void dispose() {
    _flashController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          // Flash overlay
          AnimatedBuilder(
            animation: _flash,
            builder: (context, _) => Container(
              color: Colors.white.withOpacity(_flash.value * 0.9),
            ),
          ),
          
          // Energy lines radiating from center
          AnimatedBuilder(
            animation: _logoController,
            builder: (context, _) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _EnergyLinesPainter(
                  progress: _logoController.value,
                  color: AppTheme.primaryColor,
                ),
              );
            },
          ),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with glow
                AnimatedBuilder(
                  animation: Listenable.merge([_logoController, _pulseController]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScale.value * _pulse.value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(_glowIntensity.value * 0.8),
                              blurRadius: 40 * _glowIntensity.value,
                              spreadRadius: 10 * _glowIntensity.value,
                            ),
                            BoxShadow(
                              color: AppTheme.secondaryColor.withOpacity(_glowIntensity.value * 0.5),
                              blurRadius: 60 * _glowIntensity.value,
                              spreadRadius: 20 * _glowIntensity.value,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.code_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 30),
                
                // App name with flash reveal
                FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF00D9FF)],
                        ).createShader(bounds),
                        child: const Text(
                          'DevHub',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'CODE • LEARN • CONNECT',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                          letterSpacing: 6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for energy lines effect
class _EnergyLinesPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  _EnergyLinesPainter({required this.progress, required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.1) return;
    
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final lineCount = 12;
    final maxLength = size.width * 0.6;
    
    for (int i = 0; i < lineCount; i++) {
      final angle = (i / lineCount) * 3.14159 * 2;
      final lineProgress = (progress * 2 - 0.5).clamp(0.0, 1.0);
      final length = maxLength * lineProgress * (1 - (i % 3) * 0.2);
      final opacity = (1 - progress) * 0.6;
      
      paint.color = (i % 2 == 0 ? color : const Color(0xFF00D9FF)).withOpacity(opacity);
      
      final startOffset = 60.0;
      final start = Offset(
        center.dx + startOffset * (1 - lineProgress) * cos(angle),
        center.dy + startOffset * (1 - lineProgress) * sin(angle),
      );
      final end = Offset(
        center.dx + length * cos(angle),
        center.dy + length * sin(angle),
      );
      
      canvas.drawLine(start, end, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant _EnergyLinesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
