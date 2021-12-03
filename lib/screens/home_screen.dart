import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/screens/loading_screen.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    if (productService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Productos'),
        leading: IconButton(
          icon: const Icon(Icons.login),
          onPressed: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: ListView.builder(
        itemCount: productService.products.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              productService.selectedProduct =
                  productService.products[index].copy();
              Navigator.pushNamed(context, 'product');
            },
            child: ProductCard(
              product: productService.products[index],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productService.selectedProduct = Product(
            available: false,
            name: '',
            price: 0.0,
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
