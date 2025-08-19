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
            onPressed: () { },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "addCategory",
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
} 