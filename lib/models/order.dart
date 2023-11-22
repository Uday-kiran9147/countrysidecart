// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Orders {
  String orderId;
  String userId;
  String businessId;
  List<OrderItem> orderItems;
  String orderStatus;
  double totalAmount;
  DateTime timestamp;

  Orders({
    required this.orderId,
    required this.userId,
    required this.businessId,
    required this.orderItems,
    required this.orderStatus,
    required this.totalAmount,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'userId': userId,
      'businessId': businessId,
      'orderItems': orderItems.map((x) {return x.toMap();}).toList(growable: false),
      'orderStatus': orderStatus,
      'totalAmount': totalAmount,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
      orderId: (map["orderId"] ?? '') as String,
      userId: (map["userId"] ?? '') as String,
      businessId: (map["businessId"] ?? '') as String,
      orderItems: List<OrderItem>.from(((map['orderItems'] ?? const <OrderItem>[]) as List).map<OrderItem>((x) {return OrderItem.fromMap((x?? Map<String,dynamic>.from({})) as Map<String,dynamic>);}),),
      orderStatus: (map["orderStatus"] ?? '') as String,
      totalAmount: (map["totalAmount"] ?? 0.0) as double,
      timestamp: DateTime.fromMillisecondsSinceEpoch((map["timestamp"]??0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Orders.fromJson(String source) => Orders.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OrderItem {
  String productId;
  int quantity;

  OrderItem({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: (map["productId"] ?? '') as String,
      quantity: (map["quantity"] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) => OrderItem.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OrderFeedback {
  String orderId;
  String userId;
  String feedback;
  int rating;

  OrderFeedback({
    required this.orderId,
    required this.userId,
    required this.feedback,
    required this.rating,
  });
}
// Example method for placing a new order
void placeOrder(Orders order) {
  // Add logic to process the order and store it in the database
}

// Example method for tracking order status
String trackOrderStatus(String orderId) {
  // Add logic to retrieve and return the current status of the specified order
  return "";
}

// Example method for viewing order history
List<Orders> getOrderHistory(String userId) {
  // Add logic to retrieve and return the order history for the specified user
  return <Orders> [];
}

// Example method for canceling an order
void cancelOrder(String orderId) {
  // Add logic to cancel the specified order if it is cancellable
}

// Example method for providing order feedback
void provideOrderFeedback(OrderFeedback feedback) {
  // Add logic to store and process the order feedback in the system
}
