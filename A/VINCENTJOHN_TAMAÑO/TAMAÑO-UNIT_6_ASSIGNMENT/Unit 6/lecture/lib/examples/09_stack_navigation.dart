// Slides 41–47: Stack navigation (push and pop), plus dialogs (slide 43).
//
// A tiny shop that shows the four things students need most:
// 1. Push a screen and pass it data through its constructor.
// 2. Pop a screen and send a result back (await the push).
// 3. Named routes with `arguments` (slides 44–45).
// 4. A dialog that returns the user's answer.
//
// Try it: open a product, add it to the cart, open the cart, place the order.
// Use the AppBar back arrow or the Android back button at any point.

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    title: 'Shopping App',
    theme: ThemeData(colorSchemeSeed: Colors.pink),
    home: const ShopHome(),
    routes: shopRoutes,
  ),
);

/// Named routes, registered on MaterialApp (slide 44).
final Map<String, WidgetBuilder> shopRoutes = {
  CheckoutScreen.routeName: (context) => const CheckoutScreen(),
};

class Product {
  const Product(this.name, this.price, this.icon);

  final String name;
  final double price;
  final IconData icon;
}

const List<Product> products = [
  Product('Notebook', 45, Icons.menu_book),
  Product('Ballpen', 12, Icons.edit),
  Product('USB drive', 350, Icons.usb),
  Product('Headphones', 799, Icons.headphones),
];

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  final List<Product> _cart = [];

  Future<void> _openProduct(Product product) async {
    // 1 + 2: pass the product in, and wait for the screen to pop with a result.
    final bool? added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => ProductScreen(product: product)),
    );
    if (added == true) {
      setState(() => _cart.add(product));
    }
  }

  Future<void> _openCheckout() async {
    // 3: a named route. `arguments` can be any object.
    final Object? placed = await Navigator.pushNamed(
      context,
      CheckoutScreen.routeName,
      arguments: List<Product>.of(_cart),
    );
    // After an await, check the screen is still showing before using context.
    if (placed == true && mounted) {
      setState(_cart.clear);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Order placed. Thank you!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: _cart.isEmpty ? null : _openCheckout,
            icon: Badge(
              label: Text('${_cart.length}'),
              isLabelVisible: _cart.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final product in products)
            ListTile(
              leading: Icon(product.icon),
              title: Text(product.name),
              subtitle: Text('₱${product.price.toStringAsFixed(2)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openProduct(product),
            ),
        ],
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    // Scaffold adds the back arrow for us because there is a screen below.
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(product.icon, size: 96),
            Text(
              '₱${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to cart'),
              // Pop with a result for the screen that pushed us.
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static const String routeName = '/checkout';

  Future<void> _placeOrder(BuildContext context, double total) async {
    // 4: showDialog returns whatever the dialog pops with.
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Place order?'),
        content: Text('You will pay ₱${total.toStringAsFixed(2)}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Place order'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Named routes receive their data through the route's settings.
    final List<Product> cart =
        ModalRoute.of(context)!.settings.arguments as List<Product>;
    final double total = cart.fold(0, (sum, p) => sum + p.price);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        children: [
          for (final product in cart)
            ListTile(
              leading: Icon(product.icon),
              title: Text(product.name),
              trailing: Text('₱${product.price.toStringAsFixed(2)}'),
            ),
          const Divider(),
          ListTile(
            title: const Text('Total'),
            trailing: Text(
              '₱${total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () => _placeOrder(context, total),
              child: const Text('Place order'),
            ),
          ),
        ],
      ),
    );
  }
}
