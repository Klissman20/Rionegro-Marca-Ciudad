import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/auth_repository_provider.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/supabase_provider.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/screens.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/login/password_field_box.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/login/text_field_box.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/login/welcome.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String name = 'login-screen';
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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

  @override
  void initState() {
    _setupAuthListener();
    Future.delayed(Duration.zero, () {
      showGeneralDialog(
        context: context,
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.8),
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, __, ___) {
          return const Material(
              color: Colors.transparent, child: Center(child: WelcomeDialog()));
        },
        transitionBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        },
      );
    });

    super.initState();
  }

  void _setupAuthListener() {
    ref.read(supabaseProvider).auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        context.goNamed(HomeScreen.name);
      }
    });
  }

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
      backgroundColor: AppTheme.colorApp,
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
                        onChanged: () {
                          setState(() {
                            inputUser = controllerUser.text;
                          });
                        },
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
                      user: inputUser,
                      password: inputPassword,
                      valid: errorTextPassword(controllerPassword.value.text) !=
                              null ||
                          errorTextEmail(controllerUser.value.text) != null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: TextButton(
                        onPressed: () {
                          context.pushNamed(RegisterScreen.name);
                        },
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
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      persistentFooterButtons: [
        TextButton(
            onPressed: () {},
            child: const Text(
              "Copyright © Subsecreataría de Desarrollo Económico 2023",
              maxLines: 1,
              style: TextStyle(fontSize: 12, color: Colors.white),
            ))
      ],
      persistentFooterAlignment: AlignmentDirectional.bottomCenter,
    );
  }
}

class _LogInButton extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () async {
            final response = await ref
                .read(authRepositoryProvider)
                .signIn(email: user, password: password);
            if (response['state'] == 'ok') {
              return context.goNamed(MapScreen.name);
            }
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Ups!'),
                content: Text(removeFirstWord(response['error'].toString())),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Ok"))
                ],
              ),
            );
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

class _GoogleButton extends ConsumerWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          final response =
              await ref.read(authRepositoryProvider).continueWithGoogle();
          if (response['state'] == 'ok')
            context
                .goNamed(HomeScreen.name); // context.goNamed(HomeScreen.name);
        },
      ),
    );
  }
}

class _AppleButton extends ConsumerWidget {
  const _AppleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        onPressed: () {
          FocusScope.of(context).unfocus();
          ref.read(authRepositoryProvider).continueWithApple(context);
          final session = ref.read(supabaseProvider).auth.currentSession;
          if (session != null) {
            context.goNamed(HomeScreen.name);
          }
        },
      ),
    );
  }
}

String removeFirstWord(String input) {
  List<String> words = input.split(' ');
  if (words.length <= 1) {
    return '';
  }
  words.removeAt(0);
  return words.join(' ');
}
