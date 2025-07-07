import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workout_data.dart';

class TodaysWorkoutsView extends StatelessWidget {
  const TodaysWorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutData = Provider.of<WorkoutData>(context);
    final now = DateTime.now();
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final today = days[now.weekday - 1];
    final workouts = workoutData.getWorkoutsForDay(today);
    final formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Workouts ($formattedDate)",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                workouts.isEmpty
                    ? const Center(child: Text('No workouts for today.'))
                    : ListView.builder(
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        final w = workouts[index];
                        IconData icon;
                        Color color;
                        switch (w.type) {
                          case WorkoutType.warmup:
                            icon = Icons.wb_sunny;
                            color = Colors.orange;
                            break;
                          case WorkoutType.cardio:
                            icon = Icons.directions_run;
                            color = Colors.blue;
                            break;
                          case WorkoutType.main:
                            icon = Icons.fitness_center;
                            color = Colors.green;
                            break;
                          case WorkoutType.accessory:
                            icon = Icons.extension;
                            color = Colors.purple;
                            break;
                          case WorkoutType.strength:
                            icon = Icons.sports_mma;
                            color = Colors.red;
                            break;
                          default:
                            icon = Icons.fitness_center;
                            color = Colors.grey;
                        }
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Icon(icon, color: color),
                            title: Text(w.name),
                            subtitle:
                                w.type == WorkoutType.cardio
                                    ? Text('Time: ${w.time}')
                                    : Text(
                                      'Sets: ${w.sets}, Reps: ${w.reps}${w.time != null ? ", Time: ${w.time}" : ""}',
                                    ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
