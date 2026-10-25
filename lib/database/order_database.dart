import 'package:flutter/foundation.dart';

class OrderLine {
  const OrderLine({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.customizations = const [],
  });

  final String name;
  final int quantity;
  final double unitPrice;
  final List<String> customizations;

  double get total => quantity * unitPrice;
}

class CustomerOrder {
  const CustomerOrder({
    required this.id,
    required this.customerName,
    required this.deliveryAddress,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    this.acceptedByRider,
    this.deliveryProofBytes,
  });

  final String id;
  final String customerName;
  final String deliveryAddress;
  final List<OrderLine> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final String? acceptedByRider;
  final Uint8List? deliveryProofBytes;

  CustomerOrder copyWith({
    String? status,
    String? acceptedByRider,
    Uint8List? deliveryProofBytes,
  }) {
    return CustomerOrder(
      id: id,
      customerName: customerName,
      deliveryAddress: deliveryAddress,
      items: items,
      total: total,
      status: status ?? this.status,
      createdAt: createdAt,
      acceptedByRider: acceptedByRider ?? this.acceptedByRider,
      deliveryProofBytes: deliveryProofBytes ?? this.deliveryProofBytes,
    );
  }
}

class OrderDatabase {
  OrderDatabase._();

  static final instance = OrderDatabase._();

  final ValueNotifier<List<CustomerOrder>> orders =
      ValueNotifier<List<CustomerOrder>>([]);

  int _nextOrderNumber = 1001;

  CustomerOrder addOrder({
    required String customerName,
    required String deliveryAddress,
    required List<OrderLine> items,
    required double total,
  }) {
    if (items.isEmpty) {
      throw ArgumentError.value(items, 'items', 'An order must contain items');
    }

    final order = CustomerOrder(
      id: '#${_nextOrderNumber++}',
      customerName: customerName,
      deliveryAddress: deliveryAddress,
      items: List.unmodifiable(items),
      total: total,
      status: 'Pending',
      createdAt: DateTime.now(),
    );
    orders.value = List.unmodifiable([order, ...orders.value]);
    return order;
  }

  void updateStatus(String orderId, String status) {
    var found = false;
    orders.value = List.unmodifiable(
      orders.value.map((order) {
        if (order.id != orderId) return order;
        found = true;
        return order.copyWith(status: status);
      }),
    );
    if (!found) {
      throw StateError('Order $orderId was not found');
    }
  }

  bool acceptOrder(String orderId, String riderUsername) {
    final rider = riderUsername.trim().toLowerCase();
    if (rider.isEmpty) return false;

    var accepted = false;
    orders.value = List.unmodifiable(
      orders.value.map((order) {
        if (order.id != orderId ||
            order.acceptedByRider != null ||
            !_isReadyForRider(order.status)) {
          return order;
        }
        accepted = true;
        return order.copyWith(acceptedByRider: rider);
      }),
    );
    return accepted;
  }

  bool startDelivery(String orderId, String riderUsername) {
    return _updateRiderDeliveryStatus(
      orderId,
      riderUsername,
      nextStatus: 'On the way',
      allowedStatuses: const {'Pending', 'Preparing'},
    );
  }

  bool completeDelivery(
    String orderId,
    String riderUsername, {
    required Uint8List proofBytes,
  }) {
    if (proofBytes.isEmpty) return false;

    final rider = riderUsername.trim().toLowerCase();
    if (rider.isEmpty) return false;

    var updated = false;
    orders.value = List.unmodifiable(
      orders.value.map((order) {
        if (order.id != orderId ||
            order.acceptedByRider != rider ||
            order.status != 'On the way') {
          return order;
        }
        updated = true;
        return order.copyWith(
          status: 'Delivered',
          deliveryProofBytes: Uint8List.fromList(proofBytes),
        );
      }),
    );
    return updated;
  }

  bool _updateRiderDeliveryStatus(
    String orderId,
    String riderUsername, {
    required String nextStatus,
    required Set<String> allowedStatuses,
  }) {
    final rider = riderUsername.trim().toLowerCase();
    if (rider.isEmpty) return false;

    var updated = false;
    orders.value = List.unmodifiable(
      orders.value.map((order) {
        if (order.id != orderId ||
            order.acceptedByRider != rider ||
            !allowedStatuses.contains(order.status)) {
          return order;
        }
        updated = true;
        return order.copyWith(status: nextStatus);
      }),
    );
    return updated;
  }

  bool _isReadyForRider(String status) =>
      status == 'Pending' || status == 'Preparing';
}
