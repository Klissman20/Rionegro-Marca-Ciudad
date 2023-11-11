import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/screens.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/login/password_field_box.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/login/text_field_box.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  String inputUser = '';
  String inputPassword = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerUser.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero, () {
  //     showGeneralDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       pageBuilder: (context, a1, a2) => Container(),
  //       transitionBuilder: (context, a1, a2, child) => WelcomeDialog(),
  //     );
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    String? errorTextEmail(String text) => text.isEmpty
        ? 'Can\'t be empty'
        : !text.contains('@') || !text.contains('.')
            ? 'Enter a valid email'
            : null;

    String? errorTextPassword(String text) => text.isEmpty
        ? 'Can\'t be empty'
        : text.length < 8
            ? 'Too short'
            : null;

    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover)),
        ),
        SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  'assets/logo.png',
                  height: 200,
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: CustomTextField(
                      controller: controllerUser,
                      labelText: 'Usuario',
                      onChanged: () {},
                      prefixIcon: Icons.person_outlined,
                      typeText: TextInputType.emailAddress),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: PasswordFieldBox(
                    controller: controllerPassword,
                    onChanged: (value) {
                      setState(() {
                        inputPassword = controllerPassword.text;
                      });
                    },
                    errorText: '',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: _LogInButton(
                    text: 'Ingresar',
                    user: inputUser.trim(),
                    password: inputPassword,
                    valid: errorTextPassword(controllerPassword.value.text) !=
                            null ||
                        errorTextEmail(controllerUser.value.text) != null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        '¿No tiene una cuenta? - Registrese',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 17),
                      )),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _GoogleButton(),
                    SizedBox(
                      height: 10,
                    ),
                    _AppleButton(),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

class _LogInButton extends StatelessWidget {
  final String text;
  final String user;
  final String password;
  final bool valid;
  const _LogInButton({
    required this.text,
    required this.user,
    required this.password,
    required this.valid,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            context.goNamed(HomeScreen.name);
          },
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFFF5B335)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Colors.transparent)))),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0),
          )),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyleBtn = TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

    return SizedBox(
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF00B2E3)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(color: Colors.transparent)))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                'assets/google-logo.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Ingresar con Google',
              style: textStyleBtn,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        onPressed: () async {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

class _AppleButton extends StatelessWidget {
  const _AppleButton();

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyleBtn = TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

    return SizedBox(
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF00B2E3)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(color: Colors.transparent)))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.5),
              child: Image.asset(
                'assets/apple-logo.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Ingresar con Apple',
              style: textStyleBtn,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        onPressed: () async {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
