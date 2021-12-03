import 'package:flutter/material.dart';
import 'package:productos_app/models/product.dart';

class ProductFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;

  ProductFromProvider(this.product);

  updateAvailability(bool value) {
    product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(product.name);
    print(product.price);
    print(product.available);
    return formKey.currentState?.validate() ?? false;
  }
}
