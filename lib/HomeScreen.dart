import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  bool Personal = true, College = false, Office = false;
  bool suggest = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 4, 130, 69),
        onPressed: (){},
        child: Icon(Icons.add,
        color: Colors.white,
        size: 30,
        ),
        ),
      body: Container(
        padding: EdgeInsets.only(top: 70,left: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 165, 235, 202),
              Colors.white,
              const Color.fromARGB(255, 116, 152, 120),
            ],
            begin:Alignment.topLeft,
            end: Alignment.bottomRight
            )
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              child: Text("hi",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black
              ),
              ),
            ),

            SizedBox(height: 10,),
            Container(
              child: Text("Let's Start....",
              style: TextStyle(
                fontSize: 50,
                color: Colors.black54
              ),
              ),
            ),

            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                Personal ? Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.shade400,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Personal",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ),
                ):GestureDetector(
                  onTap: (){
                    Personal=true;
                    College=false;
                    Office=false;
                     setState(() {
                      
                    });
                  },
                  child: Text("Personal",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  ),
                ),

                College ? Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.shade400,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("College",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ),
                ):GestureDetector(
                  onTap: (){
                    Personal=false;
                    College=true;
                    Office=false;
                     setState(() {
                      
                    });
                  },
                  child: Text("College",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  ),
                ),

                Office ? Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.shade400,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Office",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ),
                ):GestureDetector(
                  onTap: (){
                    Personal=false;
                    College=false;
                    Office=true;
                     setState(() {
                      
                    });
                  },
                  child: Text("Office",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20,),

            CheckboxListTile(
              activeColor: Colors.greenAccent.shade700,
              title: Text("Morning Exercise !"),
              value: suggest, onChanged: (newValue){
              setState(() {
                suggest=newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            ),


            CheckboxListTile(
              activeColor: Colors.greenAccent.shade700,
              title: Text("College Work!"),
              value: suggest, onChanged: (newValue){
              setState(() {
                suggest=newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            ),


            CheckboxListTile(
              activeColor: Colors.greenAccent.shade700,
              title: Text("Finish a Project!"),
              value: suggest, onChanged: (newValue){
              setState(() {
                suggest=newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }
}