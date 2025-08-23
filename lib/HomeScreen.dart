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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      dbService = DatabaseService(user.email!);
      loadCategories();
    }
  }

  Future<void> loadCategories() async {
    final cats = await dbService.getCategories();
    if (!mounted) return;

    setState(() {
      categories = cats;
      if (categories.isNotEmpty) {
        selectedCategory = categories.first;
        loadTasks();
      } else {
        selectedCategory = "";
        todoStream = null;
      }
    });
  }

  void loadTasks() {
    if (selectedCategory.isEmpty) {
      todoStream = null;
    } else {
      todoStream = dbService.getTasks(selectedCategory);
    }
    if (mounted) setState(() {});
  }

  Widget taskList() {
    if (todoStream == null) {
      return Expanded(child: Center(child: Text("No category selected.")));
    }

    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: todoStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          if (snapshot.data!.docs.isEmpty)
            return Center(child: Text("No tasks found."));

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return CheckboxListTile(
                activeColor: const Color(0xFF003049),
                title: Text(doc['work']),
                value: doc['Yes'],
                onChanged: (bool? newValue) async {
                  if (newValue == true) {
                    await dbService.tickTask(selectedCategory, doc.id);
                    Future.delayed(Duration(seconds: 2), () async {
                      if (mounted) {
                        await dbService.removeTask(selectedCategory, doc.id);
                      }
                    });
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> showAddTaskDialog() async {
    todoController.clear();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Task"),
        backgroundColor: const Color(0xfffdf0d5),
        content: TextField(
          controller: todoController,
          decoration: InputDecoration(hintText: "Enter the task"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Color(0xffc1121f))),
          ),
          ElevatedButton(
            onPressed: () async {
              final task = todoController.text.trim();
              if (task.isEmpty) return;

              final taskMap = {
                'work': task,
                'timestamp': DateTime.now(),
                'Yes': false,
              };

              await dbService.addTask(selectedCategory, taskMap);
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: Text("Add", style: TextStyle(color: Color(0xff003049))),
          ),
        ],
      ),
    );
  }

  Future<void> showAddCategoryDialog() async {
    final categoryController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Category"),
        backgroundColor: const Color(0xfffdf0d5),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(hintText: "Category name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Color(0xffc1121f))),
          ),
          ElevatedButton(
            onPressed: () async {
              final catName = categoryController.text.trim();
              if (catName.isEmpty) return;

              await dbService.addCategory(catName);
              await loadCategories();
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: Text("Add", style: TextStyle(color: Color(0xff003049))),
          ),
        ],
      ),
    );
  }

  Future<void> deleteCategory(String category) async {
    await dbService.deleteCategory(category);
    await loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daily TaskMate",
          style: TextStyle(color: const Color(0xfffdf0d5)),
        ),
        backgroundColor: const Color(0xff669bbc),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFFfdf0d5)),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addCategory',
            backgroundColor: const Color(0xff780000),
            onPressed: showAddCategoryDialog,
            child: Icon(Icons.category, color: Color(0xFFfdf0d5)),
            tooltip: "Add Category",
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addTask',
            backgroundColor: const Color(0xff003049),
            onPressed: selectedCategory.isEmpty ? null : showAddTaskDialog,
            child: Icon(Icons.add, color: Color(0xFFfdf0d5)),
            tooltip: selectedCategory.isEmpty
                ? "Add category first"
                : "Add Task",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good to see you!", style: TextStyle(fontSize: 40)),
            SizedBox(height: 20),
            categories.isEmpty
                ? Center(child: Text("No categories found. Add some!"))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((cat) {
                        final isSelected = cat == selectedCategory;
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = cat;
                                  loadTasks();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                margin: EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xff780000)
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    color: isSelected
                                        ? const Color(0xfffdf0d5)
                                        : const Color(0xff003049),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteCategory(cat),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
            SizedBox(height: 20),
            taskList(),
          ],
        ),
      ),
    );
  }
}
