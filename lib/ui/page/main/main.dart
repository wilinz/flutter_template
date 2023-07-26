import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home/home.dart';
import 'profile/profile.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MainPage();
  }
}

class _MainPage extends StatefulWidget {
  const _MainPage({Key? key}) : super(key: key);

  @override
  State<_MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  int selected = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          children: [HomePage(), ProfilePage()],
          onPageChanged: (index) {
            setState(() {
              selected = index;
            });
          },
          controller: pageController,
        ),
        bottomNavigationBar: NavigationBar(
            destinations: [
              NavigationDestination(
                tooltip: 'home_page'.tr,
                icon: Icon(Icons.home_outlined),
                label: 'home_page'.tr,
                selectedIcon: Icon(Icons.home),
              ),
              NavigationDestination(
                tooltip: 'my'.tr,
                icon: Icon(Icons.person_outlined),
                label: 'my'.tr,
                selectedIcon: Icon(Icons.person),
              )
            ],
            onDestinationSelected: (index) {
              pageController.animateToPage(index,
                  duration: Duration(milliseconds: 200), curve: Curves.linear);
            },
            selectedIndex: selected));
  }
}
