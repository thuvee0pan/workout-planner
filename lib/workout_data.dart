import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WorkoutType { warmup, main, accessory, cardio, strength, other }

WorkoutType workoutTypeFromString(String? type) {
  switch (type) {
    case 'warmup':
      return WorkoutType.warmup;
    case 'main':
      return WorkoutType.main;
    case 'accessory':
      return WorkoutType.accessory;
    case 'cardio':
      return WorkoutType.cardio;
    case 'strength':
      return WorkoutType.strength;
    default:
      return WorkoutType.other;
  }
}

String workoutTypeToString(WorkoutType type) {
  switch (type) {
    case WorkoutType.warmup:
      return 'warmup';
    case WorkoutType.main:
      return 'main';
    case WorkoutType.accessory:
      return 'accessory';
    case WorkoutType.cardio:
      return 'cardio';
    case WorkoutType.strength:
      return 'strength';
    default:
      return 'other';
  }
}

class Workout {
  final String name;
  final WorkoutType type;
  final int? sets;
  final int? reps;
  final String? time;

  Workout({
    required this.name,
    required this.type,
    this.sets,
    this.reps,
    this.time,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': workoutTypeToString(type),
    'sets': sets,
    'reps': reps,
    'time': time,
  };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    name: json['name'],
    type: workoutTypeFromString(json['type']),
    sets: json['sets'],
    reps:
        json['reps'] is int
            ? json['reps']
            : int.tryParse(json['reps']?.toString() ?? ''),
    time: json['time'],
  );
}

class WorkoutData extends ChangeNotifier {
  static const _storageKey = 'weekly_workouts';
  static const _preloadKey = 'workout_plan_preloaded';

