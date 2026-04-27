import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plan_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanProvider>(context);
    final currentDay = provider.currentPlanDay;
    final progress = provider.overallProgress;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('MY PROGRESS'),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProgressDashboard(context, progress),
                const SizedBox(height: 32),
                _buildStatsRow(context, provider),
                const SizedBox(height: 32),
                _buildMotivationSection(context),
                const SizedBox(height: 24),
                _buildDailyTipCard(context, provider.plans[currentDay - 1].tip),
                const SizedBox(height: 48),
                _buildContinueButton(context, provider, currentDay),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDashboard(BuildContext context, double progress) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E1E1E),
            const Color(0xFF121212),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180,
            width: 180,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 16,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, letterSpacing: -1),
              ),
              const Text(
                'COMPLETED',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, PlanProvider provider) {
    final daysLeft = 30 - provider.currentPlanDay + 1;
    final totalCheckmarks = provider.plans.fold<int>(0, (sum, plan) => sum + plan.diet.where((e) => e.isCompleted).length + plan.workouts.where((e) => e.isCompleted).length);

    return Row(
      children: [
        _buildStatItem(context, 'Days Left', '$daysLeft', Icons.calendar_today_rounded),
        const SizedBox(width: 16),
        _buildStatItem(context, 'Total Tasks', '$totalCheckmarks', Icons.auto_awesome_rounded),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'DAILY FOCUS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '"Success is the sum of small efforts, repeated day in and day out."',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white70, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildDailyTipCard(BuildContext context, String tip) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text('PRO TIP', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 12),
          Text(tip, style: const TextStyle(fontSize: 15, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, PlanProvider provider, int currentDay) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          provider.selectDay(currentDay - 1);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Focusing on Day $currentDay'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.primary,
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        child: Text('CONTINUE DAY $currentDay'),
      ),
    );
  }
}
