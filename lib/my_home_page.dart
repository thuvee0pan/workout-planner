import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todays_workouts_view.dart';
import 'week_view.dart';
import 'workout_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _preloadWorkoutPlan();
  }

  Future<void> _preloadWorkoutPlan() async {
    final workoutData = Provider.of<WorkoutData>(context, listen: false);
    if (!await workoutData.hasPreloadedData()) {
      await workoutData.preloadPlan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          toolbarHeight: 0, // Remove the AppBar height to eliminate the space
          bottom: const TabBar(
            tabs: [
              Tab(text: "Today's", icon: Icon(Icons.today)),
              Tab(text: "Week", icon: Icon(Icons.calendar_view_week)),
            ],
          ),
        ),
        body: const TabBarView(children: [TodaysWorkoutsView(), WeekView()]),
      ),
    );
  }
}
