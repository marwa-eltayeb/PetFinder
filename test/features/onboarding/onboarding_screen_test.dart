import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petfinder/features/onboarding/onboarding_screen.dart';
import 'package:petfinder/core/utils/config.dart';

void main() {

  group('OnboardingScreen Widget Tests', () {

    setUp(() {
      Config.environment = 'development';
    });

    testWidgets('should display all text content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(environment: 'development'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Text), findsWidgets);

      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, greaterThanOrEqualTo(2));
    });

    testWidgets('should contain SafeArea widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(environment: 'development'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SafeArea), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display pet images', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(environment: 'development'),
        ),
      );

      await tester.pumpAndSettle();

      final images = find.byType(Image);
      expect(images, findsWidgets);

      final imageCount = images.evaluate().length;
      expect(imageCount, greaterThanOrEqualTo(1));
    });

    testWidgets('should display action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(environment: 'development'),
        ),
      );

      await tester.pumpAndSettle();

      final hasElevatedButton = find.byType(ElevatedButton).evaluate().isNotEmpty;
      final hasTextButton = find.byType(TextButton).evaluate().isNotEmpty;

      expect(hasElevatedButton || hasTextButton, isTrue);
    });

    testWidgets('should show DEV indicator in development mode', (WidgetTester tester) async {
      Config.environment = 'development';

      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(environment: 'development'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('DEV'), findsOneWidget);
    });

  });
}