import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aclivite/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class ImageClassifier {
  static List<Map<String, dynamic>> _recognitions = [];

  static Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  static Future<List<Map<String, dynamic>>> classifyImage(File image) async {
    List<dynamic>? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (recognitions != null) {
      _recognitions = List<Map<String, dynamic>>.from(
        recognitions.map((dynamic item) => Map<String, dynamic>.from(item)),
      );
    } else {
      _recognitions = [];
    }

    return _recognitions;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController minParticipantsController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  String base64Image = "";
  bool shouldUpdateCategory = false;

  void _addActivityToFirebase() {
    FirebaseFirestore.instance.collection('activities').add({
      'title': titleController.text,
      'price': double.tryParse(priceController.text) ?? 0.0,
      'imageUrl': base64Image,
      'location': locationController.text,
      'minParticipants': int.tryParse(minParticipantsController.text) ?? 0,
      'category': categoryController.text,
    }).then((value) {
      titleController.clear();
      priceController.clear();
      locationController.clear();
      minParticipantsController.clear();
      categoryController.clear();
      base64Image = ""; 
      shouldUpdateCategory = false; 
    }).catchError((error) {
      print("Erreur d'ajout: $error");
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print("Déconnexion avec succès");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginEcran(),
        ),
      );
      print("Déconnexion avec succès");
    } catch (e) {
      print('Erreur de déconnexion: $e');
    }
  }

  Future<void> _pickAndConvertImage() async {
  try {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      List<int> imageBytes = File(pickedFile.path).readAsBytesSync();
      base64Image = base64Encode(imageBytes);

      await ImageClassifier.loadModel();
      List<Map<String, dynamic>> recognitions =
          await ImageClassifier.classifyImage(File(pickedFile.path));

      if (recognitions.isNotEmpty) {
        setState(() {
          shouldUpdateCategory = true;
          categoryController.text = recognitions[0]['label'];
        });
      }
    }
  } catch (e) {
    print("Error picking image: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toutes les activités'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await _signOut(context);
                print('Déconnexion réussie...');
              } catch (e) {
                print('Erreur lors de la déconnexion : $e');
              }
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Titre'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Lieu'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: minParticipantsController,
                decoration: InputDecoration(
                    labelText: 'Nombre minimum de participants'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  enabled: !shouldUpdateCategory,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await _pickAndConvertImage();
                },
                child: Text('Choisir une image'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _addActivityToFirebase();
                },
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
