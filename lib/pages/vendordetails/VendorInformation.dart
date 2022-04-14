import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localport_alter/SharedPreferences/SharedPreferencesClass.dart';
import 'package:localport_alter/resources/MyColors.dart';
import 'package:localport_alter/resources/ServerConstants.dart';
import 'package:localport_alter/resources/Strings.dart';
import 'package:localport_alter/services/ApiServices/vendor_registration_service.dart';
import 'package:localport_alter/services/vendor_information_service.dart';
import 'package:localport_alter/widgets/AppDialogs.dart';
import 'package:provider/provider.dart';

import '../LandingPage.dart';

class VendorInformation extends StatefulWidget {
  @override
  VendorInformationState createState() => VendorInformationState();
}

class VendorInformationState extends State<VendorInformation> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _businessName = TextEditingController();
  TextEditingController _businessDescription = TextEditingController();

  saveVendorDetails() async {
    try {
      openProcessingDialog(context);
      File image = Provider.of<VendorInformationService>(context, listen: false)
          .getImage();
      List<int> _byteCode;
      String base64Image;
      if (image != null) {
        _byteCode = image.readAsBytesSync();
        base64Image = base64Encode(_byteCode);
      }
      String uid = await SharedPreferencesClass().getUid();
      Provider.of<VendorRegistrationService>(context, listen: false)
          .saveVendor(
              uid, _businessName.text, _businessDescription.text, base64Image)
          .then((value) {
        Navigator.pop(context);
        if (value == "") {
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => LandingPage()));
        }
        if (value == 500 ||
            value == SOMETHING_WENT_WRONG ||
            value == INVALID_REQUEST) {
          showFailMessage("Please try again after sometime");
        }
      });
    } catch (err) {
      print(err);
      showFailMessage("Please try again after sometime");
    }
  }

  showFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.color1,
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<VendorInformationService>(
              builder: (context, snapshot, child) {
            return ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                Text(
                  "Vendor Information",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Are you a business owner",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                        value: snapshot.getIsVendor(),
                        onChanged: (value) {
                          snapshot.setIsVendor(value);
                        })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                snapshot.getIsVendor()
                    ? Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ImagePicker()
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) {
                                  snapshot.setImage(File(value.path));
                                });
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 8,
                                    foregroundImage: snapshot.getImage() == null
                                        ? Image.asset(appIcon).image
                                        : Image.file(snapshot.getImage()).image,
                                  ),
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.6),
                                    child: Icon(Icons.image),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: _businessName,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter your business name";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Business Name',
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        fillColor: MyColors.color3,
                                        border: InputBorder.none),
                                    cursorColor: Colors.black,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: _businessDescription,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Describe your business";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'About your business',
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        fillColor: MyColors.color3,
                                        border: InputBorder.none),
                                    cursorColor: Colors.black,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    if (!snapshot.getIsVendor()) {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => LandingPage()));
                    } else {
                      if (snapshot.getIsVendor()) {
                        if (_formKey.currentState.validate()) {
                          saveVendorDetails();
                        }
                      } else {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => LandingPage()));
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: MyColors.colorDark,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(0, 0),
                              blurRadius: 6),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      child: Text(
                        "Proceed",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      )),
    );
  }
}
