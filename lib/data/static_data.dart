import '../models/fitness_models.dart';

List<DayPlan> generate30DayPlan() {
  return List.generate(30, (index) {
    int day = index + 1;
    return DayPlan(
      dayNumber: day,
      diet: [
        ChecklistItem(id: 'morning_$day', title: 'Morning Routine', subtitle: 'Warm water with lemon'),
        ChecklistItem(id: 'breakfast_$day', title: 'Breakfast', subtitle: 'Oatmeal with fruits'),
        ChecklistItem(id: 'lunch_$day', title: 'Lunch', subtitle: 'Grilled chicken salad'),
        ChecklistItem(id: 'snack_$day', title: 'Snacks', subtitle: 'A handful of almonds'),
        ChecklistItem(id: 'dinner_$day', title: 'Dinner', subtitle: 'Baked salmon with steamed veggies'),
      ],
      workouts: [
        ChecklistItem(id: 'plank_$day', title: 'Plank', subtitle: '60 seconds x 3'),
        ChecklistItem(id: 'crunches_$day', title: 'Crunches', subtitle: '20 reps x 3'),
        ChecklistItem(id: 'mountain_climbers_$day', title: 'Mountain Climbers', subtitle: '30 reps x 3'),
        ChecklistItem(id: 'jump_rope_$day', title: 'Jump Rope', subtitle: '5 minutes'),
      ],
      tip: _getTipForDay(day),
      waterIntake: 8,
    );
  });
}

String _getTipForDay(int day) {
  List<String> tips = [
    'Drink plenty of water to boost metabolism.',
    'Consistency is key to losing belly fat.',
    'Avoid sugary drinks and processed foods.',
    'Sleep at least 7-8 hours for better recovery.',
    'Try to stay active throughout the day.',
    'Fiber-rich foods help you feel full longer.',
    'Don\'t skip meals, especially breakfast.',
    'Green tea can help in burning fat.',
    'Reduce salt intake to prevent bloating.',
    'Patience is vital; results take time.',
    'Focus on your posture to engage core muscles.',
    'Eat slowly and enjoy your food.',
    'Avoid eating late at night.',
    'Protein helps in muscle building and fat loss.',
    'Stay positive and believe in yourself.',
    'Walking after meals can aid digestion.',
    'High-intensity interval training (HIIT) is effective.',
    'Healthy fats like avocado are good for you.',
    'Measure your progress, not just your weight.',
    'Stay away from trans fats.',
    'Apple cider vinegar may help reduce abdominal fat.',
    'Keep your stress levels low.',
    'Stretching prevents injuries and improves flexibility.',
    'Incorporate more leg exercises to burn more calories.',
    'Listen to your body; don\'t overtrain.',
    'Vegetables should be half of your plate.',
    'Avoid drinking water during meals.',
    'Cardio is great, but don\'t forget strength training.',
    'Small changes lead to big results.',
    'Celebrate your 30-day journey! Stay fit!'
  ];
  return tips[(day - 1) % tips.length];
}
