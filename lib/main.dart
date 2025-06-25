// A simple Flutter Web CRUD app for an attendance system (in-memory)
// NOTE: This is a basic local app without backend

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const AttendanceApp());
  // SemanticsBinding.instance.ensureSemantics(); 
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AttendancePage(),
    );
  }
}

class Student {
  final int id;
  String name;
  bool present;

  Student({required this.id, required this.name, this.present = false});
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<Student> _students = [];
  final TextEditingController _nameController = TextEditingController();
  int _idCounter = 1;

  void _addStudent() {
    if (_nameController.text.isEmpty) return;
    setState(() {
      _students.add(Student(id: _idCounter++, name: _nameController.text));
      _nameController.clear();
    });
  }

  void _editStudent(Student student) {
    _nameController.text = student.name;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Student'),
        content: TextField(controller: _nameController),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  student.name = _nameController.text;
                  _nameController.clear();
                });
                Navigator.pop(context);
              },
              child: const Text('Save'))
        ],
      ),
    );
  }

  void _deleteStudent(Student student) {
    setState(() {
      _students.removeWhere((s) => s.id == student.id);
    });
  }

  void _toggleAttendance(Student student) {
    setState(() {
      student.present = !student.present;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Student Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addStudent, child: const Text('Add')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (_, index) {
                  final student = _students[index];
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: student.present,
                        onChanged: (_) => _toggleAttendance(student),
                      ),
                      title: Text(student.name),
                      subtitle: Text('ID: ${student.id}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editStudent(student),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteStudent(student),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
