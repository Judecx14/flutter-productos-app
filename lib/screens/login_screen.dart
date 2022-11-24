import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/styles/input_decorations.dart';
import 'package:productos_app/widgets/auth_background.dart';
import 'package:productos_app/widgets/card_container.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 225.0,
              ),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    //Este sirve para cuando nada más queremos un provider
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              TextButton(
                //Estilo boton
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.indigo[300]),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Text(
                  'Crear una nueva cuenta',
                  //Estilo texto
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18.0,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  'register',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        //TODO mantener la referncia al KEY
        key: loginFormProvider.formKey,
        //Esto determina cuando va aparecer el mensaje de completar
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              //Cambiar la rayita del input
              cursorColor: Colors.deepPurple,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'correo@gmail.com',
                labelText: 'Correo electronico',
                prefixIcon: Icons.alternate_email,
              ),
              onChanged: (value) => loginFormProvider.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo no es valido';
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              //Cambiar la rayita del input
              cursorColor: Colors.deepPurple,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*************',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock,
              ),
              onChanged: (value) => loginFormProvider.password = value,
              validator: (value) {
                if (value != null && value.length >= 6) return null;
                return 'La contraseña debe ser de 6 caracteres';
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              disabledColor: Colors.grey,
              elevation: 0.0,
              color: Colors.deepPurple,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100.0,
                  vertical: 20,
                ),
                child: Text(
                  loginFormProvider.isLoading ? 'Espere...' : 'Ingresar',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: loginFormProvider.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus(); //Quitar teclado
                      final authServive = Provider.of<AuthService>(
                        context,
                        listen: false, //No escuhchar dentro de un metodo
                        //Solo de un build (Buenas practicas)
                      );
                      final bool flag = loginFormProvider.isValidForm();
                      if (!flag) return;
                      loginFormProvider.isLoading = true;
                      final String? errorMessage = await authServive.login(
                        loginFormProvider.email,
                        loginFormProvider.password,
                      );
                      //Despues de tener la respuesta quitamos el true
                      loginFormProvider.isLoading = false;
                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        NotificacionsService.showSnackbar(errorMessage);
                      }
                      /*  if (!loginFormProvider.isValidForm()) return;
                Navigator.pushReplacementNamed(context, 'home'); */
                    },
            ),
          ],
        ),
      ),
    );
  }
}
