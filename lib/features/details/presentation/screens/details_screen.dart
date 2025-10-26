import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/core/di/injection_container.dart';
import 'package:petfinder/core/utils/app_colors.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/core/utils/snackbar_helper.dart';
import '../bloc/pet_details_bloc.dart';
import '../bloc/pet_details_event.dart';
import '../bloc/pet_details_states.dart';
import 'widgets/info_card.dart';

class DetailsScreen extends StatefulWidget {
  final PetType type;
  final dynamic petId;

  const DetailsScreen({Key? key, required this.type, required this.petId})
      : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final PetDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<PetDetailsBloc>();
    _bloc.add(LoadPetDetails(widget.type, widget.petId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<PetDetailsBloc, PetDetailsState>(
            builder: (context, state) {
              if (state is PetDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PetDetailsLoaded) {
                final pet = state.details;

                return Column(
                  children: [
                    // Header with image
                    Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Container(
                          height: 380,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F8F6),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Center(
                            child: pet.imageUrl != null
                                ? Image.network(
                              pet.imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 380,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                              const Icon(
                                Icons.pets,
                                size: 100,
                                color: AppColors.primary,
                              ),
                            )
                                : const Icon(
                              Icons.pets,
                              size: 100,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 16,
                          child: const Icon(
                            Icons.favorite,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    // Details section
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name and Price Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      pet.name,
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${'35'}',
                                    style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    pet.origin ?? 'Unknown location',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: InfoCard(
                                      title: 'Gender',
                                      value: 'Unknown',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: InfoCard(
                                      title: 'Age',
                                      value: pet.lifeSpan ?? 'Unknown',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: InfoCard(
                                      title: 'Weight',
                                      value: pet.weight ?? 'Unknown',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'About:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                pet.description ?? 'No description available',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    SnackBarHelper.showInfo(
                                        context, "Adopting ${pet.name}...");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Adopt me',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is PetDetailsError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}