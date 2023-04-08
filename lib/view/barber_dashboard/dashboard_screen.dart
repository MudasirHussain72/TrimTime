// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/view/barber_dashboard/all_bookings/my_all_shop_bookings.dart';
import 'package:barbar_booking_app/view/barber_dashboard/home/barber_home_screen.dart';
import 'package:barbar_booking_app/view/barber_dashboard/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BarberDashboardScreen extends StatefulWidget {
  const BarberDashboardScreen({super.key});

  @override
  State<BarberDashboardScreen> createState() => _BarberDashboardScreenState();
}

class _BarberDashboardScreenState extends State<BarberDashboardScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  List<Widget> _buildScreen() {
    return [
      const BarberHomeScreen(),
      // const Scaffold(
      //   body: Center(
      //     child: Text('Barber search'),
      //   ),
      // ),
      // const Scaffold(
      //   body: Center(
      //     child: Text("Barber add post screen"),
      //   ),
      // ),
      const MyAllShopBookings(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.home, color: AppColors.navIconColor),
          inactiveIcon: Icon(Icons.home, color: Colors.grey.shade100),
          activeColorPrimary: AppColors.primaryIconColor),
      // PersistentBottomNavBarItem(
      //     icon: Icon(CupertinoIcons.search, color: AppColors.navIconColor),
      //     activeColorPrimary: AppColors.primaryIconColor,
      //     inactiveIcon:
      //         Icon(CupertinoIcons.search, color: Colors.grey.shade100)),
      // PersistentBottomNavBarItem(
      //     icon: Icon(Icons.add, color: AppColors.navIconColor),
      //     activeColorPrimary: AppColors.navIconColor,
      //     inactiveIcon: Icon(Icons.add, color: Colors.grey.shade100)),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.calendar, color: AppColors.navIconColor),
          inactiveIcon:
              Icon(CupertinoIcons.calendar, color: Colors.grey.shade100),
          activeColorPrimary: AppColors.primaryIconColor),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.person_outline, color: AppColors.navIconColor),
          inactiveIcon: Icon(Icons.person_outline, color: Colors.grey.shade100),
          activeColorPrimary: AppColors.primaryIconColor),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreen(),
      items: _navBarItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.grey.shade400, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(20),
        adjustScreenBottomPaddingOnCurve: false,
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style12,
      margin: const EdgeInsets.all(20),
    );
  }
}
