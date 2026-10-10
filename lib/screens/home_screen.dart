import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Task> _tasksBox;

  @override
  void initState() {
    super.initState();
    _tasksBox = Hive.box<Task>('tasksBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tudee'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<Box<Task>>(
          valueListenable: _tasksBox.listenable(),
          builder: (context, box, _) {
            final tasks = box.values.toList();
            final doneCount = tasks.where((t) => t.isDone).length;
            final toDoCount = tasks.where((t) => !t.isDone).length;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height: 37),

                  Text(
                    "Welcome ${widget.userName}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.task_alt,
                          count: doneCount,
                          label: "Done",
                          backgroundColor: Colors.green,
                          iconColor: const Color(0xFF166534),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.pending_actions,
                          count: toDoCount,
                          label: "To-Do",
                          backgroundColor: const Color(0xFFC084FC),
                          iconColor: const Color(0xFF581C87),

                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Expanded(
                    child: tasks.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "No tasks for today!",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Tap the + button to add your first one.",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                        : ListView.separated(
                      itemCount: tasks.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTaskScreen(task: task),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: task.isDone ? const Color(0xFF86EFAC) : const Color(0xFFC084FC),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    task.isDone ? 'Done' : 'TO DO',
                                    style: TextStyle(
                                      color: task.isDone ? const Color(0xFF166534) : Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    decoration: task.isDone ? TextDecoration.lineThrough : null,
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
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF38BDF8),
        elevation: 2,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.note_add_outlined, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required int count,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 48 ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            "$count",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}