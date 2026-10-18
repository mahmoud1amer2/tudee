import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final String initialTitle;
  final bool initialIsDone;

  const EditTaskScreen({
    super.key,
    required this.taskId,
    required this.initialTitle,
    required this.initialIsDone,
  });
  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}
class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskController;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.initialTitle);
    _isDone = widget.initialIsDone;
  }
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
  Future<void> _saveChanges() async {
    final updatedText = _taskController.text.trim();
    if (updatedText.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .update({'title': updatedText, 'isDone': _isDone});

    if (!mounted) return;
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tudee'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32,horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(
                    "Edit Task",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                   ),
                   Icon(Icons.update)
                 ],
               ),
              SizedBox(height: 35),
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
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label:  Row(
                      children: [
                        Icon(
                          Icons.pending_actions,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'To Do',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                  SizedBox(width: 12),
                  ChoiceChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 16, color: Color(0xFF166534)),
                        SizedBox(width: 4),
                        Text(
                          'Done',
                          style: TextStyle(
                            color: Color(0xFF166534),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  onPressed: _saveChanges,
                  child: Text(
                    'Save changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
