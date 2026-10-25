import 'package:flutter/material.dart';

import 'database/menu_database.dart';

const _cartEspresso = Color(0xFF34221B);
const _cartCoffee = Color(0xFF76513B);
const _cartCaramel = Color(0xFFC66B3D);
const _cartCream = Color(0xFFFAF7F2);
const _cartMuted = Color(0xFF81766F);
const _toppingPrice = 25.0;

class CartEntry {
  const CartEntry({
    required this.key,
    required this.item,
    required this.options,
    required this.quantity,
    required this.unitPrice,
  });

  final String key;
  final CafeMenuItem item;
  final List<String> options;
  final int quantity;
  final double unitPrice;

  String get optionSummary => options.join(' · ');

  CartEntry copyWith({int? quantity}) => CartEntry(
    key: key,
    item: item,
    options: options,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice,
  );
}

class AddToCartDialog extends StatefulWidget {
  const AddToCartDialog({
    super.key,
    required this.item,
    required this.price,
    required this.isPizza,
  });

  final CafeMenuItem item;
  final double price;
  final bool isPizza;

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  int _quantity = 1;
  late String _size;
  late String _temperature;
  String _sugar = '100%';
  String _milk = 'Whole milk';
  final Set<String> _toppings = {};

  @override
  void initState() {
    super.initState();
    _size = widget.isPizza ? '12-inch' : 'Medium';
    _temperature =
        widget.item.name.toLowerCase().contains('iced') ||
            widget.item.name == 'Matcha' ||
            widget.item.name == 'Cold Brew'
        ? 'Iced'
        : 'Hot';
  }

  List<String> get _options => widget.isPizza
      ? [_size, ..._toppings.map((topping) => '$topping (+₱25)')]
      : [_size, _temperature, 'Sugar $_sugar', 'Milk: $_milk'];

  String get _selectionKey => [
    widget.item.name,
    _size,
    if (!widget.isPizza) _temperature,
    if (!widget.isPizza) _sugar,
    if (!widget.isPizza) _milk,
    ..._toppings.toList()..sort(),
  ].join('|');

