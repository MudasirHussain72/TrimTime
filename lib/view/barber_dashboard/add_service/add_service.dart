import 'package:barbar_booking_app/res/components/input_text_field.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:flutter/material.dart';

class AddServicesScreen extends StatefulWidget {
  const AddServicesScreen({super.key});

  @override
  State<AddServicesScreen> createState() => _AddServicesScreenState();
}

class _AddServicesScreenState extends State<AddServicesScreen> {
  final serviceNameController = TextEditingController();
  final priceController = TextEditingController();
  final serviceNameFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add service')),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          InputTextField(
              myController: serviceNameController,
              focusNode: serviceNameFocusNode,
              onFieldSubmittedValue: (newValue) => Utils.fieldFocus(
                  context, serviceNameFocusNode, serviceNameFocusNode),
              onValidator: (value) =>
                  value.isEmpty ? "Enter service name" : null,
              keyBoardType: TextInputType.name,
              hint: 'Service Name',
              obscureText: false),
          InputTextField(
              myController: priceController,
              focusNode: priceFocusNode,
              onFieldSubmittedValue: (newValue) {},
              onValidator: (value) => value.isEmpty ? "Enter price" : null,
              keyBoardType: TextInputType.number,
              hint: 'Price',
              obscureText: false),
        ]),
      ),
    );
  }
}
