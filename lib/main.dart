import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/product_service.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

//Provider tiene un lazy loading esto significa que no importa si la ponemos
//al inicio esta se generar cuando se requiera
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'register': (_) => RegisterScreen(),
        'checking': (_) => CheckAuthScreen(),
        'home': (_) => HomeScreen(),
        'product': (_) => ProductScreen(),
      },
      scaffoldMessengerKey: NotificacionsService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
          color: Colors.indigo,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0.0,
          backgroundColor: Colors.indigo,
        ),
      ),
    );
  }
}
