import 'dart:developer';

import 'package:barbar_booking_app/api/apis.dart';
import 'package:barbar_booking_app/res/components/choose_location_button.dart';
import 'package:barbar_booking_app/res/components/my_appbar.dart';
import 'package:barbar_booking_app/view/customer_dashboard/home/widgets/choose_location_bottomsheet.dart';
import 'package:barbar_booking_app/view/customer_dashboard/home/widgets/nearby_data.dart';
import 'package:barbar_booking_app/view_model/customer_dashboard/customer_home/customer_home_controller.dart';
import 'package:barbar_booking_app/view_model/services/notification_services.dart';
import 'package:barbar_booking_app/view_model/services/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
  }

  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermision();
    notificationServices.firebaseInit(context);
    //notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      APIs().addDeviceToken(
          'deviceTokens', SessionController().userId.toString(), value);
      print('device token');
      log(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    log('build');
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size * 1;
    // var provider = Provider.of<CustomerHomeController>(context, listen: true);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Column(
          children: [
            //top bar
            MyAppBar(
                oniconTap: () {
                  // for setting up current location
                  showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      builder: (context) => const ChooseLocationBottomSheet());
                },
                title: 'Find services near you',
                icon: Icons.location_on_rounded),
            // show location area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<CustomerHomeController>(
                  builder: (context, provider, child) {
                return ChooseLocationButton(
                    title: provider.addressLine.toString(),
                    onPress: () {
                      // for setting up current location
                      showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          builder: (context) =>
                              const ChooseLocationBottomSheet());
                    },
                    iconColor: Colors.transparent);
              }),
            ),
            // show nearby data
            const NearbyData()
          ],
        ),
      )),
    );
  }
}
