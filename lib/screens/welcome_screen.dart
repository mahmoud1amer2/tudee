import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart'; // تأكد من استيراد صفحة التعديل

class WelcomeScreen extends StatefulWidget {
  final String userName;

  const WelcomeScreen({
    Key? key,
    this.userName = 'Ahmed',
  }) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<DocumentSnapshot> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  // دالة لجلب المهام من Firebase مرة واحدة
  Future<void> _fetchTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tasks').get();
      setState(() {
        tasks = snapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int doneCount = 0;
    int toDoCount = 0;

    for (var doc in tasks) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['isDone'] == true) {
        doneCount++;
      } else {
        toDoCount++;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Tudee")),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _fetchTasks,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 37, left: 16, right: 16, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome ${widget.userName}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: buildStatusCard(
                              backgroundColor: const Color(0xFF6ECB98),
                              icon: Icons.task_alt_rounded,
                              count: doneCount,
                              label: 'Done',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: buildStatusCard(
                              backgroundColor: const Color(0xFF9381FF),
                              icon: Icons.help_outline_rounded,
                              count: toDoCount,
                              label: 'To-Do',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18.0),

                tasks.isEmpty
                    ? Container(
                  width: double.infinity,
                  height: 160,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "No tasks for today!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Tap the + button to add your first one.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final taskDoc = tasks[index];
                    final taskData = taskDoc.data() as Map<String, dynamic>;
                    final taskId = taskDoc.id;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(
                          taskData['title'] ?? '',
                          style: TextStyle(
                            decoration: taskData['isDone'] == true
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreen(
                                taskId: taskId,
                                initialTitle: taskData['title'] ?? '',
                                initialIsDone: taskData['isDone'] ?? false,
                              ),
                            ),
                          );
                          _fetchTasks(); // تحديث القائمة عند الرجوع
                        },
                        trailing: Checkbox(
                          value: taskData['isDone'] ?? false,
                          onChanged: (val) async {
                            await FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(taskId)
                                .update({'isDone': val});
                            _fetchTasks();
                          },
                        ),
                        leading: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(taskId)
                                .delete();
                            _fetchTasks();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          _fetchTasks();
        },
        child: const Icon(Icons.note_add, color: Colors.white),
      ),
    );
  }

  Widget buildStatusCard({
    required Color backgroundColor,
    required IconData icon,
    required int count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 12.0),
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}