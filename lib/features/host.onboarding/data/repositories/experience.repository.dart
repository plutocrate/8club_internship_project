import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio.client.dart';
import '../models/experience.model.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final experienceRepositoryProvider = Provider<ExperienceRepository>((ref) {
  return ExperienceRepository(ref.read(dioClientProvider));
});

class ExperienceRepository {
  final DioClient _client;

  ExperienceRepository(this._client);

  Future<List<Experience>> fetchExperiences() async {
    try {
      final response = await _client.get<Map<String, dynamic>>('/v1/experiences');
      final data = response.data!['data'] as Map<String, dynamic>;
      final list = data['experiences'] as List<dynamic>;
      return list
          .map((e) => Experience.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));
    } catch (_) {
      return _mockExperiences;
    }
  }

  static final List<Experience> _mockExperiences = [
    const Experience(
      id: 23,
      name: 'Party',
      tagline: '',
      description: 'Lights, music & non-stop fun.',
      imageUrl: 'https://static.8club.co/assets/experiences/party+2.png',
      iconUrl: 'https://static.8club.co/assets/experience-stamps/Party.png',
      order: 1,
    ),
    const Experience(
      id: 20,
      name: 'Dinner',
      tagline: '',
      description: 'Evening meals with a special touch.',
      imageUrl: 'https://static.8club.co/assets/experiences/dinner+2.png',
      iconUrl: 'https://static.8club.co/assets/experience-stamps/Dinner.png',
      order: 6,
    ),
    const Experience(
      id: 13,
      name: 'Brunch',
      tagline: '',
      description: 'Late morning bites & mimosas.',
      imageUrl: 'https://static.8club.co/assets/experiences/brunch+2.png',
      iconUrl: 'https://static.8club.co/assets/experience-stamps/Brunch.png',
      order: 4,
    ),
    const Experience(
      id: 26,
      name: 'Fitness',
      tagline: '',
      description: 'Yoga, Workout, Pilates and more.',
      imageUrl: 'https://static.8club.co/assets/experiences/fitness.png',
      iconUrl: 'https://static.8club.co/assets/experience-stamps/Fitness.png',
      order: 2,
    ),
    const Experience(
      id: 5,
      name: 'Music',
      tagline: '',
      description: 'Live tunes & good vibes all around.',
      imageUrl: 'https://static.8club.co/assets/experiences/music+2.png',
      iconUrl: 'https://static.8club.co/assets/experience-stamps/Music.png',
      order: 7,
    ),
    const Experience(
      id: 14,
      name: 'Games',
      tagline: '',
      description: 'Play, compete & laugh together.',
      imageUrl: 'https://static.8club.co/assets/experiences/games+2.png',
      iconUrl: 'https://static.8club.co/assets/experience-stamps/Games.png',
      order: 15,
    ),
    const Experience(
      id: 1,
      name: 'Picnic',
      tagline: '',
      description: 'Chill outdoors with food, friends & fun.',
      imageUrl: 'https://static.8club.co/assets/experiences/picnic+2.png',
      iconUrl: 'https://static.8club.co/assets/experience-stamps/Picnic.png',
      order: 3,
    ),
    const Experience(
      id: 25,
      name: 'Dance',
      tagline: '',
      description: 'Hit the floor & move to the beat.',
      imageUrl: 'https://static.8club.co/assets/experiences/dance+2.png',
      iconUrl: 'https://static.8club.co/assets/experience-stamps/Dance.png',
      order: 16,
    ),
  ];
}
