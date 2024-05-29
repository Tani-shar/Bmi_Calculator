// ignore_for_file: prefer_const_constructors, unnecessary_const, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> deleteElementFromFirebase(String firebaseKey) async {
    try {
      await FirebaseFirestore.instance
          .collection('history')
          .doc(firebaseKey)
          .delete();
      print('Element deleted successfully');
    } catch (e) {
      print('Error deleting element: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 126, 103, 103),
      appBar: AppBar(
          title: Text('History'),
          backgroundColor: Color.fromARGB(255, 126, 122, 212)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final firebaseKey = docs[index].id;
              final currentTime = Timestamp.fromMicrosecondsSinceEpoch(
                  DateTime.now().millisecondsSinceEpoch);
              final Timestamp timestamp =
                  data['timestamp'] == null ? currentTime : data['timestamp'];

              // final Timestamp timestamp = data['timestamp'];
              final DateTime dateTime = timestamp.toDate();

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  tileColor: Color.fromARGB(255, 208, 202, 202),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    'BMI: ${data['bmi']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weight: ${data['weight']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'height: ${data['height']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Time: ${DateFormat('yyyy-MM-dd HH:mm').format(dateTime)}', // Format the timestamp
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      // Call a function to delete the element from Firebase
                      deleteElementFromFirebase(
                          firebaseKey); // Replace 'firebaseKey' with the actual key or identifier
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
