import 'package:flutter/material.dart';

import 'admin.dart';
import 'auth.dart';
import 'database/order_database.dart';
import 'login.dart';
import 'riderdashboard.dart';
import 'viewfullmenu.dart';

void main() {
  runApp(const MyApp());
}

class FoodItem {
  const FoodItem({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.image,
  });

  final String name;
  final String category;
  final String description;
  final double price;
  final String image;
}

class Restaurant {
  const Restaurant({
    required this.name,
    required this.cuisine,
    required this.deliveryTime,
    required this.rating,
    required this.image,
    required this.items,
  });

  final String name;
  final String cuisine;
  final String deliveryTime;
  final String rating;
  final String image;
  final List<FoodItem> items;
}

final List<Restaurant> restaurants = [
  Restaurant(
    name: 'Saffron Bites',
    cuisine: 'Indian • 4.8',
    deliveryTime: '18-25 min',
    rating: '4.8',
    image: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=900&q=80',
    items: [
      FoodItem(
        name: 'Paneer Tikka Bowl',
        category: 'Popular',
        description: 'Chargrilled cottage cheese with saffron rice.',
        price: 14.99,
        image: 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=900&q=80',
      ),
      FoodItem(
        name: 'Butter Chicken',
        category: 'Chef Special',
        description: 'Classic creamy curry served with garlic naan.',
        price: 18.5,
        image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=900&q=80',
      ),
      FoodItem(
        name: 'Veg Biryani',
        category: 'Rice',
        description: 'Aromatic basmati rice with vegetables and herbs.',
        price: 16.0,
        image: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=900&q=80',
      ),
    ],
  ),
  Restaurant(
    name: 'Green Bowl',
    cuisine: 'Healthy • 4.7',
    deliveryTime: '15-20 min',
    rating: '4.7',
    image: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&w=900&q=80',
    items: [
      FoodItem(
        name: 'Avocado Salad',
        category: 'Salad',
        description: 'Fresh greens, quinoa, avocado and citrus dressing.',
        price: 12.5,
        image: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?auto=format&fit=crop&w=900&q=80',
      ),
      FoodItem(
        name: 'Protein Wrap',
        category: 'Wrap',
        description: 'Chicken, spinach, hummus and crunchy vegetables.',
        price: 13.75,
        image: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=900&q=80',
      ),
    ],
  ),
  Restaurant(
    name: 'Luna Pizza',
    cuisine: 'Italian • 4.9',
    deliveryTime: '20-30 min',
    rating: '4.9',
    image: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=900&q=80',
    items: [
      FoodItem(
        name: 'Margherita Pizza',
        category: 'Pizza',
        description: 'Fresh basil, mozzarella and tomato sauce.',
        price: 17.0,
        image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=900&q=80',
      ),
      FoodItem(
        name: 'Truffle Pasta',
        category: 'Pasta',
        description: 'Creamy truffle sauce with parmesan and herbs.',
        price: 19.25,
        image: 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?auto=format&fit=crop&w=900&q=80',
      ),
    ],
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dinespot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFC66B3D),
        scaffoldBackgroundColor: const Color(0xFFFAF7F2),
        fontFamily: 'Roboto',
        // Smooth, consistent page transitions on every platform.
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          },
        ),
        // Rounded, floating snackbars that match the cafe look.
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF34221B),
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        // Rounded buttons everywhere.
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSession.instance,
      builder: (context, _) {
        return switch (AppSession.instance.role) {
          AppRole.admin => const AdminPage(),
          AppRole.customer => const FullMenuPage(),
          AppRole.rider => const RiderDashboardPage(),
          null => const LoginPage(),
        };
      },
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final Map<String, int> _cart = {};
  String _deliveryAddress = '';

  void _addToCart(FoodItem item) {
    setState(() {
      _cart[item.name] = (_cart[item.name] ?? 0) + 1;
    });
  }

  void _removeFromCart(String itemName) {
    setState(() {
      if ((_cart[itemName] ?? 0) > 1) {
        _cart[itemName] = _cart[itemName]! - 1;
      } else {
        _cart.remove(itemName);
      }
    });
  }

  void _placeOrder(String deliveryAddress) {
    final orderLines = _cartItems
        .map(
          (item) => OrderLine(
            name: item.name,
            quantity: _cart[item.name]!,
            unitPrice: item.price,
          ),
        )
        .toList();

    OrderDatabase.instance.addOrder(
      customerName: AppSession.instance.username ?? 'Customer',
      deliveryAddress: deliveryAddress,
      items: orderLines,
      total: _cartTotal + 4.99,
    );
    setState(() {
      _deliveryAddress = deliveryAddress;
      _cart.clear();
    });
  }

  double get _cartTotal {
    double total = 0;
    for (final restaurant in restaurants) {
      for (final item in restaurant.items) {
        final quantity = _cart[item.name] ?? 0;
        total += item.price * quantity;
      }
    }
    return total;
  }

  List<FoodItem> get _cartItems {
    final items = <FoodItem>[];
    for (final restaurant in restaurants) {
      for (final item in restaurant.items) {
        if (_cart.containsKey(item.name)) {
          items.add(item);
        }
      }
    }
    return items;
  }

  int get _cartItemCount =>
      _cart.values.fold<int>(0, (sum, value) => sum + value);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeTab(onAddToCart: _addToCart, cartCount: _cartItemCount),
      const FavoritesTab(),
      CartTab(
        cartItems: _cartItems,
        cart: _cart,
        total: _cartTotal,
        onRemove: _removeFromCart,
        onPlaceOrder: _placeOrder,
        deliveryAddress: _deliveryAddress,
      ),
      const OrdersTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) =>
            setState(() => _selectedIndex = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class FoodArt extends StatelessWidget {
  const FoodArt({
    super.key,
    required this.label,
    required this.color,
    this.width = 120,
    this.height = 120,
  });

  final String label;
  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.onAddToCart,
    required this.cartCount,
  });

  final void Function(FoodItem) onAddToCart;
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dinespot',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Find your next favorite meal',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Badge(
                    label: Text('$cartCount'),
                    backgroundColor: const Color(0xFFEF5B2A),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search restaurants, dishes or cuisine',
                      style: TextStyle(color: Color(0xFF7E7E7E)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _FilterChip(label: 'All'),
                  _FilterChip(label: 'Indian'),
                  _FilterChip(label: 'Italian'),
                  _FilterChip(label: 'Healthy'),
                  _FilterChip(label: 'Fast Food'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Popular restaurants',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return Container(
                    width: 260,
                    margin: const EdgeInsets.only(right: 14),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              FoodArt(
                                label: restaurant.name
                                    .substring(0, 1)
                                    .toUpperCase(),
                                color: index.isEven
                                    ? const Color(0xFFEF5B2A)
                                    : const Color(0xFF4ECDC4),
                                width: 260,
                                height: 160,
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(restaurant.rating),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${restaurant.cuisine} • ${restaurant.deliveryTime}',
                                  style: const TextStyle(
                                    color: Color(0xFF686868),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Today\'s picks',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...restaurants.expand(
              (restaurant) => restaurant.items.map(
                (item) => _FoodCard(foodItem: item, onAddToCart: onAddToCart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EEE8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF3A3A3A),
        ),
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.foodItem, required this.onAddToCart});

  final FoodItem foodItem;
  final void Function(FoodItem) onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FoodArt(
              label: foodItem.name.substring(0, 1).toUpperCase(),
              color: const Color(0xFFFFC29E),
              width: 110,
              height: 110,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE9DF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    foodItem.category,
                    style: const TextStyle(
                      color: Color(0xFFEF5B2A),
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  foodItem.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  foodItem.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${foodItem.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => onAddToCart(foodItem),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF5B2A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Saved restaurants',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class CartTab extends StatelessWidget {
  const CartTab({
    super.key,
    required this.cartItems,
    required this.cart,
    required this.total,
    required this.onRemove,
    required this.onPlaceOrder,
    required this.deliveryAddress,
  });

  final List<FoodItem> cartItems;
  final Map<String, int> cart;
  final double total;
  final void Function(String) onRemove;
  final ValueChanged<String> onPlaceOrder;
  final String deliveryAddress;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My cart',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(
                      child: Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final quantity = cart[item.name] ?? 1;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FoodArt(
                                  label: item.name
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  color: const Color(0xFFE9C46A),
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '\$${item.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => onRemove(item.name),
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                  ),
                                  Text('$quantity'),
                                  const Icon(
                                    Icons.add_circle_outline,
                                    color: Color(0xFFEF5B2A),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal'),
                      Text('\$${total.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [Text('Delivery'), Text('\$4.99')],
                  ),
                  const Divider(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '\$${(total + 4.99).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cartItems.isEmpty
                          ? null
                          : () async {
                              final address = await showDialog<String>(
                                context: context,
                                builder: (_) => _CheckoutAddressDialog(
                                  initialAddress: deliveryAddress,
                                ),
                              );
                              if (address == null || !context.mounted) return;

                              onPlaceOrder(address);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Order placed and added to order history.',
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF5B2A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Place Order'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutAddressDialog extends StatefulWidget {
  const _CheckoutAddressDialog({required this.initialAddress});

  final String initialAddress;

  @override
  State<_CheckoutAddressDialog> createState() => _CheckoutAddressDialogState();
}

class _CheckoutAddressDialogState extends State<_CheckoutAddressDialog> {
  late final TextEditingController _addressController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _continueToPlaceOrder() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(_addressController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delivery address'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Where should we deliver your order?',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              autofocus: true,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Street address',
                hintText: 'House/building, street, city',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a delivery address';
                }
                if (value.trim().length < 5) {
                  return 'Enter a more complete address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _continueToPlaceOrder,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFEF5B2A),
            foregroundColor: Colors.white,
          ),
          child: const Text('Place order'),
        ),
      ],
    );
  }
}

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Orders',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<List<CustomerOrder>>(
                valueListenable: OrderDatabase.instance.orders,
                builder: (context, orders, _) {
                  if (orders.isEmpty) {
                    return const Center(child: Text('No orders yet.'));
                  }
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final status = order.status;
                      final color = status == 'Delivered'
                          ? Colors.green
                          : status == 'On the way'
                          ? Colors.orange
                          : const Color(0xFFEF5B2A);
                      final itemSummary = order.items
                          .map((item) {
                            final options = item.customizations.isEmpty
                                ? ''
                                : ' (${item.customizations.join(' · ')})';
                            return '${item.quantity} × ${item.name}$options';
                          })
                          .join(', ');

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemSummary,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${order.id} · ${order.customerName}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${order.total.toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Color(0xFF81766F),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          order.deliveryAddress,
                                          style: const TextStyle(
                                            color: Color(0xFF81766F),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: const Color(0xFFEF5B2A),
                    child: const Icon(
                      Icons.person,
                      size: 42,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppSession.instance.username ?? 'Customer',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Restaurant Customer',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _ProfileOption(
              title: 'Personal Details',
              icon: Icons.account_circle_outlined,
            ),
            _ProfileOption(
              title: 'Saved Addresses',
              icon: Icons.location_on_outlined,
            ),
            _ProfileOption(
              title: 'Payment Methods',
              icon: Icons.credit_card_outlined,
            ),
            _ProfileOption(title: 'Help Center', icon: Icons.help_outline),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: AppSession.instance.signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Log out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFEF5B2A)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
