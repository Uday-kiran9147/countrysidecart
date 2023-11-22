import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countrysidecart/database/auth.dart';
import 'package:countrysidecart/database/bussiness.dart';
import 'package:countrysidecart/models/bussiness.dart';
import 'package:countrysidecart/screens/bussiness/bussiness_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String user_bid = '';
  String bussi_bid = '';
  bool hasbusiness = false;
  @override
  void initState() {
    getdata();
    super.initState();
  }

  getdata() async {
    await getuserdata();
  }

  DocumentSnapshot? businessAccount;
  List<ProductService> productService = [];
  Future<bool> getuserdata() async {
    DocumentSnapshot userSnapshot = await usersCollection.doc(uid).get();
    final user_businessId = userSnapshot['bussinessId'];
    DocumentSnapshot bussinessSnapshot =
        await bussinessCollection.doc(user_businessId).get();
    var bussiness_Id = '';
    setState(() {
      businessAccount = bussinessSnapshot;
      user_bid = user_businessId;
      if (bussinessSnapshot.exists) {
        for (var i = 0; i < bussinessSnapshot['productServices'].length; i++) {
          // var t = bussinessSnapshot['productServices'][i];
          productService.add(ProductService.fromMap(
              bussinessSnapshot['productServices'][i] as Map<String, dynamic>));
        }
        bussiness_Id = bussinessSnapshot['businessId'];
      }
    });
    // print(bussinessSnapshot['businessName']);
    // print(bussinessSnapshot['productServices']);
    hasbusiness = user_businessId == bussiness_Id;
    return hasbusiness;
  }

  @override
  Widget build(BuildContext context) {
    return hasbusiness
        ? Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text('at ${businessAccount!['location']}'),
                  Icon(
                    Icons.location_on,
                    color: Colors.green.shade200,
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () async {
                    await storeProduct(
                            ProductService(
                                productId: uuid.v1(),
                                productName: 'Red-velvet',
                                price: 19),
                            user_bid)
                        .then((value) {
                      Fluttertoast.showToast(
                          msg: 'Product added successfully',
                          toastLength: Toast.LENGTH_LONG);
                      setState(() {});
                    }).catchError((err) => {
                              Fluttertoast.showToast(
                                  msg: err.toString(),
                                  backgroundColor: Colors.redAccent,
                                  toastLength: Toast.LENGTH_LONG)
                            });
                  },
                  icon: Icon(Icons.add),
                )
              ],
            ),
            body: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Text(
                        businessAccount![
                            'businessName'], //style: TextStyle(fontSize: 28,),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Color.fromARGB(255, 206, 160, 69)),
                        textAlign: TextAlign.end,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            businessAccount!['location'],
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.grey),
                          ),
                          Icon(
                            Icons.location_on,
                            color: Colors.green.shade200,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                businessAccount!['productServices'].length <= 0
                    ? Center(
                        child: Text('No products'),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: productService.map((ProductService product) {
                          return ListTile(
                            subtitleTextStyle: TextStyle(color: Colors.green),
                            title: Text(product.productName),
                            subtitle: Text(
                              '\$ ' + product.price.toString(),
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Profile'),
            ),
            body: Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessForm(),
                          ));
                    },
                    child: Text("Bussiness profile"))));
  }
}
