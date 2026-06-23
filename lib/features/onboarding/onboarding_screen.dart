import 'package:flutter/material.dart';
import 'package:petfinder/core/routing/routes.dart';
import 'package:petfinder/core/theming/theme_data.dart';
import 'package:petfinder/features/onboarding/widgets/get_started_button.dart';
import 'package:petfinder/features/onboarding/widgets/pet_image_section.dart';

class OnboardingScreen extends StatelessWidget {
  final String environment;

  const OnboardingScreen({
    super.key,
    required this.environment,
  });

  void _onGetStarted(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(Routes.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    final isDev = environment == 'development';
    final titleSuffix = isDev ? '\nDEV' : '';

    return Scaffold(
      backgroundColor: AppTheme.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Pet Image Section
            const PetImageSection(
              imagePath: 'assets/images/pets.png',
            ),

            const SizedBox(height: 20),

            // Title and Description
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Title
                    Text(
                      'Find Your Best\nCompanion With Us$titleSuffix',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary(context),
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      'Join & discover the best suitable pets as\nper your preferences in your location',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondary(context),
                        height: 1.5,
                        letterSpacing: 0.1,
                      ),
                    ),

                    const Spacer(),

                    // Get Started Button
                    GetStartedButton(
                      onPressed: () => _onGetStarted(context),
                    ),

                    const SizedBox(height: 40),

                    // Bottom Indicator
                    Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}