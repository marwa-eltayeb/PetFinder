import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/features/home/presentation/bloc/pet_list_bloc.dart';
import 'package:petfinder/features/home/presentation/bloc/pet_list_event.dart';
import 'package:petfinder/features/home/presentation/screens/widgets/filter_section.dart';

class FilterSheet extends StatelessWidget {
  final List<String> origins;
  final List<String> temperaments;

  const FilterSheet({
    super.key,
    required this.origins,
    required this.temperaments,
  });

  @override
  Widget build(BuildContext context) {
    final petListBloc = context.read<PetListBloc>();
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header with Clear button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Pets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    petListBloc.add(FilterPets());
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),

            FilterSection(
              title: 'Origin',
              items: origins,
              onTap: (origin) {
                petListBloc.add(FilterPets(origin: origin));
                Navigator.pop(context);
              },
            ),

            FilterSection(
              title: 'Temperament',
              items: temperaments,
              onTap: (temperament) {
                petListBloc.add(FilterPets(temperament: temperament));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}