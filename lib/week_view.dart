import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workout_data.dart';

class WeekView extends StatelessWidget {
  const WeekView({super.key});

  @override
  Widget build(BuildContext context) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final workoutData = Provider.of<WorkoutData>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Week View',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                final workouts = workoutData.getWorkoutsForDay(day);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ExpansionTile(
                    leading: CircleAvatar(child: Text(day[0])),
                    title: Text(day),
                    subtitle: Text(
                      workouts.isEmpty
                          ? 'No workouts'
                          : '${workouts.length} workout(s)',
                    ),
                    children: [
                      ...workouts.asMap().entries.map((entry) {
                        final i = entry.key;
                        final w = entry.value;
                        return ListTile(
                          title: Text(w.name),
                          subtitle: Text(
                            w.type == 'cardio'
                                ? 'Time: ${w.time}'
                                : 'Sets: ${w.sets}, Reps: ${w.reps}${w.time != null ? ", Time: ${w.time}" : ""}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed:
                                    () => _showWorkoutDialog(
                                      context,
                                      day,
                                      workoutData,
                                      workout: w,
                                      index: i,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed:
                                    () => workoutData.removeWorkout(day, i),
                              ),
                            ],
                          ),
                        );
                      }),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Add Workout'),
                        onTap:
                            () => _showWorkoutDialog(context, day, workoutData),
                      ),
                    ],
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

void _showWorkoutDialog(
  BuildContext context,
  String day,
  WorkoutData workoutData, {
  Workout? workout,
  int? index,
}) {
  final nameController = TextEditingController(text: workout?.name ?? '');
  final type = ValueNotifier<WorkoutType>(workout?.type ?? WorkoutType.strength);
  final setsController = TextEditingController(
    text: workout?.sets?.toString() ?? '',
  );
  final repsController = TextEditingController(
    text: workout?.reps?.toString() ?? '',
  );
  final timeController = TextEditingController(text: workout?.time ?? '');

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(workout == null ? 'Add Workout' : 'Edit Workout'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Workout Name'),
              ),
              ValueListenableBuilder<WorkoutType>(
                valueListenable: type,
                builder: (context, value, _) => DropdownButton<WorkoutType>(
                  value: value,
                  items: WorkoutType.values.map((wt) => DropdownMenuItem(
                    value: wt,
                    child: Text(wt.name[0].toUpperCase() + wt.name.substring(1)),
                  )).toList(),
                  onChanged: (val) => type.value = val!,
                ),
              ),
              if (type.value == WorkoutType.strength || type.value == WorkoutType.main || type.value == WorkoutType.accessory || type.value == WorkoutType.warmup)
                ...[
                  TextField(
                    controller: setsController,
                    decoration: const InputDecoration(labelText: 'Sets'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: repsController,
                    decoration: const InputDecoration(labelText: 'Reps'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  labelText: (type.value == WorkoutType.cardio || type.value == WorkoutType.warmup)
                      ? 'Time (e.g. 20 min)' : 'Time (optional)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newWorkout = Workout(
                name: nameController.text,
                type: type.value,
                sets: (type.value == WorkoutType.strength || type.value == WorkoutType.main || type.value == WorkoutType.accessory || type.value == WorkoutType.warmup)
                    ? int.tryParse(setsController.text)
                    : null,
                reps: (type.value == WorkoutType.strength || type.value == WorkoutType.main || type.value == WorkoutType.accessory || type.value == WorkoutType.warmup)
                    ? int.tryParse(repsController.text)
                    : null,
                time: timeController.text.isNotEmpty ? timeController.text : null,
              );
              if (workout == null) {
                workoutData.addWorkout(day, newWorkout);
              } else if (index != null) {
                workoutData.updateWorkout(day, index, newWorkout);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
