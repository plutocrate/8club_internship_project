import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eightclub/main.dart';
import 'package:eightclub/features/host.onboarding/presentation/providers/experiences.provider.dart';
import 'package:eightclub/features/host.onboarding/data/models/experience.model.dart';

void main() {
  final mockExperiences = [
    const Experience(
      id: 1,
      name: 'Party',
      tagline: '',
      description: 'Test',
      imageUrl: '',
      iconUrl: '',
      order: 1,
    ),
  ];

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          experiencesProvider.overrideWith((ref) async => mockExperiences),
        ],
        child: const EightClubApp(),
      ),
    );
    await tester.pump();
    expect(find.text('01'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
