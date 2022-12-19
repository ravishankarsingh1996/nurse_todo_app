import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nurse_todo_app/extensions/date_time_extension.dart';
import 'package:nurse_todo_app/model/residents.dart';
import 'package:nurse_todo_app/model/todo.dart';

class CreateTodoScreen extends StatefulWidget {
  final List<Residents> residentsList;

  const CreateTodoScreen({Key? key, required this.residentsList})
      : super(key: key);

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final TextEditingController _textFieldController = TextEditingController();

  late FirebaseFirestore db;
  Residents? selectedResident;
  Todo todoTask = Todo();

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                const Text(
                  'Describe your todo notes',
                ),
                TextField(
                  controller: _textFieldController,
                  maxLines: 3,
                  onChanged: (String value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                      hintText: 'Type here...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Select Date/Time when this task needs to be done',
                ),
                InkWell(
                  onTap: () async {
                    var now = DateTime.now();
                    var selectedDate = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: now,
                        lastDate: DateTime(2050));
                    if (selectedDate == null) {
                      return;
                    }
                    var selectedTime = await showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay(hour: now.hour, minute: now.minute));
                    if (selectedTime == null) {
                      return;
                    }
                    setState(() {
                      todoTask.toBeDoneAt = Timestamp.fromDate(DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute));
                    });
                  },
                  child: TextField(
                    enabled: false,
                    showCursor: false,
                    onChanged: (String value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: '(Optional)',
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                        label: todoTask.toBeDoneAt == null
                            ? null
                            : Text(todoTask.toBeDoneAt
                                    ?.toDate()
                                    .formatDateYYYYMMDDHHMM ??
                                '')),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                DropdownButton<Residents>(
                  // Initial Value
                  value: selectedResident,
                  hint: const Text('Select Resident',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  isExpanded: true,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: widget.residentsList.map((Residents items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items.name ?? ''),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (Residents? newValue) {
                    setState(() {
                      todoTask.relatedToResidentID = newValue!.id;
                      selectedResident = newValue;
                    });
                  },
                ),
                const Text(
                  '* If your todo is related to some resident please select his name',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                ),
              ],
            )),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTaskLengthValid()
                        ? () {
                            Navigator.of(context).pop();
                            _addTodoItem(_textFieldController.text);
                          }
                        : null,
                    child: const Text('ADD'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool _isTaskLengthValid() {
    return _textFieldController.value.text.isNotEmpty &&
        _textFieldController.value.text.length > 3 &&
        todoTask.relatedToResidentID != null;
  }

  void _addTodoItem(String title) {
    if (title.isEmpty) {
      return;
    }

    todoTask
      ..createdAt = Timestamp.now()
      ..task = title
      ..createdBy = 'NU001' //TODO change with current logged in user
      ..isCompleted = false;

    todoTask.toBeDoneAt ??= Timestamp.now();

    // Add a new document with a generated ID
    db.collection("todos").add(todoTask.toJson()).then(
        (DocumentReference doc) =>
            debugPrint('DocumentSnapshot added with ID: ${doc.id}'));
    _textFieldController.clear();
  }
}
