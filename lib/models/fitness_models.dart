class ChecklistItem {
  final String id;
  final String title;
  final String subtitle;
  bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'isCompleted': isCompleted,
      };

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        id: json['id'],
        title: json['title'],
        subtitle: json['subtitle'] ?? '',
        isCompleted: json['isCompleted'] ?? false,
      );
}

class DayPlan {
  final int dayNumber;
  final List<ChecklistItem> diet;
  final List<ChecklistItem> workouts;
  final String tip;
  final int waterIntake; // in glasses/units
  int waterDrank;

  DayPlan({
    required this.dayNumber,
    required this.diet,
    required this.workouts,
    required this.tip,
    this.waterIntake = 8,
    this.waterDrank = 0,
  });

  bool get isCompleted {
    return diet.every((item) => item.isCompleted) &&
        workouts.every((item) => item.isCompleted) &&
        waterDrank >= waterIntake;
  }

  double get completionPercentage {
    int totalItems = diet.length + workouts.length + 1; // +1 for water
    int completedItems = diet.where((item) => item.isCompleted).length +
        workouts.where((item) => item.isCompleted).length +
        (waterDrank >= waterIntake ? 1 : 0);
    return completedItems / totalItems;
  }

  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'diet': diet.map((e) => e.toJson()).toList(),
        'workouts': workouts.map((e) => e.toJson()).toList(),
        'tip': tip,
        'waterIntake': waterIntake,
        'waterDrank': waterDrank,
      };

  factory DayPlan.fromJson(Map<String, dynamic> json) => DayPlan(
        dayNumber: json['dayNumber'],
        diet: (json['diet'] as List).map((e) => ChecklistItem.fromJson(e)).toList(),
        workouts: (json['workouts'] as List).map((e) => ChecklistItem.fromJson(e)).toList(),
        tip: json['tip'],
        waterIntake: json['waterIntake'] ?? 8,
        waterDrank: json['waterDrank'] ?? 0,
      );
}
