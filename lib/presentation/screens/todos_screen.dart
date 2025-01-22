import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app_sqflite/common/enums/category_enum.dart';
import 'package:todo_app_sqflite/data/models/todo_model.dart';
import 'package:todo_app_sqflite/presentation/widgets/todo_container.dart';
import 'package:todo_app_sqflite/providers/todo_provider.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen>
    with SingleTickerProviderStateMixin {
  final titleController = TextEditingController();
  DateTime? selectedDay2;
  DateTime selectedDate = DateTime.now();
  late final slidableController = SlidableController(this);

  void deleteDialog({required TodoProvider provider, required int id}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Are you sure delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<TodoProvider>().deleteTodo(id: id);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: Text(
                "YES",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          right: 16,
          left: 16,
          bottom: 20,
        ),
        child: Column(
          children: [
            TableCalendar(
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDay2 = selectedDay;
                });
                context.read<TodoProvider>().getTodos();
              },
              onPageChanged: (focusedDay) {
                selectedDay2 = focusedDay;
              },
              daysOfWeekHeight: 25,
              firstDay: DateTime.utc(2025, 01, 01),
              lastDay: DateTime.utc(2030, 3, 15),
              focusedDay: selectedDay2 ?? DateTime.now(),
              calendarFormat: CalendarFormat.week,
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay2, day);
              },
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(color: Colors.red),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue, // Change this to your desired color
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: Colors.red, // Text color for selected day
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  if (todoProvider.isLoading) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  final todosData = todoProvider.todos.where((todo) {
                    return selectedDay2 != null &&
                        DateUtils.isSameDay(todo.date, selectedDay2!);
                  }).toList();

                  if (todosData.isEmpty) {
                    return Center(
                      child: Text("No todos found for selected date"),
                    );
                  }

                  return ListView.builder(
                    itemCount: todosData.length,
                    itemBuilder: (context, index) {
                      final TodoModel todo = todosData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TodoContainer(
                          todo: todo,
                          todoProvider: todoProvider,
                          delete: () {
                            deleteDialog(
                              provider: todoProvider,
                              id: todo.id!,
                            );
                          },
                          update: () {
                            updateTodo(context: context, id: todo.id!);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskDialog(
            context: context,
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void updateTodo({required BuildContext context, required int id}) {
    final todos = context.read<TodoProvider>().todos;

    final newTodo = todos.firstWhere((todo) => todo.id == id);

    titleController.text = newTodo.title.toString();

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter todo title",
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Selected Date: "),
                  Text(
                    "${newTodo.date}".split(' ')[0],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        selectedDate = pickedDate;
                        setState(() {});
                        (context as Element).markNeedsBuild();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.read<TodoProvider>().editTodo(
                      id: id,
                      title: titleController.text.trim(),
                      date: selectedDate.toIso8601String(),
                    );
                titleController.clear();

                Navigator.of(context).pop();
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void addTaskDialog({
    required BuildContext context,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter todo title",
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Selected Date: "),
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        selectedDate = pickedDate;
                        setState(() {});
                        (context as Element).markNeedsBuild();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.read<TodoProvider>().addTodo(
                      title: titleController.text.trim(),
                      dateTime: selectedDate
                          .toIso8601String(), // Save the selected date
                      category: CategoryEnum.Exercise,
                    );
                titleController.clear();
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
