import 'package:daily_taskmate/db_service/database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool Personal = true, College = false, Office = false;
  bool suggest = false;
  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 4, 130, 69),
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
            colors: [
              // const Color.fromARGB(255, 165, 235, 202),
              // Colors.white,
              // const Color.fromARGB(255, 116, 152, 120),
              Colors.white,
              Colors.white54,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                            color: Colors.greenAccent.shade400,
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
                        onTap: () {
                          Personal = true;
                          College = false;
                          Office = false;
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
                            color: Colors.greenAccent.shade400,
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
                        onTap: () {
                          Personal = false;
                          College = true;
                          Office = false;
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
                            color: Colors.greenAccent.shade400,
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
                        onTap: () {
                          Personal = false;
                          College = false;
                          Office = true;
                          setState(() {});
                        },
                        child: Text("Office", style: TextStyle(fontSize: 20)),
                      ),
              ],
            ),

            SizedBox(height: 20),

            CheckboxListTile(
              activeColor: Colors.greenAccent.shade700,
              title: Text("Morning Exercise !"),
              value: suggest,
              onChanged: (newValue) {
                setState(() {
                  suggest = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),

            CheckboxListTile(
              activeColor: Colors.greenAccent.shade700,
              title: Text("College Work!"),
              value: suggest,
              onChanged: (newValue) {
                setState(() {
                  suggest = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),

            CheckboxListTile(
              activeColor: Colors.greenAccent.shade700,
              title: Text("Finish a Project!"),
              value: suggest,
              onChanged: (newValue) {
                setState(() {
                  suggest = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  openBox() {
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

                    SizedBox(width: 60.0),
                    Text(
                      "Add ToDo Task",
                      style: TextStyle(color: Colors.greenAccent.shade400),
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
                        print("❌ Firestore error: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to add task")),
                        );
                      }
                    },
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.black),
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
