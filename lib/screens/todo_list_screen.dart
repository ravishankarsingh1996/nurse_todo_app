import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nurse_todo_app/extensions/date_time_extension.dart';
import 'package:nurse_todo_app/model/residents.dart';
import 'package:nurse_todo_app/model/shift.dart';
import 'package:nurse_todo_app/model/todo.dart';
import 'package:nurse_todo_app/screens/create_todo_screen.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late FirebaseFirestore db;
  late Stream<QuerySnapshot> _todosStream;
  final List<Shift> _shiftsList = [];
  final List<Residents> _residentsList = [];
  Residents? selectedResident;

  @override
  void initState() {
    super.initState();
    ;
    db = FirebaseFirestore.instance;
    _initTodoStream('');
    _getActiveResidentsData();
    _getShiftsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _todosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading..."));
          }

          return Container(
            color: Colors.grey.withOpacity(0.3),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Today\'s Task',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DropdownButton<Residents>(
                          // Initial Value
                          value: selectedResident,
                          hint: const Text('',
                              style: TextStyle(
                                color: Colors.black,
                              )),
                          isExpanded: false,
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          // Array list of items
                          items: _residentsList.map((Residents items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items.name ?? ''),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (Residents? newValue) {
                            setState(() {
                              selectedResident = newValue;
                              _initTodoStream(selectedResident?.id ?? '');
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  Expanded(
                    child: ListView(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                            Todo todoData = Todo.fromDocumentSnapshot(
                                document.id,
                                document.data()! as Map<String, dynamic>);

                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: CheckboxListTile(
                                title: Text(todoData.task ?? ''),
                                subtitle: Text(
                                  todoData.toBeDoneAt
                                          ?.toDate()
                                          .formatDateYYYYMMDDHHMM ??
                                      '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                value: todoData.isCompleted ?? false,
                                tileColor: Colors.white,
                                checkColor: Colors.blue,
                                secondary: const Icon(Icons.note_alt_sharp),
                                onChanged: (bool? value) {
                                  todoData.isCompleted = value;
                                  _updateTodoItem(todoData);
                                },
                              ),
                            );
                          })
                          .toList()
                          .cast(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CreateTodoScreen(
            residentsList: _residentsList,
          );
        })),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _initTodoStream(String residentsId) {
    _todosStream = db
        .collection('todos')
        .orderBy('toBeDoneAt', descending: false)
        .where('relatedToResidentID', isEqualTo: residentsId)
        .where('isCompleted', isEqualTo: false)
        .snapshots();
  }

  void _updateTodoItem(Todo todoTask) {
    if (todoTask == null) {
      return;
    }
    // Update a document with a doc ID
    db.collection("todos").doc(todoTask.id).update(todoTask.toJson()).then(
        (value) =>
            debugPrint('DocumentSnapshot updated for ID: ${todoTask.id}'));
  }

  void _getShiftsData() async {
    var querySanpshot = await db.collection('shifts').get();
    for (var element in querySanpshot.docs) {
      Shift shift = Shift.fromDocumentSnapshot(element.data());
      _shiftsList.add(shift);
    }
  }

  // TODO Check task time is between the shift range
  void _isTaskInCurrentShift(Timestamp timestamp) {
    var dateTime = timestamp.toDate();
    Shift currentShift = _shiftsList.firstWhere((element) {
      // Todo add check
      return false;
    }, orElse: () => Shift());

    debugPrint(currentShift.name);
  }

  void _getActiveResidentsData() async {
    var querySanpshot = await db
        .collection('residents')
        .where('isActivePatient', isEqualTo: true)
        .get();
    for (var element in querySanpshot.docs) {
      Residents resident = Residents.fromDocumentSnapshot(element.data());
      _residentsList.add(resident);
    }
    setState(() {
      selectedResident = _residentsList[0];
      _initTodoStream(selectedResident?.id ?? '');
    });
  }
}
