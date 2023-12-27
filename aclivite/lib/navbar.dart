
import 'package:flutter/material.dart';
import 'package:aclivite/Afficher_Activity.dart';
import 'package:aclivite/home.dart';
import 'package:aclivite/UserProfilePage.dart';


class MyNavBarButtom extends StatefulWidget {
  const MyNavBarButtom({Key? key}) : super(key: key);

  @override
  State<MyNavBarButtom> createState() => _MyNavBarButtomState();
}

class _MyNavBarButtomState extends State<MyNavBarButtom> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
     AfficherActivity() ,
HomePage(),
UserProfilePage()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sports,
              size: 30,
              color: _currentIndex == 0
                  ? Color.fromARGB(255, 56, 131, 197)
                  : Colors.grey,
            ),
            label: "Activité ",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: _currentIndex == 1
                  ? const Color.fromARGB(255, 56, 131, 197)
                  : Colors.grey,
              size: 30,
            ),
            label: "Ajouter",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 2
                  ? const Color.fromARGB(255, 56, 131, 197)
                  : Colors.grey,
              size: 30,
            ),
            label: "profile",
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(index);
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}