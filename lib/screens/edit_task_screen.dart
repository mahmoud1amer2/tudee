import 'package:flutter/material.dart';
import '../models/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskController;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task.title);
    _isDone = widget.task.isDone;
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updatedText = _taskController.text.trim();
    if (updatedText.isEmpty) return;

    widget.task.title = updatedText;
    widget.task.isDone = _isDone;
    await widget.task.save();

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _deleteTask() async {
    await widget.task.delete();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tudee'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Task",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _taskController,
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pending_actions, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text('To Do', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    selected: !_isDone,
                    selectedColor: const Color(0xFFC084FC),
                    backgroundColor: Colors.grey.shade300,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() => _isDone = false);
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 16, color: Color(0xFF166534)),
                        SizedBox(width: 4),
                        Text('Done', style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    selected: _isDone,
                    selectedColor: const Color(0xFF86EFAC),
                    backgroundColor: Colors.grey.shade300,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() => _isDone = true);
                      }
                    },
                  ),
                ],
              ),

              SizedBox(height: 23),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  onPressed: _saveChanges,
                  child: const Text('Save changes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}