  Map<String, List<Workout>> _workoutsByDay = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  Map<String, List<Workout>> get workoutsByDay => _workoutsByDay;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final Map<String, dynamic> decoded = json.decode(jsonString);
      _workoutsByDay = decoded.map(
        (day, list) => MapEntry(
          day,
          (list as List).map((w) => Workout.fromJson(w)).toList(),
        ),
      );
      notifyListeners();
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(
      _workoutsByDay.map(
        (day, list) => MapEntry(day, list.map((w) => w.toJson()).toList()),
      ),
    );
    await prefs.setString(_storageKey, jsonString);
  }

  List<Workout> getWorkoutsForDay(String day) => _workoutsByDay[day] ?? [];

  void addWorkout(String day, Workout workout) {
    _workoutsByDay[day]?.add(workout);
    save();
    notifyListeners();
  }

  void updateWorkout(String day, int index, Workout workout) {
    _workoutsByDay[day]?[index] = workout;
    save();
    notifyListeners();
  }

  void removeWorkout(String day, int index) {
    _workoutsByDay[day]?.removeAt(index);
    save();
    notifyListeners();
  }

  Future<bool> hasPreloadedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_preloadKey) ?? false;
  }

  Future<void> preloadPlan() async {
    final prefs = await SharedPreferences.getInstance();
    if (await hasPreloadedData()) return;
    final plan = {
      'Monday': [
        {'name': 'Arm Circles', 'type': 'warmup', 'time': '30 seconds'},
        {'name': 'Band Pull-Aparts', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Push-ups', 'type': 'warmup', 'sets': 2, 'reps': 10},
        {'name': 'Empty Bar Bench Press', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Dumbbell Bench Press', 'type': 'main', 'sets': 4, 'reps': 12},
        {'name': 'Incline Bench Press', 'type': 'main', 'sets': 4, 'reps': 12},
        {'name': 'Military Press', 'type': 'main', 'sets': 3, 'reps': 12},
        {'name': 'Machine Press', 'type': 'main', 'sets': 3, 'reps': 15},
        {'name': 'Lateral Raises', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Cable Flyes', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Triceps Pushdowns', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Overhead Triceps Extensions', 'type': 'accessory', 'sets': 3, 'reps': 15},
      ],
      'Tuesday': [
        {'name': 'Cat-Cow Stretch', 'type': 'warmup', 'time': '30 seconds'},
        {'name': 'Scapular Pull-ups', 'type': 'warmup', 'sets': 2, 'reps': 10},
        {'name': 'Band Face Pulls', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Dead Hangs', 'type': 'warmup', 'time': '30 seconds'},
        {'name': 'Pull-ups', 'type': 'main', 'sets': 4, 'reps': 12},
        {'name': 'Lat Pulldowns', 'type': 'main', 'sets': 4, 'reps': 12},
        {'name': 'Seated Cable Rows', 'type': 'main', 'sets': 3, 'reps': 12},
        {'name': 'Chest-Supported Rows', 'type': 'main', 'sets': 3, 'reps': 12},
        {'name': 'Face Pulls', 'type': 'accessory', 'sets': 3, 'reps': 20},
        {'name': 'Straight Arm Pulldowns', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Rear Delt Flyes', 'type': 'accessory', 'sets': 3, 'reps': 20},
        {'name': 'Barbell Curls', 'type': 'accessory', 'sets': 3, 'reps': 12},
        {'name': 'Hammer Curls', 'type': 'accessory', 'sets': 3, 'reps': 12},
      ],
      'Wednesday': [
        {'name': 'Walking High Knees', 'type': 'warmup', 'time': '1 minute'},
        {'name': 'Bodyweight Squats', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Walking Lunges', 'type': 'warmup', 'time': '1 minute'},
        {'name': 'Empty Bar Squats', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Back Squats', 'type': 'main', 'sets': 4, 'reps': 10},
        {'name': 'Leg Press', 'type': 'main', 'sets': 4, 'reps': 12},
        {'name': 'Bulgarian Split Squats', 'type': 'main', 'sets': 3, 'reps': 12},
        {'name': 'Hack Squats', 'type': 'main', 'sets': 3, 'reps': 12},
        {'name': 'Leg Extensions', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Standing Calf Raises', 'type': 'accessory', 'sets': 4, 'reps': 20},
        {'name': 'Seated Calf Raises', 'type': 'accessory', 'sets': 3, 'reps': 20},
        {'name': 'Abs Circuit', 'type': 'accessory', 'sets': 3, 'reps': 15},
      ],
      'Thursday': [
        {'name': 'Arm Circles', 'type': 'warmup', 'time': '30 seconds'},
        {'name': 'Band Pull-Aparts', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Light Lateral Raises', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Empty Bar Overhead Press', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Seated Dumbbell Press', 'type': 'main', 'sets': 4, 'reps': 10},
        {'name': 'Arnold Press', 'type': 'main', 'sets': 4, 'reps': 12},
        {'name': 'Incline Bench Press', 'type': 'main', 'sets': 3, 'reps': 12},
        {'name': 'Machine Shoulder Press', 'type': 'main', 'sets': 3, 'reps': 15},
        {'name': 'Lateral Raise Drop Sets', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Cable Front Raises', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Upright Rows', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Close-Grip Bench Press', 'type': 'accessory', 'sets': 3, 'reps': 12},
      ],
      'Friday': [
        {'name': 'Cat-Cow Stretch', 'type': 'warmup', 'time': '30 seconds'},
        {'name': 'Band Pull-Aparts', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Light Rows', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Dead Hangs', 'type': 'warmup', 'time': '30 seconds'},
        {'name': 'Pendlay Rows', 'type': 'main', 'sets': 4, 'reps': 10},
        {'name': 'Single-Arm Dumbbell Rows', 'type': 'main', 'sets': 4, 'reps': 12},
        {'name': 'T-Bar Rows', 'type': 'main', 'sets': 3, 'reps': 12},
        {'name': 'Wide-Grip Pull-ups', 'type': 'main', 'sets': 3, 'reps': 12},
        {'name': 'Face Pulls', 'type': 'accessory', 'sets': 3, 'reps': 20},
        {'name': 'Wide-Grip Cable Rows', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Reverse Pec Deck', 'type': 'accessory', 'sets': 3, 'reps': 20},
        {'name': 'Preacher Curls', 'type': 'accessory', 'sets': 3, 'reps': 12},
        {'name': 'Incline Dumbbell Curls', 'type': 'accessory', 'sets': 3, 'reps': 15},
      ],
      'Saturday': [
        {'name': 'Walking High Knees', 'type': 'warmup', 'time': '1 minute'},
        {'name': 'Bodyweight Good Mornings', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Glute Bridges', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Light Romanian Deadlifts', 'type': 'warmup', 'sets': 2, 'reps': 15},
        {'name': 'Romanian Deadlifts', 'type': 'main', 'sets': 4, 'reps': 10},
        {'name': 'Walking Lunges', 'type': 'main', 'sets': 3, 'reps': 12},
        {'name': 'Leg Press (feet high)', 'type': 'main', 'sets': 4, 'reps': 15},
        {'name': 'Good Mornings', 'type': 'main', 'sets': 3, 'reps': 15},
        {'name': 'Lying Leg Curls', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Seated Leg Curls', 'type': 'accessory', 'sets': 3, 'reps': 15},
        {'name': 'Standing Calf Raises', 'type': 'accessory', 'sets': 4, 'reps': 20},
        {'name': 'Abs Circuit', 'type': 'accessory', 'sets': 3, 'reps': 15},
      ],
      'Sunday': [],
    };
    _workoutsByDay = plan.map(
      (day, list) => MapEntry(day, list.map((w) => Workout.fromJson(w)).toList()),
    );
    await save();
    await prefs.setBool(_preloadKey, true);
    notifyListeners();
  }
}
