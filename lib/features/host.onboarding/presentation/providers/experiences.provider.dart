import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/experience.model.dart';
import '../../data/repositories/experience.repository.dart';

final experiencesProvider = FutureProvider<List<Experience>>((ref) async {
  final repository = ref.watch(experienceRepositoryProvider);
  return repository.fetchExperiences();
});
