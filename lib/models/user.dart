import 'package:cloud_firestore/cloud_firestore.dart';

class UserApp {
  String userId;
  String username;
  String email;
  String password;
  String bussinessId;
  String location;
  List<String> preferences;
  List<Transaction> transactionHistory;

  UserApp({
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.bussinessId,
    required this.location,
    required this.preferences,
    required this.transactionHistory,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'password': password,
      'bussinessId': bussinessId,
      'location': location,
      'preferences': preferences,
      'transactionHistory':
          transactionHistory.map((transaction) => transaction.toMap()).toList(),
    };
  }
}

class Transaction {
  String transactionId;
  String productId;
  double amount;
  Timestamp timestamp;

  Transaction({
    required this.transactionId,
    required this.productId,
    required this.amount,
    required this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'productId': productId,
      'amount': amount,
      'timestamp': timestamp, // Convert DateTime to ISO 8601 string
    };
  }
}
