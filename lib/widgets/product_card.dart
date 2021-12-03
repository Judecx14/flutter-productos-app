import 'package:flutter/material.dart';
import 'package:productos_app/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        margin: const EdgeInsets.only(top: 30.0, bottom: 50.0),
        width: double.infinity,
        height: 400.0,
        decoration: _cardDecoration(),
        child: Stack(
          //Este coloca los elemntes abajo
          alignment: Alignment.bottomCenter,
          children: [
            //Pero est no se mueve porque abarca todo el tamaño del container
            _BackgroundImage(product.picture),
            _ProductDetails(
              productName: product.name,
              productId: product.id!,
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: _PriceTag(
                product.price,
              ),
            ),
            //Los if en dart pueden ir incluso dentro de un arreglo
            if (!product.available)
              const Positioned(
                top: 0.0,
                left: 0.0,
                //child: product.available ? Container() : const _NotAvailable(),
                child: _NotAvailable(),
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 7.0),
            blurRadius: 15,
          )
        ],
      );
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 70.0,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'No disponible',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final double price;
  const _PriceTag(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 70.0,
      //Centrar contenido en container
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      //FittedBox sirve para restringir el tamaño del widget en este caso del
      //Texto con el contain estamos diciendo que contenga las dimensiones
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            '\$$price',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  final String? url;
  const _BackgroundImage(this.url);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: double.infinity,
        height: 400.0,
        child: url == null
            ? const Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              )
            : FadeInImage(
                placeholder: const AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(url ?? ''),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String productName;
  final String productId;
  const _ProductDetails({
    Key? key,
    required this.productName,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        width: double.infinity,
        height: 70.0,
        decoration: _titleBottomDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              productId,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _titleBottomDecoration() => const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      );
}
