import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app.theme.dart';
import 'features/host.onboarding/presentation/pages/experience.selection.page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: EightClubApp(),
    ),
  );
}

class EightClubApp extends StatelessWidget {
  const EightClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '8club Host Onboarding',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const ExperienceSelectionPage(),
    );
  }
}
