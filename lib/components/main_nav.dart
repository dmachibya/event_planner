import 'package:event_planner/screens/client_requests.dart';
import 'package:event_planner/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../screens/admin_requests.dart';
import '../screens/profile_screen.dart';
import '../utils/authentication.dart';

class MainNav extends StatefulWidget {
  final index;
  MainNav({Key? key, this.index}) : super(key: key);

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _currentIndex = 0;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    updateNav();
    // _pageController = PageController();
  }

  void updateNav() {
    setState(() {
      _currentIndex = widget.index;
      // _pageController.jumpTo(double.parse(_currentIndex));
    });
  }

  List<Widget> screens = [
    SuccessfulScreen(),
    AuthenticationHelper().isAdmin
        ? MaombiKukodiScreen()
        : ClientRequestsScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.pink,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.pink,
        items: <Widget>[
          Icon(
            Icons.home_outlined,
            size: 30,
            color: Colors.white,
          ),
          Icon(Icons.calendar_month_outlined, size: 30, color: Colors.white),
          Icon(Icons.account_circle_outlined, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          //Handle button tap
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: screens),
        ),
      ),
    );
  }
}
