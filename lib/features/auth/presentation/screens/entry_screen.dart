import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/budgeta_logo.dart';
import '../widgets/auth_wave_layout.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
          Positioned(top: screenHeight * 0.28, right: 20,
              child: _blob(60, Colors.white.withOpacity(0.08))),
          Positioned(top: screenHeight * 0.15, left: 20,
              child: _blob(30, Colors.white.withOpacity(0.10))),

          // Logo top-left
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, vertical: AppSpacing.md),
              child: BudgetaLogo(iconSize: 32),
            ),
          ),

          // Main structure
          Column(
            children: [
              // Green section — logo centered
              SizedBox(
                height: screenHeight * 0.58,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 110,
                      height: 110,
                    ),
                  ),
                ),
              ),

              // White wave section
              Expanded(
                child: ClipPath(
                  clipper: AuthWaveClipper(),
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(32, 44, 32, 20 + bottomPad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Track. Plan.\nSave. Grow.',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.25,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Take control of your finances with\nsimple, smart budget tracking.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => context.push(RouteNames.login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepGreen,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.buttonRadius),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Log In'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => context.push(RouteNames.register),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.buttonRadius),
                            ),
                            side: const BorderSide(color: AppColors.deepGreen),
                            foregroundColor: AppColors.deepGreen,
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Sign Up'),
                        ),
                        const SizedBox(height: 8),
                      ],
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
