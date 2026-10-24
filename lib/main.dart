import 'package:flutter/material.dart';

void main() {
  runApp(const FocusTrackApp());
}

enum Priority {
  low(
    'Low',
    Icons.arrow_downward,
    Color(0xFF546E7A),
    'Relaxed pace, keep a steady rhythm.',
  ),
  medium(
    'Medium',
    Icons.remove,
    Color(0xFFEF6C00),
    'Balanced pace, stay focused on your goals.',
  ),
  high(
    'High',
    Icons.priority_high,
    Color(0xFFB71C1C),
    'Maximum focus, every goal counts today.',
  );

  const Priority(this.label, this.icon, this.color, this.message);

  final String label;
  final IconData icon;
  final Color color;
  final String message;
}

class FocusTrackApp extends StatelessWidget {
  const FocusTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusTrack Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
      ),
      home: const MainGoalsScreen(),
    );
  }
}

class MainGoalsScreen extends StatefulWidget {
  const MainGoalsScreen({super.key});

  @override
  State<MainGoalsScreen> createState() => _MainGoalsScreenState();
}

class _MainGoalsScreenState extends State<MainGoalsScreen> {
  static const int _maxDailyGoals = 10;

  int _completedGoals = 0;
  final int _goalTarget = 5;
  String _productivityLevel = 'Initial';
  Priority _priority = Priority.low;

  void _updateLevel() {
    if (_completedGoals == 0) {
      _productivityLevel = 'Initial';
    } else if (_completedGoals < _goalTarget) {
      _productivityLevel = 'In Progress';
    } else if (_completedGoals == _goalTarget) {
      _productivityLevel = 'Goal Reached!';
    } else {
      _productivityLevel = 'Outstanding (+${_completedGoals - _goalTarget})!';
    }
  }

  void _incrementGoal() {
    if (_completedGoals >= _maxDailyGoals) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You have reached the maximum daily goal limit (10/10). '
            'Great job today!',
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    setState(() {
      _completedGoals++;
      _updateLevel();
    });
  }

  void _decrementGoal() {
    setState(() {
      if (_completedGoals > 0) {
        _completedGoals--;
        _updateLevel();
      }
    });
  }

  void _resetCounters() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirm Reset'),
          content: const Text(
            'Do you want to reset all completed goals to zero?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _completedGoals = 0;
                  _updateLevel();
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Goals reset successfully.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final progress = (_completedGoals / _goalTarget).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusTrack Mobile'),
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reset goals session',
            onPressed: _resetCounters,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary card
              Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.track_changes,
                        size: 52.0,
                        color: colors.primary,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        "Today's Progress",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '$_completedGoals / $_goalTarget',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10.0,
                          backgroundColor: colors.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _completedGoals >= _goalTarget
                                ? Colors.teal
                                : colors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Chip(
                        avatar: Icon(
                          _completedGoals >= _goalTarget
                              ? Icons.emoji_events
                              : Icons.bolt,
                          color: colors.onSecondaryContainer,
                        ),
                        label: Text(
                          _productivityLevel,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.onSecondaryContainer,
                          ),
                        ),
                        backgroundColor: colors.secondaryContainer,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Priority selector
              SegmentedButton<Priority>(
                segments: Priority.values
                    .map(
                      (Priority p) => ButtonSegment<Priority>(
                        value: p,
                        label: Text(p.label),
                        icon: Icon(p.icon),
                      ),
                    )
                    .toList(),
                selected: {_priority},
                showSelectedIcon: false,
                onSelectionChanged: (Set<Priority> selection) {
                  setState(() {
                    _priority = selection.first;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return _priority.color;
                    }
                    return null;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return null;
                  }),
                ),
              ),
              const SizedBox(height: 24.0),

              // Info panel
              Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: _priority.color, width: 2.0),
                ),
                child: ListTile(
                  leading: Icon(_priority.icon, color: _priority.color),
                  title: Text('${_priority.label} Priority Session'),
                  subtitle: Text(_priority.message),
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating action buttons
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn_decrement',
            onPressed: _decrementGoal,
            tooltip: 'Remove completed goal',
            backgroundColor: colors.surfaceContainerHighest,
            foregroundColor: colors.onSurfaceVariant,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 14.0),
          FloatingActionButton.extended(
            heroTag: 'btn_increment',
            onPressed: _incrementGoal,
            tooltip: 'Complete goal',
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            icon: const Icon(Icons.check),
            label: const Text('Complete Goal'),
          ),
        ],
      ),
    );
  }
}
