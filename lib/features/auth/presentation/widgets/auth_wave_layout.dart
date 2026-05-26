import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class AuthWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 32);
    path.cubicTo(
      size.width * 0.15, 8,
      size.width * 0.35, 0,
      size.width * 0.5, 22,
    );
    path.cubicTo(
      size.width * 0.65, 44,
      size.width * 0.82, 20,
      size.width, 14,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(AuthWaveClipper oldClipper) => false;
}

class AuthWaveLayout extends StatelessWidget {
  const AuthWaveLayout({
    super.key,
    required this.title,
    required this.content,
    this.showBack = false,
    this.headerRatio = 0.36,
  });

  final String title;
  final Widget content;
  final bool showBack;
  final double headerRatio;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * headerRatio;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.deepGreen,
      body: Stack(
        children: [
          // Decorative blobs
          Positioned(top: -50, right: -50,
              child: _blob(220, Colors.white.withOpacity(0.07))),
          Positioned(top: 50, right: 36,
              child: _blob(90, Colors.white.withOpacity(0.10))),
          Positioned(top: 130, left: -35,
              child: _blob(130, Colors.white.withOpacity(0.06))),
          Positioned(top: 18, left: 55,
              child: _blob(44, Colors.white.withOpacity(0.13))),
          Positioned(top: headerHeight * 0.6, right: 16,
              child: _blob(56, Colors.white.withOpacity(0.08))),

          // Layout
          Column(
            children: [
              // Green header section
              SizedBox(
                height: headerHeight,
                child: SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      if (showBack)
                        Positioned(
                          top: 0,
                          left: 4,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => context.pop(),
                          ),
                        ),
                      Positioned(
                        bottom: 32,
                        left: 32,
                        right: 32,
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // White wave section
              Expanded(
                child: ClipPath(
                  clipper: AuthWaveClipper(),
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                          32, 48, 32, 24 + bottomPad),
                      child: content,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}
