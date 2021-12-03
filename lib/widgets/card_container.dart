import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        //Esta es otra manera de seprar
        //margin: EdgeInsets.symmetric(horizontal: 30.0),
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: _cardShape(),
        child: child,
      ),
    );
  }

  BoxDecoration _cardShape() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 0),
            ),
          ]);
}
