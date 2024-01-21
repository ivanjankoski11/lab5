import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mis_lab3/main.dart';

class AddExam extends StatefulWidget {
  final Function(Exam) onExamAdded;

  const AddExam({Key? key, required this.onExamAdded}) : super(key: key);

  @override
  _AddExamState createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  TextEditingController _subjectController = TextEditingController();
  bool _isPartial = false;
  DateTime _selectedDate = DateTime.now();
  TextEditingController _labController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Exam'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(labelText: 'Subject'),
          ),
          Row(
            children: [
              Checkbox(
                value: _isPartial,
                onChanged: (value) {
                  setState(() {
                    _isPartial = value!;
                  });
                },
              ),
              Text('Partial Exam'),
            ],
          ),
          TextButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
            child: Text(
              'Select Date',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          TextField(
            controller: _labController,
            decoration: InputDecoration(labelText: 'Lab'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String subject = _subjectController.text.trim();
            String lab = _labController.text.trim();

            if (subject.isNotEmpty && lab.isNotEmpty) {
              Exam newExam = Exam(subject, _isPartial, _selectedDate, lab, LatLng(42.00400679956598, 21.409523192524727));
              widget.onExamAdded(newExam);
              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
