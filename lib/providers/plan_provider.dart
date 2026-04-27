import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fitness_models.dart';
import '../data/static_data.dart';

class PlanProvider with ChangeNotifier {
  List<DayPlan> _plans = [];
  int _selectedDayIndex = 0;
  bool _isLoading = true;

  List<DayPlan> get plans => _plans;
  int get selectedDayIndex => _selectedDayIndex;
  DayPlan get selectedDayPlan => _plans[_selectedDayIndex];
  bool get isLoading => _isLoading;

  PlanProvider() {
    _init();
  }

  Future<void> _init() async {
    _plans = generate30DayPlan();
    await _loadProgress();
    _isLoading = false;
    notifyListeners();
  }

  void selectDay(int index) {
    _selectedDayIndex = index;
    notifyListeners();
  }

  int get currentPlanDay {
    // Return the first day that is not completed, or the last day if all are completed
    int index = _plans.indexWhere((plan) => !plan.isCompleted);
    return index == -1 ? _plans.length : index + 1;
  }

  double get overallProgress {
    if (_plans.isEmpty) return 0.0;
    int totalItems = 0;
    int completedItems = 0;
    for (var plan in _plans) {
      totalItems += plan.diet.length + plan.workouts.length + 1;
      completedItems += plan.diet.where((item) => item.isCompleted).length +
          plan.workouts.where((item) => item.isCompleted).length +
          (plan.waterDrank >= plan.waterIntake ? 1 : 0);
    }
    return completedItems / totalItems;
  }

  void toggleItemCompletion(String itemId, bool isDiet) {
    for (var plan in _plans) {
      if (isDiet) {
        final index = plan.diet.indexWhere((item) => item.id == itemId);
        if (index != -1) {
          plan.diet[index].isCompleted = !plan.diet[index].isCompleted;
          break;
        }
      } else {
        final index = plan.workouts.indexWhere((item) => item.id == itemId);
        if (index != -1) {
          plan.workouts[index].isCompleted = !plan.workouts[index].isCompleted;
          break;
        }
      }
    }
    _saveProgress();
    notifyListeners();
  }

  void updateWater(int dayNumber, int delta) {
    final index = _plans.indexWhere((plan) => plan.dayNumber == dayNumber);
    if (index != -1) {
      _plans[index].waterDrank = (_plans[index].waterDrank + delta).clamp(0, 20);
      _saveProgress();
      notifyListeners();
    }
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? progressJson = prefs.getString('fitness_progress');
    if (progressJson != null) {
      final Map<String, dynamic> data = jsonDecode(progressJson);
      
      // Load item completions
      final Map<String, dynamic> completions = data['completions'] ?? {};
      for (var plan in _plans) {
        for (var item in plan.diet) {
          item.isCompleted = completions[item.id] ?? false;
        }
        for (var item in plan.workouts) {
          item.isCompleted = completions[item.id] ?? false;
        }
      }

      // Load water intake
      final Map<String, dynamic> water = data['water'] ?? {};
      for (var plan in _plans) {
        plan.waterDrank = water[plan.dayNumber.toString()] ?? 0;
      }
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, bool> completions = {};
    final Map<String, int> water = {};

    for (var plan in _plans) {
      for (var item in plan.diet) {
        completions[item.id] = item.isCompleted;
      }
      for (var item in plan.workouts) {
        completions[item.id] = item.isCompleted;
      }
      water[plan.dayNumber.toString()] = plan.waterDrank;
    }

    final String progressJson = jsonEncode({
      'completions': completions,
      'water': water,
    });
    await prefs.setString('fitness_progress', progressJson);
  }
}
