# Workout Planner App

A simple Flutter app to plan, track, and manage your weekly workouts. This app is designed to help you organize your training routine using a classic split (Push/Pull/Legs) and supports both strength and cardio exercises.

---

## MVP Features

### 1. **Weekly Workout Plan**
- Preloaded with a 6-day split workout plan (Push/Pull/Legs).
- Each day contains warmup, main, and accessory exercises.
- Workouts can be strength or cardio, with support for sets, reps, and time-based activities.

### 2. **Today’s View**
- Automatically displays the workouts scheduled for the current day.
- Shows exercise details, including type, sets, reps, and time.
- Uses icons and colors to visually distinguish workout types.

### 3. **Week View**
- View and manage the full week’s workout schedule.
- Add, edit, or remove workouts for any day.
- Select workout type from a dropdown (warmup, main, accessory, cardio, strength, other).
- Input fields adapt based on workout type (sets/reps for strength, time for cardio).

### 4. **Persistent Storage**
- All workout data is saved locally using SharedPreferences.
- Preloaded plan is only loaded on first launch; user changes are preserved.

---

## Getting Started

1. **Clone the repository:**
   ```sh
   git clone git@github.com:thuvee0pan/workout-planner.git
   cd workout-planner
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the app:**
   ```sh
   flutter run
   ```

---

## Tech Stack

- **Flutter** (UI)
- **Provider** (State management)
- **SharedPreferences** (Local storage)

---

## Future Improvements

- Workout history and logging
- Custom workout templates
- Progress tracking and analytics
- Cloud sync and user authentication

---

## License

MIT

---

**MVP Summary:**  
This app lets you view, add, and edit a week’s worth of workouts, see today’s plan, and persist your data locally. It’s a focused, easy-to-use MVP for anyone wanting to organize their training routine.
