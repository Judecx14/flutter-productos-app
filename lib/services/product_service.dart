import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as https;

class ProductService extends ChangeNotifier {
  final String _baseURL = 'flutter-varios-6da60-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool _isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;

  File? newPictureFile;

  bool get isLoading => _isLoading;

  final storage = FlutterSecureStorage();

  ProductService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    //No es necesario color https en el string porque el metodo lo pone (Https)
    final url = Uri.https(_baseURL, '/productos.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final resp = await https.get(url);
    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    _isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseURL, '/productos/${product.id}.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    /* final resp =  */
    await https.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseURL, '/productos.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final resp = await https.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body); // COnvierte en mapa
    product.id = decodedData['name']; //Id genereado por FIREBASE
    products.add(product);
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;
    isSaving = true;

    //Creamos la url
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/djldaixtk/image/upload?upload_preset=pcuhg6au',
    );
    final imageUploadRequest = https.MultipartRequest('POST', url);
    final file = await https.MultipartFile.fromPath(
      'file',
      newPictureFile!.path,
    );
    imageUploadRequest.files.add(file);
    final stremResponse = await imageUploadRequest.send();
    final resp = await https.Response.fromStream(stremResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }
    newPictureFile = null; // Limpiamos esta propiedad
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
