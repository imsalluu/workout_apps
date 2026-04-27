import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plan_provider.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanProvider>(context);
    final plans = provider.plans;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CALENDAR'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildCalendarHeader(context),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 40),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  final isSelected = provider.selectedDayIndex == index;
                  final isCompleted = plan.isCompleted;
                  final isToday = provider.currentPlanDay == plan.dayNumber;

                  return GestureDetector(
                    onTap: () {
                      provider.selectDay(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                        border: isToday && !isSelected
                            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
                            : Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${plan.dayNumber}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isCompleted)
                            Icon(
                              Icons.check_circle_rounded,
                              size: 14,
                              color: isSelected ? Colors.black87 : Theme.of(context).colorScheme.primary,
                            )
                          else
                            Container(
                              height: 14,
                              width: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.black26 : Colors.white10,
                                  width: 1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          Icon(Icons.stars_rounded, color: Colors.amber),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('30-DAY JOURNEY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.5)),
                SizedBox(height: 4),
                Text('Track your consistency every day for the best results.', style: TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
