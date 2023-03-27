import 'package:barbar_booking_app/res/components/choose_location_button.dart';
import 'package:barbar_booking_app/res/components/my_appbar.dart';
import 'package:barbar_booking_app/view/customer_dashboard/home/widgets/choose_location_bottomsheet.dart';
import 'package:barbar_booking_app/view/customer_dashboard/home/widgets/nearby_data.dart';
import 'package:barbar_booking_app/view_model/customer_dashboard/customer_home/customer_home_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    var provider = Provider.of<CustomerHomeController>(context, listen: true);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Column(
          children: [
            //top bar
            MyAppBar(onSearchTap: () {}, title: 'Find services near you'),
            // show location area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ChooseLocationButton(
                  title: provider.addressLine.toString(),
                  onPress: () {
                    // for setting up currnt location
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => ChooseLocationBottomSheet());
                    // setState(() {});
                  },
                  iconColor: Colors.transparent),
            ),
            // show nearby data
            const NearbyData()
          ],
        ),
      )),
    );
  }
}
