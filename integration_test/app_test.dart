import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:petfinder/core/di/injection_container.dart';
import 'package:petfinder/core/routing/app_route.dart';
import 'package:petfinder/core/routing/routes.dart';
import 'package:petfinder/core/presentation/cubit/theme_cubit.dart';
import 'package:petfinder/core/theming/theme_data.dart';
import 'package:petfinder/core/widgets/category_chip.dart';
import 'package:petfinder/features/home/presentation/screens/widgets/search_bar.dart';
import 'package:petfinder/features/onboarding/widgets/get_started_button.dart';
import 'package:petfinder/features/home/presentation/screens/widgets/pet_card.dart';
import 'package:petfinder/features/details/presentation/screens/details_screen.dart';
import 'package:petfinder/features/home/data/datasources/pet_remote_data_source.dart';
import 'package:petfinder/features/details/data/datasources/pet_details_remote_data_source.dart';
import 'package:petfinder/features/favourites/data/datsources/favourites_remote_data_source.dart';
import 'fakes/fake_remote_data_sources.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pet Finder App Integration Test', () {

    setUp(() async {

      try {
        await sl.reset();
      } catch (e) {
        debugPrint('GetIt reset error: $e');
      }

      try {
        await Hive.close();
      } catch (e) {
        debugPrint('Hive close error: $e');
      }

      try {
        await Hive.deleteFromDisk();
      } catch (e) {
        debugPrint('Hive delete error: $e');
      }

      await Hive.initFlutter();

      try {
        await dotenv.load(fileName: ".env");
      } catch (e) {
        debugPrint("Could not load .env file: $e");
      }

      await initAll();

      // Register fake data sources
      sl.unregister<PetRemoteDataSource>();
      sl.registerLazySingleton<PetRemoteDataSource>(() => FakePetRemoteDataSource());

      sl.unregister<PetDetailsRemoteDataSource>();
      sl.registerLazySingleton<PetDetailsRemoteDataSource>(() => FakePetDetailsRemoteDataSource());

      sl.unregister<FavouritesRemoteDataSource>();
      sl.registerLazySingleton<FavouritesRemoteDataSource>(() => FakeFavouritesRemoteDataSource());
    });

    tearDown(() async {
      await Hive.close();
      await sl.reset();
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('=== Test teardown completed ===');
    });

    testWidgets('Complete user flow - Onboarding to Add Favorite', (tester) async {
      // Start the app
      await tester.pumpWidget(const TestApp());
      await tester.pumpAndSettle();

      // Verify we're on the onboarding screen
      expect(find.textContaining('Find Your Best'), findsOneWidget);
      expect(find.textContaining('Companion With Us'), findsOneWidget);

      // Find and tap the "Get Started" button
      final getStartedButton = find.byType(GetStartedButton);
      expect(getStartedButton, findsOneWidget);

      await tester.tap(getStartedButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we're on the home screen
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);

      // Wait for pets to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find and tap on the SECOND pet card
      final petCards = find.byType(PetCard);
      expect(petCards, findsAtLeastNWidgets(2));

      // Tap the second pet card (index 1) to view details
      await tester.tap(petCards.at(1));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we're on the details screen
      expect(find.byType(DetailsScreen), findsOneWidget);

      // Wait for ALL content to load
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify screen content is loaded
      expect(find.text('About:'), findsOneWidget);
      expect(find.text('Adopt me'), findsOneWidget);

      // Add the pet to favorites
      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsAtLeastNWidgets(2));

      debugPrint('=== Tapping favorite button to ADD ===');

      // Tap the second GestureDetector (favorite button)
      await tester.tap(gestureDetectors.at(1));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify favorite was added
      debugPrint('=== Checking for filled heart icon ===');

      await tester.pumpAndSettle(const Duration(seconds: 1));
      // Check if the icon changed to filled heart
      final filledHeartFinder = find.byIcon(Icons.favorite);
      debugPrint('Filled heart found: ${filledHeartFinder.evaluate().length}');
      expect(filledHeartFinder, findsOneWidget);

      // Check for snackbar
      debugPrint('=== Checking for snackbar ===');
      final snackbarFinder = find.textContaining('added to favourites');
      debugPrint('Snackbar found: ${snackbarFinder.evaluate().length}');

      // Only check snackbar if it's still visible
      if (snackbarFinder.evaluate().isNotEmpty) {
        expect(snackbarFinder, findsOneWidget);
      } else {
        debugPrint('Snackbar already dismissed - continuing test');
      }

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Remove from favorites to test toggle
      debugPrint('=== Tapping favorite button to REMOVE ===');
      // Tap the favorite button again to remove
      await tester.tap(gestureDetectors.at(1));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify favorite was removed
      debugPrint('=== Checking for border heart icon ===');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      final borderHeartFinder = find.byIcon(Icons.favorite_border);
      debugPrint('Border heart found: ${borderHeartFinder.evaluate().length}');
      expect(borderHeartFinder, findsOneWidget);

      // Check for removal snackbar
      final removeSnackbarFinder = find.textContaining('removed from favourites');
      debugPrint('Remove snackbar found: ${removeSnackbarFinder.evaluate().length}');

      if (removeSnackbarFinder.evaluate().isNotEmpty) {
        expect(removeSnackbarFinder, findsOneWidget);
      } else {
        debugPrint('Snackbar already dismissed - continuing test');
      }

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Navigate back to home screen
      debugPrint('=== Navigating back to home ===');
      final backButton = find.byIcon(Icons.arrow_back_ios_new);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we're back on the home screen
      debugPrint('=== Verifying home screen ===');
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
      expect(find.byType(PetCard), findsAtLeastNWidgets(1));

    });

    testWidgets('Search and add to favorites', (tester) async {
      // Start the app
      await tester.pumpWidget(const TestApp());
      await tester.pumpAndSettle();

      final getStartedButton = find.byType(GetStartedButton);
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final searchBar = find.byType(CustomSearchBar);
      await tester.enterText(searchBar, 'cat');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final firstResult = find.byType(PetCard).first;
      await tester.tap(firstResult);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(DetailsScreen), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('About:'), findsOneWidget);

      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsAtLeastNWidgets(2));

      // Tap favorite button
      await tester.tap(gestureDetectors.at(1));
      // Let all animations and async operations complete
      await tester.pumpAndSettle(const Duration(seconds: 5));
      // Check for the icon
      expect(find.byIcon(Icons.favorite), findsOneWidget);

    });

    testWidgets('Category selection and favorite from details', (tester) async {
      // Start the app
      await tester.pumpWidget(const TestApp());
      await tester.pumpAndSettle();

      final getStartedButton = find.byType(GetStartedButton);
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Find Your Forever Pet'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final catsCategory = find.widgetWithText(CategoryChip, 'Cats');
      expect(catsCategory, findsOneWidget);

      await tester.tap(catsCategory);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(PetCard), findsAtLeastNWidgets(1));

      final catCard = find.byType(PetCard).first;
      await tester.tap(catCard);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(DetailsScreen), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('About:'), findsOneWidget);
      expect(find.text('Adopt me'), findsOneWidget);

      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsAtLeastNWidgets(2));

      debugPrint('=== Tapping favorite button to ADD  ===');

      await tester.tap(gestureDetectors.at(1));

      // Let all animations and async operations complete
      await tester.pumpAndSettle(const Duration(seconds: 5));

      debugPrint('=== Checking for filled heart icon ===');
      final filledHeartFinder = find.byIcon(Icons.favorite);
      debugPrint('Filled heart found: ${filledHeartFinder.evaluate().length}');
      expect(filledHeartFinder, findsOneWidget);

      debugPrint('=== Checking for snackbar  ===');
      final snackbarFinder = find.textContaining('added to favourites');
      debugPrint('Snackbar found: ${snackbarFinder.evaluate().length}');

      if (snackbarFinder.evaluate().isNotEmpty) {
        expect(snackbarFinder, findsOneWidget);
      } else {
        debugPrint('Snackbar already dismissed - continuing test');
      }

      await tester.pumpAndSettle(const Duration(seconds: 1));

      debugPrint('=== Navigating back to home (Cats test) ===');

      final backButton = find.byIcon(Icons.arrow_back_ios_new);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      debugPrint('=== Verifying home screen (Cats test) ===');
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
      expect(find.byType(PetCard), findsAtLeastNWidgets(1));
    });

  });
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ThemeCubit>()..loadSavedTheme(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pet Finder Test',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            initialRoute: Routes.onboardingScreen,
            onGenerateRoute: AppRouter().generateRoute,
          );
        },
      ),
    );
  }
}