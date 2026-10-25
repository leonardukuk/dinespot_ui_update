import 'package:flutter/material.dart';

import 'auth.dart';
import 'database/order_database.dart';
import 'widgets/animated_entry.dart';
import 'widgets/soft_background.dart';
import 'widgets/user_avatar.dart';

const _accent = Color(0xFFC66B3D);
const _ink = Color(0xFF34221B);
const _muted = Color(0xFF81766F);
const _pageBackground = Color(0xFFFAF7F2);
const _orderStatuses = [
  'Pending',
  'Preparing',
  'On the way',
  'Delivered',
  'Cancelled',
];

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppSession.instance.role != AppRole.admin) {
      return Scaffold(
        backgroundColor: _pageBackground,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: _accent),
              const SizedBox(height: 12),
              const Text(
                'Admin access required',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: AppSession.instance.signOut,
                style: FilledButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Return to sign in'),
              ),
            ],
          ),
        ),
      );
    }

    return _AdminDashboard(
      username: AppSession.instance.username ?? AppSession.adminUsername,
      onSignOut: AppSession.instance.signOut,
    );
  }
}

class _AdminDashboard extends StatefulWidget {
  const _AdminDashboard({required this.username, required this.onSignOut});

  final String username;
  final VoidCallback onSignOut;

  @override
  State<_AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<_AdminDashboard> {
  static const _filters = ['All', 'Active', 'Delivered', 'Cancelled'];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(Icons.local_cafe_rounded, color: _accent),
            SizedBox(width: 10),
            Text(
              'Cafepizza',
              style: TextStyle(
                color: _ink,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: widget.onSignOut,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _ink,
            ),
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SoftBackground(child: ValueListenableBuilder<List<CustomerOrder>>(
        valueListenable: OrderDatabase.instance.orders,
        builder: (context, orders, _) {
          final activeCount = orders
              .where((order) => _isActive(order.status))
              .length;
          final filteredOrders = orders.where((order) {
            return switch (_selectedFilter) {
              'Active' => _isActive(order.status),
              'Delivered' => order.status == 'Delivered',
              'Cancelled' => order.status == 'Cancelled',
              _ => true,
            };
          }).toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final padding = constraints.maxWidth < 500 ? 16.0 : 28.0;

                  return ListView(
                    padding: EdgeInsets.fromLTRB(padding, 12, padding, 28),
                    children: [
                      FadeSlideIn(child: _WelcomePanel(username: widget.username)),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order history',
                                  style: TextStyle(
                                    color: _ink,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'See what customers ordered and track each order.',
                                  style: TextStyle(color: _muted, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _OrderSummaryCard(
                              label: 'Total orders',
                              count: orders.length,
                              icon: Icons.receipt_long_rounded,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: _OrderSummaryCard(
                              label: 'Active',
                              count: activeCount,
                              icon: Icons.pending_actions_rounded,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: _OrderSummaryCard(
                              label: 'Delivered',
                              count: orders
                                  .where((order) => order.status == 'Delivered')
                                  .length,
                              icon: Icons.check_circle_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: _filters.map((filter) {
                          return ChoiceChip(
                            label: Text(filter),
                            selected: _selectedFilter == filter,
                            selectedColor: const Color(0xFFF1E5D9),
                            labelStyle: TextStyle(
                              color: _selectedFilter == filter ? _accent : _ink,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            side: BorderSide(
                              color: _selectedFilter == filter
                                  ? _accent.withValues(alpha: 0.35)
                                  : const Color(0xFFF0EAE4),
                            ),
                            onSelected: (_) {
                              setState(() => _selectedFilter = filter);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      if (orders.isEmpty)
                        const _EmptyOrders()
                      else if (filteredOrders.isEmpty)
                        const _NoMatchingOrders()
                      else
                        ...filteredOrders.map(
                          (order) => FadeSlideIn(child: _AdminOrderCard(order: order)),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      )),
    );
  }

  bool _isActive(String status) =>
      status == 'Pending' || status == 'Preparing' || status == 'On the way';
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({
    required this.label,
    required this.count,
    required this.icon,
  });

  final String label;
  final int count;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: _accent),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: const TextStyle(
              color: _ink,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF533324), Color(0xFF9B5735)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $username',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Here’s what’s happening at your cafe today.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Administrator  ·  Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          UserAvatar(username: username, size: 60, editable: true),
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: const Column(
        children: [
          Icon(Icons.receipt_long_outlined, color: _muted, size: 34),
          SizedBox(height: 10),
          Text(
            'No customer orders yet.',
            style: TextStyle(color: _ink, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'New orders will appear here.',
            style: TextStyle(color: _muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _NoMatchingOrders extends StatelessWidget {
  const _NoMatchingOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: const Text(
        'No orders match this filter.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 13),
      ),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  const _AdminOrderCard({required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context) {
    final itemSummary = order.items
        .map((item) {
          final options = item.customizations.isEmpty
              ? ''
              : ' (${item.customizations.join(' · ')})';
          return '${item.quantity} × ${item.name}$options';
        })
        .join(', ');
    final statusColor = _statusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0EAE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1E5D9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    order.customerName.isEmpty
                        ? '?'
                        : order.customerName[0].toUpperCase(),
                    style: const TextStyle(
                      color: _accent,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          order.id,
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text('·', style: TextStyle(color: _muted)),
                        ),
                        Text(
                          _dateTimeLabel(order.createdAt),
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (order.deliveryProofBytes != null) ...[
            const SizedBox(height: 14),
            const Text(
              'Delivery proof',
              style: TextStyle(
                color: _ink,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                order.deliveryProofBytes!,
                width: 180,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              itemSummary,
              style: const TextStyle(
                color: _ink,
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, color: _muted, size: 17),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  order.deliveryAddress,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 9),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    DropdownButton<String>(
                      value: order.status,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(12),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      items: _orderStatuses
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (status) {
                        if (status != null) {
                          OrderDatabase.instance.updateStatus(order.id, status);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'STATUS',
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) => switch (status) {
    'Pending' => const Color(0xFFC27822),
    'Preparing' => const Color(0xFF6652A3),
    'On the way' => const Color(0xFF3676A8),
    'Delivered' => const Color(0xFF40845A),
    'Cancelled' => const Color(0xFFB44E48),
    _ => _muted,
  };

  String _dateTimeLabel(DateTime createdAt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = createdAt.hour % 12 == 0 ? 12 : createdAt.hour % 12;
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final period = createdAt.hour < 12 ? 'AM' : 'PM';
    return '${months[createdAt.month - 1]} ${createdAt.day}, ${createdAt.year} · $hour:$minute $period';
  }
}
