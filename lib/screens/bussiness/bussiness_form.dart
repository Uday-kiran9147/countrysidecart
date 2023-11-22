// create a form that takes Business object from userimport 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countrysidecart/database/bussiness.dart';
import 'package:countrysidecart/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/bussiness.dart';

class BusinessForm extends StatefulWidget {
  @override
  _BusinessFormState createState() => _BusinessFormState();
}

class _BusinessFormState extends State<BusinessForm> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _locationController = TextEditingController();
  TextEditingController _bussinessNameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  String businessId = '';
  String businessType = ''; //
  List<ProductService> productServices = [];
  List<Orders> orderManagement = [];
  List<RatingReview> ratingsAndReviews = [];
  List<String> promotionalContent = [];

  @override
  void initState() {
    super.initState();
    getBussiness();
  }

  getBussiness() async {
    await getuserdata().then((value) {
      print(value);
    });
  }

  Future<String> getuserdata() async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(uid).get();
    // final String public = userSnapshot['public_key'];
    businessId = userSnapshot['bussinessId'];
    return businessId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _bussinessNameController,
                decoration: InputDecoration(
                  labelText: 'Business Name',
                ),
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(
                  labelText: 'Contact',
                ),
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
              ),
              // Add more form fields for other properties

              ElevatedButton(
                onPressed: () async {
                  // Validate and save the form
                  // if (Form.of(context).validate()) {
                  // Create a Business object with the form data
                  print('onpressed');
                  if (businessId.isNotEmpty) {
                    ContactInformation contact = ContactInformation(
                        email: FirebaseAuth.instance.currentUser!.email!,
                        phoneNumber: _contactController.text);
                    Business business = Business(
                      businessId: businessId,
                      businessName: _bussinessNameController.text,
                      businessType: businessType,
                      location: _locationController.text,
                      contactInformation: contact,
                      productServices: productServices,
                      orderManagement: orderManagement,
                      ratingsAndReviews: ratingsAndReviews,
                      promotionalContent: promotionalContent,
                    );
                    print(business.toMap());

                    await storeBusiness(business).then((value) {
                      Navigator.of(context).pop();
                    });
                    // }

                    // Do something with the business object
                    // For example, you can pass it to another screen or save it to a database
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => BusinessDetailsScreen(business: business),
                    //   ),
                    // );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
