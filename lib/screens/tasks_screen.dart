import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plan_provider.dart';
import '../models/fitness_models.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanProvider>(context);
    final selectedDay = provider.selectedDayPlan;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('DAY ${selectedDay.dayNumber} PLAN'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'DIET'),
              Tab(text: 'WORKOUT'),
            ],
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 3,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.white38,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 13),
          ),
        ),
        body: TabBarView(
          children: [
            _buildDietTab(context, provider, selectedDay),
            _buildWorkoutTab(context, provider, selectedDay),
          ],
        ),
      ),
    );
  }

  Widget _buildDietTab(BuildContext context, PlanProvider provider, DayPlan plan) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        _buildSectionHeader(context, 'DAILY ROUTINE', Icons.wb_sunny_rounded),
        ...plan.diet.take(1).map((item) => _buildTaskCard(context, provider, item, true)),
        const SizedBox(height: 24),
        _buildSectionHeader(context, 'MEAL PLAN', Icons.restaurant_rounded),
        ...plan.diet.skip(1).map((item) => _buildTaskCard(context, provider, item, true)),
        const SizedBox(height: 24),
        _buildSectionHeader(context, 'HYDRATION', Icons.water_drop_rounded),
        _buildWaterCard(context, provider, plan),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildWorkoutTab(BuildContext context, PlanProvider provider, DayPlan plan) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        _buildSectionHeader(context, 'FAT LOSS EXERCISES', Icons.fitness_center_rounded),
        ...plan.workouts.map((item) => _buildTaskCard(context, provider, item, false)),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, PlanProvider provider, ChecklistItem item, bool isDiet) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isCompleted 
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: GestureDetector(
          onTap: () => provider.toggleItemCompletion(item.id, isDiet),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.isCompleted 
                  ? Theme.of(context).colorScheme.primary 
                  : Colors.transparent,
              border: Border.all(
                color: item.isCompleted 
                    ? Theme.of(context).colorScheme.primary 
                    : Colors.white24,
                width: 2,
              ),
            ),
            child: item.isCompleted 
                ? const Icon(Icons.check, size: 18, color: Colors.black)
                : null,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: item.isCompleted ? Colors.white38 : Colors.white,
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          item.subtitle,
          style: TextStyle(
            fontSize: 13,
            color: item.isCompleted ? Colors.white24 : Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _buildWaterCard(BuildContext context, PlanProvider provider, DayPlan plan) {
    final progress = (plan.waterDrank / plan.waterIntake).clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DAILY GOAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${plan.waterDrank}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6, left: 4),
                        child: Text('/ 8 CUPS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white24)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.water_drop_rounded, color: Colors.blueAccent, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => provider.updateWater(plan.dayNumber, -1),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: Colors.white10),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Icon(Icons.remove, size: 20, color: Colors.white54),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => provider.updateWater(plan.dayNumber, 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Icon(Icons.add, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
