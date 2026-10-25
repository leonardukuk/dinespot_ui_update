class CafeMenuItem {
  const CafeMenuItem({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    this.category = '',
    this.rating,
    this.isBestSeller = false,
    this.isAvailable = true,
  });

  final String name;
  final String price;
  final String image;
  final String description;
  final String category;
  final double? rating;
  final bool isBestSeller;
  final bool isAvailable;
}

class MenuDatabase {
  static const List<CafeMenuItem> coffeeMenu = [
    CafeMenuItem(
      name: 'Matcha',
      price: '₱69',
      image: 'lib/images/matcha123.jpg',
      description: 'Smooth, earthy and served over ice.',
      category: 'Coffee',
      isBestSeller: true,
    ),
    CafeMenuItem(
      name: 'Americano',
      price: '₱49',
      image: 'lib/images/cafe1.jpg',
      description: 'Bold espresso with a clean finish.',
      category: 'Coffee',
      isBestSeller: true,
    ),
    CafeMenuItem(
      name: 'Cold Brew',
      price: '₱69',
      image: 'lib/images/cafe2.jpg',
      description: 'Slow-steeped coffee, served chilled.',
      category: 'Coffee',
    ),
    CafeMenuItem(
      name: 'Latte',
      price: '₱89',
      image: 'lib/images/cafe3.jpg',
      description: 'Espresso blended with silky steamed milk.',
      category: 'Coffee',
      isBestSeller: true,
    ),
    CafeMenuItem(
      name: 'Mocha',
      price: '₱99',
      image: 'lib/images/cafe4.jpg',
      description: 'Rich coffee with a chocolate finish.',
      category: 'Coffee',
    ),
    CafeMenuItem(
      name: 'Iced Americano',
      price: '₱79',
      image: 'lib/images/cafe5.jpg',
      description: 'A refreshing espresso over ice.',
      category: 'Coffee',
    ),
    CafeMenuItem(
      name: 'Cappuccino',
      price: '₱89',
      image: 'lib/images/cafe6.jpg',
      description: 'Espresso topped with airy milk foam.',
      category: 'Coffee',
    ),
    CafeMenuItem(
      name: 'Caramel Macchiato',
      price: '₱109',
      image: 'lib/images/cafe7.jpg',
      description: 'Layered espresso with sweet caramel.',
      category: 'Coffee',
    ),
    CafeMenuItem(
      name: 'Irish Cream Coffee',
      price: '₱119',
      image: 'lib/images/cafe8.jpg',
      description: 'A creamy coffee with a hint of spice.',
      category: 'Coffee',
    ),
    CafeMenuItem(
      name: 'Spanish Latte',
      price: '₱99',
      image: 'lib/images/cafe9.jpg',
      description: 'Espresso softened with sweet milk.',
      category: 'Coffee',
    ),
  ];

  static const List<CafeMenuItem> pizzaMenu = [
    CafeMenuItem(
      name: 'Margherita',
      price: '₱199',
      image: 'lib/images/pizza1.jpg',
      description: 'Tomato, mozzarella and fresh basil.',
      category: 'Pizza',
      isBestSeller: true,
    ),
    CafeMenuItem(
      name: 'Pepperoni',
      price: '₱219',
      image: 'lib/images/piza2.jpg',
      description: 'Classic pepperoni with melted cheese.',
      category: 'Pizza',
      isBestSeller: true,
    ),
    CafeMenuItem(
      name: 'Hawaiian',
      price: '₱229',
      image: 'lib/images/piza3.jpg',
      description: 'Ham and pineapple over tomato and cheese.',
      category: 'Pizza',
      isBestSeller: true,
    ),
    CafeMenuItem(
      name: 'Veggie',
      price: '₱209',
      image: 'lib/images/pizza4.jpg',
      description: 'A colorful mix of garden vegetables.',
      category: 'Pizza',
    ),
    CafeMenuItem(
      name: 'Garden Veggie',
      price: '₱219',
      image: 'lib/images/pizza5.jpg',
      description: 'Fresh vegetables with herbs and cheese.',
      category: 'Pizza',
    ),
    CafeMenuItem(
      name: 'Chicken Special',
      price: '₱249',
      image: 'lib/images/pizza6.jpg',
      description: 'Tender chicken with our house toppings.',
      category: 'Pizza',
    ),
    CafeMenuItem(
      name: 'Four Cheese',
      price: '₱259',
      image: 'lib/images/pizza7.jpg',
      description: 'A golden blend of four creamy cheeses.',
      category: 'Pizza',
    ),
    CafeMenuItem(
      name: 'BBQ Chicken',
      price: '₱249',
      image: 'lib/images/pizza8.jpg',
      description: 'Smoky barbecue sauce and juicy chicken.',
      category: 'Pizza',
    ),
    CafeMenuItem(
      name: 'Meat Lovers',
      price: '₱269',
      image: 'lib/images/pizza9.jpg',
      description: 'Loaded with savory, hearty toppings.',
      category: 'Pizza',
    ),
  ];
}
