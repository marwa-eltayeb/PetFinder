import 'package:flutter/material.dart';
import 'package:petfinder/core/routing/routes.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/core/widgets/placeholder_screen.dart';
import 'package:petfinder/features/details/presentation/screens/details_screen.dart';
import 'package:petfinder/features/favourites/presentation/screens/favorites_screen.dart';
import 'package:petfinder/features/home/presentation/screens/home_screen.dart';
import 'package:petfinder/features/onboarding/onboarding_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen(),);

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.detailsScreen:
        final args = settings.arguments;
        if (args is! Map<String, dynamic>) {
          return _errorRoute(settings.name);
        }
        final type = args['type'] as PetType;
        final petId = args['petId'];
        final imageId = args['imageId'] as String?;
        final imageUrl = args['imageUrl'] as String?;
        return MaterialPageRoute(
          builder: (_) => DetailsScreen(type: type, petId: petId, imageId: imageId, imageUrl: imageUrl),
        );

      case Routes.favoritesScreen:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());

      case Routes.placeholderScreen:
        final placeholderArgs = settings.arguments;
        if (placeholderArgs is! Map<String, dynamic>) {
          return _errorRoute(settings.name);
        }
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            title: placeholderArgs['title'],
            currentIndex: placeholderArgs['currentIndex'],
          ),
        );

      default:
        return _errorRoute(settings.name);
    }
  }

  Route _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for $routeName'),
        ),
      ),
    );
  }
}
