import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_restaurant_services/admin.dart';
import 'package:food_restaurant_services/auth.dart';
import 'package:food_restaurant_services/database/order_database.dart';
import 'package:food_restaurant_services/find_us.dart';
import 'package:food_restaurant_services/main.dart';
import 'package:food_restaurant_services/riderdashboard.dart';
import 'package:food_restaurant_services/viewfullmenu.dart';

const _testProofPng = <int>[
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  8,
  6,
  0,
  0,
  0,
  31,
  21,
  196,
  137,
  0,
  0,
  0,
  11,
  73,
  68,
  65,
  84,
  120,
  156,
  99,
  96,
  0,
  2,
  0,
  0,
  5,
  0,
  1,
  167,
  112,
  129,
  148,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130,
];

void main() {
  setUp(() {
    AppSession.instance.signOut();
    OrderDatabase.instance.orders.value = [];
  });

  testWidgets('customer sign in opens the full menu without admin access', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await signInAsUser(tester);

    expect(find.text('CLICK THE MENU'), findsOneWidget);
    expect(find.text('Search coffee or pizza'), findsOneWidget);
    expect(find.text('Matcha'), findsOneWidget);
    expect(find.text('View full menu'), findsNothing);
    expect(find.text('Admin dashboard'), findsNothing);
  });

  testWidgets('rider can sign in and advance a delivery to delivered', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    OrderDatabase.instance.addOrder(
      customerName: 'Jamie',
      deliveryAddress: '42 Cafe Street, Manila',
      items: const [OrderLine(name: 'Latte', quantity: 1, unitPrice: 120)],
      total: 124.99,
    );

    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Rider sign in'));
    await tester.tap(find.text('Rider sign in'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'rider1');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Continue to dashboard'));
    await tester.pumpAndSettle();

    expect(find.byType(RiderDashboardPage), findsOneWidget);
    expect(find.text('42 Cafe Street, Manila'), findsOneWidget);
    expect(find.text('Available orders'), findsOneWidget);
    expect(find.text('Accept order'), findsOneWidget);

    final order = OrderDatabase.instance.orders.value.single;
    final acceptButton = find.ancestor(
      of: find.text('Accept order'),
      matching: find.byType(FilledButton),
    );
    await tester.ensureVisible(acceptButton);
    await tester.tap(acceptButton);
    await tester.pumpAndSettle();

    final acceptedOrder = OrderDatabase.instance.orders.value.single;
    expect(acceptedOrder.status, 'Pending');
    expect(acceptedOrder.acceptedByRider, 'rider1');
    expect(find.text('Pick up order'), findsOneWidget);
    expect(
      OrderDatabase.instance.startDelivery(order.id, 'another-rider'),
      isFalse,
    );

    final pickupButton = find.ancestor(
      of: find.text('Pick up order'),
      matching: find.byType(FilledButton),
    );
    await tester.ensureVisible(pickupButton);
    await tester.tap(pickupButton);
    await tester.pumpAndSettle();
    expect(OrderDatabase.instance.orders.value.single.status, 'On the way');
    expect(
      OrderDatabase.instance.completeDelivery(
        order.id,
        'another-rider',
        proofBytes: Uint8List.fromList([1]),
      ),
      isFalse,
    );
    expect(
      OrderDatabase.instance.completeDelivery(
        order.id,
        'rider1',
        proofBytes: Uint8List(0),
      ),
      isFalse,
    );
    expect(find.text('Add proof & deliver'), findsOneWidget);

    final deliveredButton = find.ancestor(
      of: find.text('Add proof & deliver'),
      matching: find.byType(FilledButton),
    );
    await tester.ensureVisible(deliveredButton);
    await tester.tap(deliveredButton);
    await tester.pumpAndSettle();
    expect(find.text('Add delivery proof'), findsOneWidget);
    expect(find.text('Choose from gallery'), findsOneWidget);
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(OrderDatabase.instance.orders.value.single.status, 'On the way');
    expect(
      OrderDatabase.instance.completeDelivery(
        order.id,
        'rider1',
        proofBytes: Uint8List.fromList(_testProofPng),
      ),
      isTrue,
    );
    expect(OrderDatabase.instance.orders.value.single.status, 'Delivered');
    expect(
      OrderDatabase.instance.orders.value.single.deliveryProofBytes,
      isNotNull,
    );
    await tester.pumpAndSettle();
    expect(find.text('No deliveries right now'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rider can create an account and sign in', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Rider sign in'));
    await tester.tap(find.text('Rider sign in'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('New rider? Create an account'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'Taylor Rider',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email address'),
      'taylor@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Contact number'),
      '09171234567',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Rider username'),
      'newrider',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'securepass123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm password'),
      'securepass123',
    );
    expect(find.text('Requirements to prepare'), findsOneWidget);
    expect(find.text('Motorcycle registration documents'), findsOneWidget);
    await tester.ensureVisible(find.text('Create rider account'));
    await tester.tap(find.text('Create rider account'));
    await tester.pumpAndSettle();

    expect(find.byType(RiderDashboardPage), findsOneWidget);
    expect(AppSession.instance.username, 'newrider');
    expect(AppSession.instance.riderProfile?.fullName, 'Taylor Rider');
    expect(AppSession.instance.riderProfile?.vehicleType, 'Motorcycle');

    AppSession.instance.signOut();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Rider sign in'));
    await tester.tap(find.text('Rider sign in'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'newrider');
    await tester.enterText(find.byType(TextFormField).at(1), 'securepass123');
    await tester.tap(find.text('Continue to dashboard'));
    await tester.pumpAndSettle();

    expect(find.byType(RiderDashboardPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('login layout adapts to a small screen', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());

    expect(find.byType(Image), findsOneWidget);
    final artwork = tester.widget<Image>(find.byType(Image));
    expect(artwork.image, isA<AssetImage>());
    expect((artwork.image as AssetImage).assetName, 'lib/images/newbg.jpg');
    expect(tester.takeException(), isNull);
  });

  testWidgets('full menu supports category selection and search', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await signInAsUser(tester);

    expect(find.text('Matcha'), findsOneWidget);
    expect(find.text('Mocha'), findsOneWidget);
    expect(find.text('Spanish Latte'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'americano');
    await tester.pumpAndSettle();
    expect(find.text('Americano'), findsOneWidget);
    expect(find.text('Matcha'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('PIZZA').first);
    await tester.tap(find.text('PIZZA').first);
    await tester.pumpAndSettle();
    expect(find.text('Margherita'), findsOneWidget);
    expect(find.text('Meat Lovers'), findsOneWidget);
    expect(find.text('Four Cheese'), findsOneWidget);
  });

  testWidgets('customer can view café location and contact details', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: FullMenuPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Find us'));
    await tester.pumpAndSettle();

    expect(find.byType(FindUsPage), findsOneWidget);
    expect(find.text('123 Tomas Morato, Quezon City'), findsOneWidget);
    expect(find.text('cafepizza@email.com'), findsOneWidget);
    expect(find.text('Get directions'), findsOneWidget);
    expect(find.text('About us'), findsOneWidget);
    expect(
      find.textContaining('CafePizza brings together freshly brewed'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('menu filters best sellers and favorites and sorts by price', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: FullMenuPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Best sellers'));
    await tester.pumpAndSettle();
    expect(find.text('Matcha'), findsOneWidget);
    expect(find.text('Americano'), findsOneWidget);
    expect(find.text('Latte'), findsOneWidget);
    expect(find.text('Mocha'), findsNothing);

    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();
    expect(find.text('Margherita'), findsOneWidget);
    expect(find.text('Pepperoni'), findsOneWidget);
    expect(find.text('Hawaiian'), findsOneWidget);
    expect(find.text('Four Cheese'), findsNothing);

    await tester.tap(find.text('Coffee'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Best sellers'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Add Matcha to favorites'));
    await tester.tap(find.byTooltip('Add Matcha to favorites'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(FilterChip, 'Favorites'));
    await tester.tap(find.widgetWithText(FilterChip, 'Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Matcha'), findsOneWidget);
    expect(find.text('Americano'), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, 'Favorites'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Featured order'));
    await tester.tap(find.text('Featured order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: low to high').last);
    await tester.pumpAndSettle();
    expect(find.text('Americano'), findsOneWidget);
    expect(find.text('Matcha'), findsOneWidget);
  });

  testWidgets('full menu fits a narrow screen and switches categories', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: FullMenuPage()));
    await tester.pumpAndSettle();

    expect(find.text('Coffee & more'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();

    expect(find.text('Straight from the oven'), findsOneWidget);
    expect(find.text('Margherita'), findsOneWidget);
    expect(find.text('Order').first, findsOneWidget);
    expect(tester.takeException(), isNull);

    final orderButton = find.widgetWithText(FilledButton, 'Order').first;
    await tester.ensureVisible(orderButton);
    await tester.tap(orderButton);
    await tester.pumpAndSettle();
    final dialogLayoutError = tester.takeException();
    if (dialogLayoutError is FlutterError) {
      debugPrint(dialogLayoutError.toStringDeep());
      debugDumpRenderTree();
    }
    expect(dialogLayoutError, isNull);
    await tester.ensureVisible(find.text('Add to cart'));
    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();
    expect(find.text('Checkout'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('customer can view only their own order history', (tester) async {
    AppSession.instance.signIn('user1', 'password123');
    final customerOrder = OrderDatabase.instance.addOrder(
      customerName: 'user1',
      deliveryAddress: '42 Cafe Street',
      items: const [
        OrderLine(
          name: 'Matcha',
          quantity: 2,
          unitPrice: 69,
          customizations: ['Large', 'Iced', 'Sugar 50%'],
        ),
      ],
      total: 142,
    );
    OrderDatabase.instance.addOrder(
      customerName: 'anothercustomer',
      deliveryAddress: 'Other Street',
      items: const [OrderLine(name: 'Pepperoni', quantity: 1, unitPrice: 219)],
      total: 224,
    );

    await tester.pumpWidget(const MaterialApp(home: FullMenuPage()));
    await tester.tap(find.byTooltip('My orders'));
    await tester.pumpAndSettle();

    expect(find.text('My orders'), findsOneWidget);
    expect(find.text('2 × Matcha'), findsOneWidget);
    expect(find.text('Large · Iced · Sugar 50%'), findsOneWidget);
    expect(find.text('42 Cafe Street'), findsOneWidget);
    expect(find.text('Order Received'), findsNWidgets(2));
    expect(find.text('1 × Pepperoni'), findsNothing);
    expect(find.text('Other Street'), findsNothing);

    OrderDatabase.instance.updateStatus(customerOrder.id, 'Preparing');
    await tester.pumpAndSettle();
    expect(find.text('Preparing'), findsNWidgets(2));

    OrderDatabase.instance.updateStatus(customerOrder.id, 'On the way');
    await tester.pumpAndSettle();
    expect(find.text('Ready for Pickup'), findsNWidgets(2));

    OrderDatabase.instance.updateStatus(customerOrder.id, 'Delivered');
    await tester.pumpAndSettle();
    expect(find.text('Completed'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('login sign-up creates a customer account', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('New here? Sign up'));
    await tester.tap(find.text('New here? Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Create your customer account'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'newcustomer');
    await tester.enterText(find.byType(TextFormField).at(1), 'newpass123');
    await tester.enterText(find.byType(TextFormField).at(2), 'different123');
    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Passwords do not match'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(2), 'newpass123');
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('CLICK THE MENU'), findsOneWidget);
    expect(find.text('Matcha'), findsOneWidget);
  });

  testWidgets('admin sign in opens order history', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextFormField).at(0), 'admin1');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.ensureVisible(find.text('Sign In'));
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, admin1'), findsOneWidget);
    expect(find.text('Order history'), findsOneWidget);
    expect(find.text('No customer orders yet.'), findsOneWidget);
    expect(find.text('Total orders'), findsOneWidget);
    expect(find.text('Active'), findsNWidgets(2));
    expect(find.text('Delivered'), findsNWidgets(2));
    expect(find.text('Order total'), findsNothing);
  });

  testWidgets('admin can filter order history by status', (tester) async {
    tester.view.physicalSize = const Size(1000, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AppSession.instance.signIn('admin1', 'password123');
    OrderDatabase.instance.addOrder(
      customerName: 'Pending Customer',
      deliveryAddress: '1 Cafe Street',
      items: const [OrderLine(name: 'Latte', quantity: 1, unitPrice: 4.5)],
      total: 4.5,
    );
    final deliveredOrder = OrderDatabase.instance.addOrder(
      customerName: 'Delivered Customer',
      deliveryAddress: '2 Cafe Street',
      items: const [OrderLine(name: 'Pizza', quantity: 2, unitPrice: 12)],
      total: 24,
    );
    OrderDatabase.instance.updateStatus(deliveredOrder.id, 'Delivered');

    await tester.pumpWidget(const MaterialApp(home: AdminPage()));
    await tester.pumpAndSettle();

    expect(find.text('Pending Customer'), findsOneWidget);
    expect(find.text('Delivered Customer'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Delivered'));
    await tester.pumpAndSettle();

    expect(find.text('Delivered Customer'), findsOneWidget);
    expect(find.text('Pending Customer'), findsNothing);
    expect(find.text('2 × Pizza'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.pumpAndSettle();
    expect(find.text('Pending Customer'), findsOneWidget);
    expect(find.text('Delivered Customer'), findsOneWidget);
  });

  testWidgets('customer cannot directly open the admin dashboard', (
    tester,
  ) async {
    AppSession.instance.signIn('user1', 'password123');

    await tester.pumpWidget(const MaterialApp(home: AdminPage()));

    expect(find.text('Admin access required'), findsOneWidget);
    expect(find.text('Order history'), findsNothing);
  });

  testWidgets('customer checkout adds an order to order history', (
    tester,
  ) async {
    AppSession.instance.signIn('user1', 'password123');
    await tester.pumpWidget(const MaterialApp(home: AppShell()));
    await tester.ensureVisible(find.text('Add').first);
    await tester.tap(find.text('Add').first);
    await tester.pump();

    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Place Order'));
    await tester.pumpAndSettle();

    expect(find.text('Delivery address'), findsOneWidget);
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a delivery address'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).last,
      '42 Cafe Street, Manila',
    );
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();

    expect(
      find.text('Order placed and added to order history.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining(OrderDatabase.instance.orders.value.first.id),
      findsOneWidget,
    );
    expect(find.text('1 × Paneer Tikka Bowl'), findsOneWidget);
    expect(find.text('42 Cafe Street, Manila'), findsOneWidget);
  });

  testWidgets('menu cart supports quantities and mixed coffee-pizza orders', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await signInAsUser(tester);

    final orderButton = find.widgetWithText(FilledButton, 'Order').first;
    await tester.ensureVisible(orderButton);
    await tester.tap(orderButton);
    await tester.pumpAndSettle();

    expect(find.text('Add to your order'), findsOneWidget);
    await tester.ensureVisible(find.text('Large'));
    await tester.tap(find.text('Large'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Oat milk'));
    await tester.tap(find.text('Oat milk'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('50%'));
    await tester.tap(find.text('50%'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Increase quantity'));
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();
    expect(find.text('Add to your order'), findsNothing);

    tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .jumpTo(0);
    await tester.pumpAndSettle();
    tester
        .widget<InkWell>(
          find
              .ancestor(
                of: find.text('PIZZA').first,
                matching: find.byType(InkWell),
              )
              .first,
        )
        .onTap!
        .call();
    await tester.pumpAndSettle();
    tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .jumpTo(0);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Margherita').first);
    final pizzaOrderButton = find.widgetWithText(FilledButton, 'Order').first;
    await tester.ensureVisible(pizzaOrderButton);
    tester.widget<FilledButton>(pizzaOrderButton).onPressed!.call();
    await tester.pumpAndSettle();
    expect(find.text('Margherita'), findsNWidgets(2));
    await tester.ensureVisible(find.text('14-inch'));
    await tester.tap(find.text('14-inch'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Extra cheese'));
    await tester.tap(find.text('Extra cheese'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add to cart'));
    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();

    expect(find.text('3 items'), findsOneWidget);
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Checkout'), findsNWidgets(2));
    expect(find.text('3 items in your order'), findsOneWidget);
    expect(find.text('Margherita'), findsNWidgets(2));
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a delivery address'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).last,
      '42 Cafe Street, Manila',
    );
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();

    expect(find.text('Your order has been placed.'), findsOneWidget);
    final order = OrderDatabase.instance.orders.value.single;
    expect(order.items, hasLength(2));
    expect(order.items[0].name, 'Matcha');
    expect(order.items[0].quantity, 2);
    expect(order.items[0].customizations, contains('Large'));
    expect(order.items[0].customizations, contains('Milk: Oat milk'));
    expect(order.items[0].customizations, contains('Sugar 50%'));
    expect(order.items[1].name, 'Margherita');
    expect(order.items[1].quantity, 1);
    expect(order.items[1].unitPrice, 224);
    expect(order.items[1].customizations, contains('14-inch'));
    expect(order.items[1].customizations, contains('Extra cheese (+₱25)'));
    expect(order.deliveryAddress, '42 Cafe Street, Manila');
    expect(order.total, 411);
  });
}

Future<void> signInAsUser(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).at(0), 'user1');
  await tester.enterText(find.byType(TextFormField).at(1), 'password123');
  await tester.ensureVisible(find.text('Sign In'));
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();
}
