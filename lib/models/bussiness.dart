import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countrysidecart/models/order.dart';

class Business {
  String businessId;
  String businessName;
  String businessType;
  String location;
  ContactInformation contactInformation;
  List<ProductService> productServices;
  List<Orders> orderManagement;
  List<RatingReview> ratingsAndReviews;
  List<String> promotionalContent;

  Business({
    required this.businessId,
    required this.businessName,
    required this.businessType,
    required this.location,
    required this.contactInformation,
    required this.productServices,
    required this.orderManagement,
    required this.ratingsAndReviews,
    required this.promotionalContent,
  });

  //generate json serialization
  Map<String, dynamic> toMap() {
    return {
      'businessId': businessId,
      'businessName': businessName,
      'businessType': businessType,
      'location': location,
      'contactInformation': contactInformation.toMap(),
      'productServices':
          productServices.map((product) => product.toMap()).toList(),
      'orderManagement': orderManagement.map((order) => order.toMap()).toList(),
      'ratingsAndReviews':
          ratingsAndReviews.map((rating) => rating.toMap()).toList(),
      'promotionalContent': promotionalContent,
    };
  }

  // factory constructor to create a Business instance from a map
  factory Business.fromMap(QueryDocumentSnapshot map) {
    return Business(
      businessId: map['businessId'],
      businessName: map['businessName'],
      businessType: map['businessType'],
      location: map['location'],
      contactInformation: ContactInformation.fromMap(map['contactInformation']),
      productServices: List<ProductService>.from(
          map['productServices']?.map((x) => ProductService.fromMap(x))),
      orderManagement: List<Orders>.from(
          map['orderManagement']?.map((x) => Orders.fromMap(x))),
      ratingsAndReviews: List<RatingReview>.from(
          map['ratingsAndReviews']?.map((x) => RatingReview.fromMap(x))),
      promotionalContent: List<String>.from(map['promotionalContent']),
    );
  }
}

class ContactInformation {
  String email;
  String phoneNumber;

  ContactInformation({
    required this.email,
    required this.phoneNumber,
  });
  // generate json serialization
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  // factory constructor to create a ContactInformation instance from a map
  factory ContactInformation.fromMap(Map<String, dynamic> map) {
    return ContactInformation(
      email: map['email'],
      phoneNumber: map['phoneNumber'],
    );
  }
}

class ProductService {
  String productId;
  String productName;
  double price;
  // Add more attributes as needed

  ProductService({
    required this.productId,
    required this.productName,
    required this.price,
    // Add more parameters as needed
  });
  // generate json serialization
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
    };
  }

  // factory constructor to create a ProductService instance from a map
  factory ProductService.fromMap(Map<String, dynamic> map) {
    return ProductService(
      productId: map['productId'],
      productName: map['productName'],
      price: map['price'],
    );
  }
}

class Order {
  String orderId;
  String productId;
  int quantity;
  DateTime orderDate;

  Order({
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.orderDate,
  });
  // generate json serialization
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'orderDate': orderDate, // Convert DateTime to ISO 8601 string
    };
  }

  // factory constructor to create a Order instance from a map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      productId: map['productId'],
      quantity: map['quantity'],
      orderDate:
          map['orderDate'].toDate(), // Convert ISO 8601 string to DateTime
    );
  }
}

class RatingReview {
  String userId;
  double rating;
  String review;

  RatingReview({
    required this.userId,
    required this.rating,
    required this.review,
  });
  // generate json serialization
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
      'review': review,
    };
  }

  // factory constructor to create a RatingReview instance from a map
  factory RatingReview.fromMap(Map<String, dynamic> map) {
    return RatingReview(
      userId: map['userId'],
      rating: map['rating'],
      review: map['review'],
    );
  }
}
