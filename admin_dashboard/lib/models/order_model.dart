class Order {
  String id;
  String restaurantId;
  String driverId;  // <-- final-г устгав
  String customerName;
  String status;
  double totalPrice;

  Order({
    required this.id,
    required this.restaurantId,
    required this.driverId,
    required this.customerName,
    required this.status,
    required this.totalPrice,
  });
}
