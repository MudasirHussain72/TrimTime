import 'dart:io';
import 'package:barbar_booking_app/res/color.dart';
import 'package:barbar_booking_app/res/components/input_text_field.dart';
import 'package:barbar_booking_app/res/components/round_button.dart';
import 'package:barbar_booking_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddServicesScreen extends StatefulWidget {
  const AddServicesScreen({super.key});

  @override
  State<AddServicesScreen> createState() => _AddServicesScreenState();
}

class _AddServicesScreenState extends State<AddServicesScreen> {
  final _formkey = GlobalKey<FormState>();
  final serviceNameController = TextEditingController();
  final priceController = TextEditingController();
  final serviceNameFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  File? imageFile;
  getImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
      appBar: AppBar(title: const Text('Add service')),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        child: Form(
          key: _formkey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: size.height / 3.5,
                        width: size.width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.otpHintColor),
                        child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            child: imageFile == null
                                ? const Center(child: Text('Pick an image'))
                                : Image.file(imageFile!,
                                    width: 170,
                                    height: 170,
                                    fit: BoxFit.cover)),
                      ),
                      SizedBox(
                          width: size.width / 2.5,
                          child: RoundButton(
                              title: 'Pick Image',
                              onPress: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          content: SizedBox(
                                              height: 120,
                                              child: Column(children: [
                                                ListTile(
                                                    onTap: () {
                                                      getImage(context,
                                                          ImageSource.camera);
                                                      Navigator.pop(context);
                                                    },
                                                    leading: const Icon(
                                                        Icons.camera,
                                                        color: AppColors
                                                            .primaryIconColor),
                                                    title:
                                                        const Text('Camera')),
                                                ListTile(
                                                    onTap: () {
                                                      getImage(context,
                                                          ImageSource.gallery);
                                                      Navigator.pop(context);
                                                    },
                                                    leading: const Icon(
                                                        Icons.image,
                                                        color: AppColors
                                                            .primaryIconColor),
                                                    title:
                                                        const Text('Gallery'))
                                              ])));
                                    });
                              }))
                    ]),
                SizedBox(height: size.height * .025),
                InputTextField(
                    myController: serviceNameController,
                    focusNode: serviceNameFocusNode,
                    onFieldSubmittedValue: (newValue) => Utils.fieldFocus(
                        context, serviceNameFocusNode, priceFocusNode),
                    onValidator: (value) =>
                        value.isEmpty ? "Enter service name" : null,
                    keyBoardType: TextInputType.name,
                    hint: 'Service Name',
                    obscureText: false),
                InputTextField(
                    myController: priceController,
                    focusNode: priceFocusNode,
                    onFieldSubmittedValue: (newValue) {},
                    onValidator: (value) =>
                        value.isEmpty ? "Enter price" : null,
                    keyBoardType: TextInputType.number,
                    hint: 'Price',
                    obscureText: false),
                RoundButton(
                    title: 'Confirm',
                    onPress: () {
                      if (_formkey.currentState!.validate()) {
                        // provider.login(
                        //     context,
                        //     emailController.text.trim().toString(),
                        //     passwordController.text.trim().toString());
                      }
                    })
              ]),
        ),
      ),
    );
  }
}
