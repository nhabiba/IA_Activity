import 'dart:convert';
import 'dart:typed_data';
import 'package:aclivite/Model/Mode_activity.dart';
import 'package:aclivite/UserProfilePage.dart';
import 'package:aclivite/home.dart';
import 'package:aclivite/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AfficherActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Liste des activités')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Liste des activités')),
            body: Center(child: Text('Une erreur s\'est produite.')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text('Liste des activités')),
            body: Center(child: Text('Aucune catégorie trouvée.')),
          );
        } else {
          return DefaultTabController(
            length: snapshot.data!.length + 1,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Liste des activités'),
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
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'Toutes'),
                    ...snapshot.data!.map((category) => Tab(text: category)),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  FilteredActivityList(category: null),
                  ...snapshot.data!.map((category) {
                    return FilteredActivityList(category: category);
                  }),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<String>> _fetchCategories() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('activities').get();
    final List<String> categories = [];

    querySnapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final category = data['category'] as String;
      if (!categories.contains(category)) {
        categories.add(category);
      }
    });

    return categories;
  }
}

class FilteredActivityList extends StatelessWidget {
  final String? category;

  const FilteredActivityList({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: category != null
          ? FirebaseFirestore.instance
              .collection('activities')
              .where('category', isEqualTo: category)
              .snapshots()
          : FirebaseFirestore.instance.collection('activities').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Une erreur s\'est produite.'),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('Aucune activité pour le moment.'),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final activityDetails = Activity.fromJson(
                snapshot.data!.docs[index].data() as Map<String, dynamic>,
              );
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: _buildActivityImage(activityDetails.imageUrl),
                  title: Row(
                    children: [
                      Text(
                        activityDetails.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailActivityPage(
                                activity: activityDetails,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('activities')
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.attach_money),
                      Text('\$${activityDetails.price.toStringAsFixed(2)}'),
                      SizedBox(width: 10),
                      Icon(Icons.location_on),
                      Text(activityDetails.location),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildActivityImage(String imageUrl) {
    final Uint8List? imageBytes = base64Decode(imageUrl);
    return imageBytes != null
        ? Image.memory(
            imageBytes,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          )
        : PlaceholderImage();
  }
}

class PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with your desired placeholder widget or logic
    return SizedBox(
      width: 50,
      height: 50,
      child: Placeholder(),
    );
  }
}

void _onNavBarItemTapped(BuildContext context, int index) {
  if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AfficherActivity()),
    );
  } else if (index == 1) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserProfilePage()),
    );
  } else if (index == 2) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}

class DetailActivityPage extends StatelessWidget {
  final Activity activity;

  DetailActivityPage({required this.activity});

  Widget _buildActivityImage(String imageUrl) {
    final Uint8List? imageBytes = base64Decode(imageUrl);
    return imageBytes != null
        ? Image.memory(
            imageBytes,
            fit: BoxFit.cover,
          )
        : PlaceholderImage();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Détails de l\'activité'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: _buildActivityImage(activity.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.attach_money),
                      Text('\$${activity.price.toStringAsFixed(2)}'),
                      SizedBox(width: 20),
                      Icon(Icons.location_on),
                      Text(activity.location),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.category),
                      Text(activity.category),
                      SizedBox(width: 20),
                      Icon(Icons.group),
                      Text('${activity.minParticipants} Participants'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Fermer'),
        ),
      ],
    );
  }
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

void main() {
  runApp(MaterialApp(
    home: AfficherActivity(),
  ));
}
