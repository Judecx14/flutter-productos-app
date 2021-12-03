import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/styles/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFromProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFromProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  url: productService.selectedProduct.picture,
                ),
                Positioned(
                  top: 40.0,
                  left: 5.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 40.0,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  top: 40.0,
                  right: 20.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 40.0,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      // Pick an image
                      final XFile? image = await _picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100,
                      );
                      if (image == null) {
                        print('no selecciono nada');
                      } else {
                        productService.updateSelectedProductImage(image.path);
                        //Verificamos que un provider puede escuhcar a otro
                        //Provider
                        //Por eso la propiedad picutre de productForm si
                        //Cambia
                        print("Product Form ${productForm.product.picture}");
                        print("Image path ${image.path}");
                      }
                    },
                  ),
                ),
              ],
            ),
            _ProductForm(),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: productService.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.save_outlined),
        onPressed: productService.isSaving
            ? null
            : () async {
                if (!productForm.isValidForm()) return;
                //Aquí hacemos esto para poder cargar nuestra imagen desde la
                //direccion que nos retorna la respuesta cundo subimos la imagen
                //Aunque la imagen ya tiene la imagen toma
                //Pero al momento que asignamso este valor
                //Se carga la imagen de nuevo desde interntet
                //Ejecutamos primero el uplaoadImage para saber si es que se va
                //======================================//
                //Actualiza la imagen o se va subir una nueva
                //Con esto obtenemos el link publico donde se guardo la imagen
                //En cloudnary
                final String? imageUrl = await productService.uploadImage();
                //Una vez que lo obtenemos se lo asignamso a nuestro product
                //Del productForm para que este valor cambie por la url de la imagen
                //Ya subida en cloudnary, esto porque sino lo hacemos
                //Se va subir el path local del celular
                if (imageUrl != null) productForm.product.picture = imageUrl;
                //Por ultimo guardamos o creamos el producto
                await productService.saveOrCreateProduct(productForm.product);
              },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFromProvider>(context);
    final product = productForm.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: _formContainerDecoration(),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: productForm.formKey,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre:',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^(\d+)?\.?\d{0,2}'),
                  )
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'El precio es obligatorio';
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio:',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SwitchListTile.adaptive(
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                value: product.available,
                onChanged: productForm.updateAvailability,
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _formContainerDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0.0, 5),
            blurRadius: 5.0,
          )
        ],
      );
}
