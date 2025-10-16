import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firestore_app/Utils/constants.dart';
import 'package:firebase_firestore_app/notification_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  String selectedDate = DateTime.now().toString().split(" ").first;
  File? selectedImage;

  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.onTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print("DEVICE TOKEN: $value");
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      setState(() {});
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> uploadData() async {
    try {
      final id = const Uuid().v4();
      // firebase will auto-generate the id
      // await FirebaseFirestore.instance.collection("tasks").add({
      await FirebaseFirestore.instance.collection("tasks").doc(id).set({
        "id": id,
        "user": FirebaseAuth.instance.currentUser!.uid,
        "title": titleController.text.trim(),
        "description": descController.text.trim(),
        "date": selectedDate,
      });
    } catch (e) {
      if (mounted) {
        showSnackBar(context, Colors.red, e.toString());
      }
    }
  }

  void showTaskBottomSheet({bool isUpdate = false, String? docId}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                    ),
                    color: Colors.orangeAccent.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          isUpdate ? "Update Task" : "Add New Task",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12,
                          bottom: 8,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2050),
                              initialDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setModalState(() {
                                selectedDate =
                                    pickedDate.toString().split(" ").first;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            selectedDate.toString().split(" ").first,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12,
                          bottom: 8,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            pickImage();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            elevation: 10,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Pick Image from Gallery",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      selectedImage == null
                          ? SizedBox.shrink()
                          : Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12,
                              bottom: 8,
                            ),
                            child: Image.file(selectedImage!),
                          ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12,
                          bottom: 8,
                        ),
                        child: TextField(
                          controller: titleController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: "Title",
                            hintStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: MyConstants.eBorder,
                            focusedBorder: MyConstants.fBorder,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12,
                          bottom: 12,
                        ),
                        child: TextField(
                          controller: descController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Description",
                            hintStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: MyConstants.eBorder,
                            focusedBorder: MyConstants.fBorder,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12,
                          bottom: 8,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            if (isUpdate) {
                              FirebaseFirestore.instance
                                  .collection("tasks")
                                  .doc(docId)
                                  .update({
                                    "title": titleController.text.trim(),
                                    "description": descController.text.trim(),
                                    "date": selectedDate,
                                  });
                              showSnackBar(
                                context,
                                Colors.green,
                                "Task Updated!",
                              );
                            } else {
                              showSnackBar(
                                context,
                                Colors.green,
                                "Task Added!",
                              );
                              await uploadData();
                            }
                            titleController.clear();
                            descController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isUpdate ? "UPDATE" : "SUBMIT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTaskBottomSheet();
        },
        backgroundColor: Colors.orangeAccent.shade100,
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Hello, ${FirebaseAuth.instance.currentUser?.email}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("SIGN OUT", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("MY TASKS", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection("tasks")
                      .where(
                        "user",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                      )
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text("No Data Found!"));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Dismissible(
                          key: ValueKey(snapshot.data!.docs[index].id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                          ),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              showSnackBar(
                                context,
                                Colors.red,
                                "Task Deleted!",
                              );
                              await FirebaseFirestore.instance
                                  .collection("tasks")
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete();
                            }
                          },
                          child: ListTile(
                            onTap: () {
                              final doc = snapshot.data!.docs[index];
                              titleController.text = doc["title"];
                              descController.text = doc["description"];
                              selectedDate = doc["date"];
                              showTaskBottomSheet(
                                isUpdate: true,
                                docId: doc.id,
                              );
                            },
                            title: Text(
                              snapshot.data!.docs[index].data()["title"],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data!.docs[index]
                                      .data()["description"],
                                ),
                                Text(snapshot.data!.docs[index].data()["date"]),
                              ],
                            ),
                            tileColor: Colors.orangeAccent.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
