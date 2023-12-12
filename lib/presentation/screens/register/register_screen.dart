import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/auth_repository_provider.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/login/password_field_box.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/login/text_field_box.dart';

import '../screens.dart';

String inputName = '';
String inputEmail = '';
int inputPhone = 0;
String inputPassword = '';

String? errorTextName(String text) {
  if (text.isEmpty) {
    return 'Can\'t be empty';
  }
  // return null if the text is valid
  return null;
}

String? errorTextEmail(String text) {
  if (text.isEmpty) return 'Can\'t be empty';

  if (!text.contains('@') || !text.contains('.')) return 'Enter a valid email';
  // return null if the text is valid
  return null;
}

String? errorTextPhone(String text) {
  if (text.isEmpty) return 'Can\'t be empty';

  if (text.length < 10) return 'Enter a valid phone';
  // return null if the text is valid
  return null;
}

String? errorTextPassword(String text) {
  if (text.isEmpty) return 'Can\'t be empty';

  if (text.length < 8) return 'Too short';
  // return null if the text is valid
  return null;
}

class RegisterScreen extends StatelessWidget {
  static const String name = 'register_screen';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorApp = AppTheme.colorApp;

    return Scaffold(
      body: _RegisterView(),
      backgroundColor: colorApp,
    );
  }
}

class _RegisterView extends ConsumerStatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<_RegisterView> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  /*TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerCountry = TextEditingController(); */
  TextEditingController controllerPassword = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerName.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerPhone.dispose();
    /* controllerGender.dispose();
    controllerPhone.dispose();
    controllerCountry.dispose(); */
    super.dispose();
  }

  @override
  void initState() {
    inputName = controllerName.text;
    inputEmail = controllerEmail.text;
    inputPassword = controllerPassword.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyleBtn = TextStyle(
        color: AppTheme.colorApp, fontSize: 22, fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: AppTheme.colorApp,
      body: SafeArea(
          child: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.colorApp,
          expandedHeight: 145,
          leadingWidth: 80,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => context.pop()),
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.asset(
              'assets/logo.png',
              height: 130,
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
            child: Column(children: [
              CustomTextField(
                errorText: errorTextName(controllerName.value.text),
                typeText: TextInputType.name,
                prefixIcon: Icons.person_3_outlined,
                controller: controllerName,
                labelText: 'Nombre',
                onChanged: () {
                  setState(() {
                    inputName = controllerName.text;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                errorText: errorTextEmail(controllerEmail.value.text),
                typeText: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                controller: controllerEmail,
                labelText: 'Email',
                onChanged: () {
                  setState(() {
                    inputEmail = controllerEmail.text;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              //CustomTextField(
              //  errorText: errorTextPhone(controllerPhone.value.text),
              //  typeText: TextInputType.phone,
               // prefixIcon: Icons.phone_enabled_outlined,
              //  controller: controllerPhone,
              //  labelText: 'Phone',
              //  onChanged: () {
              //    setState(() {
              //      inputPhone = controllerPhone.text.isNotEmpty
              //          ? int.parse(controllerPhone.text)
              //          : 0;
              //    });
              //  },
              //),
              //const SizedBox(
              //  height: 20,
              //),
              PasswordFieldBox(
                errorText: errorTextPassword(controllerPassword.value.text),
                controller: controllerPassword,
                onChanged: (value) {
                  setState(() {
                    inputPassword = controllerPassword.text;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              _RegisterButton(
                textStyleBtn: textStyleBtn,
                name: inputName,
                //phone: inputPhone,
                password: inputPassword,
                email: inputEmail,
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          )
        ]))
      ])),
    );
  }
}

class _RegisterButton extends ConsumerWidget {
  final String? id;
  final String name;
  final String email;
  //final int phone;
  final String password;

  _RegisterButton({
    required this.textStyleBtn,
    this.id,
    required this.name,
    required this.password,
    required this.email,
    //required this.phone,
  });

  final TextStyle textStyleBtn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.transparent)))),
        child: Text(
          'Registrarse',
          style: textStyleBtn,
        ),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          final response = id == null
              ? await ref
                  .read(authRepositoryProvider)
                  .signUp(email: email, password: password)
              : {'uid': id, 'state': 'ok'};
          if (response['state'] == 'ok') {
            return await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: const Text('Grandioso!'),
                      content: Text(
                          'Se ha enviado un email de confirmación a $email'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              ctx.goNamed(LoginScreen.name);
                            },
                            child: const Text("Iniciar Sesion"))
                      ],
                    ));
          }
          return await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Ups!'),
              content: Text(removeFirstWord(response['error'].toString())),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Aceptar"))
              ],
            ),
          );
        },
      ),
    );
  }
}