  double get _unitPrice => widget.price + _toppings.length * _toppingPrice;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      title: const Text(
        'Add to your order',
        style: TextStyle(color: _cartEspresso, fontWeight: FontWeight.w800),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.sizeOf(context).height * 0.48,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      widget.item.image,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name,
                          style: const TextStyle(
                            color: _cartEspresso,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₱${_unitPrice.toStringAsFixed(2)}',
                          style: const TextStyle(color: _cartCoffee),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _optionSection(
                title: 'Size',
                values: widget.isPizza
                    ? const ['9-inch', '12-inch', '14-inch']
                    : const ['Small', 'Medium', 'Large'],
                selected: _size,
                onSelected: (value) => setState(() => _size = value),
              ),
              if (widget.isPizza) ...[
                const SizedBox(height: 12),
                _toppingSection(),
              ] else ...[
                const SizedBox(height: 12),
                _optionSection(
                  title: 'Temperature',
                  values: const ['Hot', 'Iced'],
                  selected: _temperature,
                  onSelected: (value) => setState(() => _temperature = value),
                ),
                const SizedBox(height: 12),
                _optionSection(
                  title: 'Sugar',
                  values: const ['0%', '25%', '50%', '75%', '100%'],
                  selected: _sugar,
                  onSelected: (value) => setState(() => _sugar = value),
                ),
                const SizedBox(height: 12),
                _optionSection(
                  title: 'Milk',
                  values: const [
                    'Whole milk',
                    'Oat milk',
                    'Almond milk',
                    'None',
                  ],
                  selected: _milk,
                  onSelected: (value) => setState(() => _milk = value),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Quantity',
                      style: TextStyle(
                        color: _cartEspresso,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _QuantityButton(
                    tooltip: 'Decrease quantity',
                    icon: Icons.remove_rounded,
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '$_quantity',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _cartEspresso,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _QuantityButton(
                    tooltip: 'Increase quantity',
                    icon: Icons.add_rounded,
                    onPressed: () => setState(() => _quantity++),
                    isAdd: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _cartCream,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Item total',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _cartMuted),
                      ),
                    ),
                    Text(
                      '₱${(_unitPrice * _quantity).toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: _cartEspresso,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(
            CartEntry(
              key: _selectionKey,
              item: widget.item,
              options: List.unmodifiable(_options),
              quantity: _quantity,
              unitPrice: _unitPrice,
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: _cartCaramel,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.shopping_bag_outlined, size: 18),
          label: const Text('Add to cart'),
        ),
      ],
    );
  }

  Widget _optionSection({
    required String title,
    required List<String> values,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _cartEspresso,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: values
              .map(
                (value) => ChoiceChip(
                  label: Text(value),
                  selected: selected == value,
                  onSelected: (_) => onSelected(value),
                  selectedColor: const Color(0xFFF1E5D9),
                  labelStyle: TextStyle(
                    color: selected == value ? _cartCoffee : _cartMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide(
                    color: selected == value
                        ? _cartCaramel.withValues(alpha: 0.6)
                        : const Color(0xFFEDE6DF),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _toppingSection() {
    const toppings = [
      'Extra cheese',
      'Mushrooms',
      'Olives',
      'Jalapeños',
      'Bell peppers',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Extra toppings · ₱25 each',
          style: TextStyle(color: _cartEspresso, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: toppings
              .map(
                (topping) => FilterChip(
                  label: Text(topping),
                  selected: _toppings.contains(topping),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _toppings.add(topping);
                    } else {
                      _toppings.remove(topping);
                    }
                  }),
                  selectedColor: const Color(0xFFF1E5D9),
                  labelStyle: TextStyle(
                    color: _toppings.contains(topping)
                        ? _cartCoffee
                        : _cartMuted,
                    fontSize: 11,
                  ),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Color(0xFFEDE6DF)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class CartCheckoutResult {
  const CartCheckoutResult({required this.quantities, required this.address});

  final Map<String, int> quantities;
  final String address;
}

class CartCheckoutDialog extends StatefulWidget {
  const CartCheckoutDialog({
    super.key,
    required this.entries,
    required this.initialAddress,
  });

  static const deliveryFee = 49.0;

  final List<CartEntry> entries;
  final String initialAddress;

  @override
  State<CartCheckoutDialog> createState() => _CartCheckoutDialogState();
}

class _CartCheckoutDialogState extends State<CartCheckoutDialog> {
  late final TextEditingController _addressController;
  late final Map<String, int> _quantities;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.initialAddress);
    _quantities = {
      for (final entry in widget.entries) entry.key: entry.quantity,
    };
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  double get _subtotal => widget.entries.fold<double>(
    0,
    (sum, entry) =>
        sum + entry.unitPrice * (_quantities[entry.key] ?? entry.quantity),
  );

  int get _quantityCount => widget.entries.fold<int>(
    0,
    (sum, entry) => sum + (_quantities[entry.key] ?? entry.quantity),
  );

  @override
  Widget build(BuildContext context) {
    final total = _subtotal + CartCheckoutDialog.deliveryFee;
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 4),
      contentPadding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF1E5D9),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: _cartCoffee),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Checkout',
                  style: TextStyle(
                    color: _cartEspresso,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '$_quantityCount ${_quantityCount == 1 ? 'item' : 'items'} in your order',
                  style: const TextStyle(
                    color: _cartMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 560),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_quantityCount == 0)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'Your cart is empty.',
                        style: TextStyle(color: _cartMuted),
                      ),
                    ),
                  )
                else
                  ...widget.entries
                      .where((entry) => (_quantities[entry.key] ?? 0) > 0)
                      .map(_buildCartItem),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Subtotal',
                  value: '₱${_subtotal.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Delivery fee',
                  value:
                      '₱${CartCheckoutDialog.deliveryFee.toStringAsFixed(2)}',
                ),
                const Divider(height: 24),
                _SummaryRow(
                  label: 'Total',
                  value: '₱${total.toStringAsFixed(2)}',
                  emphasized: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  autofocus: true,
                  minLines: 2,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Delivery address',
                    hintText: 'House/building, street, city',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    filled: true,
                    fillColor: _cartCream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFEDE6DF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: _cartCaramel,
                        width: 1.5,
                      ),
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
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Keep browsing'),
        ),
        FilledButton(
          onPressed: _quantityCount == 0
              ? null
              : () {
                  if (!_formKey.currentState!.validate()) return;
                  Navigator.of(context).pop(
                    CartCheckoutResult(
                      quantities: Map<String, int>.from(_quantities),
                      address: _addressController.text.trim(),
                    ),
                  );
                },
          style: FilledButton.styleFrom(
            backgroundColor: _cartCaramel,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Place order'),
        ),
      ],
    );
  }

  Widget _buildCartItem(CartEntry entry) {
    final item = entry.item;
    final quantity = _quantities[entry.key] ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _cartCream,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.asset(
              item.image,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _cartEspresso,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (entry.optionSummary.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      entry.optionSummary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _cartMuted, fontSize: 10),
                    ),
                  ),
                const SizedBox(height: 3),
                Text(
                  '₱${entry.unitPrice.toStringAsFixed(2)} each',
                  style: const TextStyle(color: _cartMuted, fontSize: 11),
                ),
                Text(
                  '₱${(entry.unitPrice * quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: _cartCoffee,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          _QuantityButton(
            tooltip: 'Decrease ${item.name} quantity',
            icon: Icons.remove_rounded,
            onPressed: quantity > 0
                ? () => setState(() {
                    _quantities[entry.key] = quantity - 1;
                  })
                : null,
          ),
          SizedBox(
            width: 26,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _cartEspresso,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _QuantityButton(
            tooltip: 'Increase ${item.name} quantity',
            icon: Icons.add_rounded,
            onPressed: () => setState(() {
              _quantities[entry.key] = quantity + 1;
            }),
            isAdd: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: emphasized ? _cartEspresso : _cartMuted,
              fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
              fontSize: emphasized ? 15 : 13,
            ),
          ),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: TextStyle(
            color: emphasized ? _cartEspresso : _cartMuted,
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
            fontSize: emphasized ? 16 : 13,
          ),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.isAdd = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        foregroundColor: isAdd ? Colors.white : _cartCoffee,
        backgroundColor: isAdd ? _cartCaramel : Colors.white,
        minimumSize: const Size(32, 32),
        maximumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
      ),
      icon: Icon(icon, size: 17),
    );
  }
}
