import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_home_page.dart';
import 'workout_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final workoutData = WorkoutData();
  await workoutData.load();
  runApp(
    ChangeNotifierProvider(create: (_) => workoutData, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Workout'),
      showSemanticsDebugger: false,
    );
  }
}
