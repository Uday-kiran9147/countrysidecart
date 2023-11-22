//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countrysidecart/database/auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/bussiness.dart';

Future<void> storeBusiness(Business business) async {
  try {
    await bussinessCollection.doc(business.businessId).set(business.toMap());
  } catch (e) {
    Fluttertoast.showToast(
        msg: e.toString(), backgroundColor: Colors.redAccent);
  }
}
Future<void> storeProduct(ProductService product, String bid) async {
  print("bid "+bid);
  try {
    await bussinessCollection.doc(bid).update({
      'productServices': FieldValue.arrayUnion([product.toMap()])
    });
  } catch (e) {
    Fluttertoast.showToast(
        msg: e.toString(), backgroundColor: Colors.redAccent,toastLength: Toast.LENGTH_LONG);
  }
}

