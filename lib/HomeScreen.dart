import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_taskmate/db_service/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';

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
    if (!mounted) return; // Prevent setState after dispose

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

class _HomeScreen extends State<HomeScreen> {
  bool Personal = true, College = false, Office = false;
  bool suggest = false;
  TextEditingController todoController = TextEditingController();
  Stream? todoStream;

  getonTheLoad() async {
    todoStream = await DatabaseService().getTask(
      Personal
          ? "Personal"
          : College
          ? "College"
          : "Office",
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getWork() {
    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot docSnap = snapshot.data.docs[index];
                    return CheckboxListTile(
                      activeColor: Colors.greenAccent.shade700,
                      title: Text(docSnap["work"]),
                      value: docSnap["Yes"],
                      onChanged: (newValue) async {
                        await DatabaseService().tickMethod(
                          docSnap["Id"],
                          Personal
                              ? "Personal"
                              : College
                              ? "College"
                              : "Office",
                        );
                        setState(() {
                          Future.delayed(
                            Duration(seconds: 2),
                            () => DatabaseService().removeMethod(
                              docSnap["Id"],
                              Personal
                                  ? "Personal"
                                  : College
                                  ? "College"
                                  : "Office",
                            ),
                          );
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent.shade700,
        onPressed: () {
          openBox();
        },
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 70, left: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white54, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

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
                        return GestureDetector(
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
                            margin: EdgeInsets.only(right: 8),
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
                        );
                      }).toList(),
                    ),
                  ),
            SizedBox(height: 20),
            taskList(),
          ],

            Container(
              child: Text(
                "Let's Start....",
                style: TextStyle(fontSize: 50, color: Colors.black54),
              ),
            ),

            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Personal
                    ? Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(20),

                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Personal",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = true;
                          College = false;
                          Office = false;
                          await getonTheLoad();
                          setState(() {});
                        },
                        child: Text("Personal", style: TextStyle(fontSize: 20)),
                      ),

                College
                    ? Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(20),

                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "College",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = false;
                          College = true;
                          Office = false;
                          await getonTheLoad();
                          setState(() {});
                        },
                        child: Text("College", style: TextStyle(fontSize: 20)),
                      ),

                Office
                    ? Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(20),

                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Office",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = false;
                          College = false;
                          Office = true;
                          await getonTheLoad();
                          setState(() {});
                        },
                        child: Text("Office", style: TextStyle(fontSize: 20)),
                      ),
              ],
            ),

            SizedBox(height: 20),

            getWork(),
          ],
        ),
      ),
    );
  }

  Future openBox() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel),
                    ),

                    SizedBox(width: 40.0),
                    Text(
                      "Add ToDo Task",
                      style: TextStyle(color: Colors.greenAccent.shade700),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),
                Text("Add Text"),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                  ),
                  child: TextField(
                    controller: todoController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter the task",
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      String task = todoController.text.trim();
                      if (task.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Task cannot be empty")),
                        );
                        return;
                      }

                      String id = randomAlphaNumeric(10);
                      Map<String, dynamic> userTodo = {
                        "work": task,
                        "Id": id,
                        "timestamp": DateTime.now(),
                        "Yes": false,
                      };

                      try {
                        if (Personal) {
                          await DatabaseService().addPersonalTask(userTodo, id);
                        } else if (College) {
                          await DatabaseService().addCollegeTask(userTodo, id);
                        } else {
                          await DatabaseService().addOfficeTask(userTodo, id);
                        }
                        Navigator.pop(context);
                        todoController.clear();
                      } catch (e) {
                        print("Firestore error: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to add task")),
                        );
                      }
                    },
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade700,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
