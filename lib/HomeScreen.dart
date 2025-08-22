import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_taskmate/db_service/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseService dbService;
  String selectedCategory = "";
  List<String> categories = [];
  TextEditingController todoController = TextEditingController();
  Stream<QuerySnapshot>? todoStream;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    dbService = DatabaseService(user.email!);
    loadCategories();
  }

  void loadCategories() async {
    final snapshot = await dbService.getCategories();
    setState(() {
      categories = snapshot.docs.map((doc) => doc.id).toList();
      if (categories.isNotEmpty) {
        selectedCategory = categories[0];
        loadTasks();
      }
    });
  }

  void deleteCategory(String categoryName) async {
    await dbService.deleteCategory(categoryName);
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily TaskMate"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "addTask",

            onPressed: () {
                            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Add Task"),
                  content: TextField(
                    controller: todoController,
                    decoration: InputDecoration(hintText: "Enter task..."),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (todoController.text.isNotEmpty &&
                            selectedCategory.isNotEmpty) {
                          await dbService.addTask(
                            selectedCategory,
                            todoController.text,
                          );
                          todoController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Add"),
                    ),
                  ],
                ),
              );
            },

            onPressed: () {},

            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "addCategory",

            onPressed: () {
                            TextEditingController categoryController =
                  TextEditingController();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Add Category"),
                  content: TextField(
                    controller: categoryController,
                    decoration: InputDecoration(hintText: "Enter category..."),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (categoryController.text.isNotEmpty) {

                          await dbService.addCategory(categoryController.text);
                          Navigator.pop(context);
                          loadCategories();
                        }
                      },
                      child: Text("Add"),
                    ),
                  ],
                ),
              );
            },

            onPressed: () {},

            child: Icon(Icons.create_new_folder),
          ),
        ],
      ),
      body: Column(
        children: [
          categoryList(),
          Expanded(child: taskList()),
        ],

      ),
    );
  }

    Widget categoryList() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onLongPress: () {

              deleteCategory(category);
            },
            onTap: () {
              setState(() {
                selectedCategory = category;
                loadTasks();
              });
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selectedCategory == category
                    ? Colors.blue
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: selectedCategory == category
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },

      ),
    );
  }

    Widget taskList() {
    if (todoStream == null) return Center(child: Text("No category selected"));

    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final tasks = snapshot.data!.docs;
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task['title']),
              trailing: Checkbox(
                value: task['isDone'],
                onChanged: (val) async {
                  // ==== BACKEND WRITER 2 (Update Task Status/Delete) ====
                  if (val == true) {
                    await dbService.updateTask(selectedCategory, task.id, true);
                    await dbService.deleteTask(selectedCategory, task.id);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
