import 'package:flutter/material.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';

import 'package:rionegro_marca_ciudad/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String homeText =
        """Una ciudad verde, histórica y desarrollada que conserva las tradiciones antioqueñas y conecta la región con el mundo.""";

    String descriptionText =
        'Rionegro te ofrece la oportunidad de explorar su rica historia, disfrutar de su belleza natural, degustar la gastronomía local y conectarte con el mundo.';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.colorApp,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 40.0,
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed(LoginScreen.name);
            },
            icon: const Icon(Icons.exit_to_app),
            color: Colors.white,
          )
        ],
      ),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover)),
        ),
        SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Center(
              child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/logo.png',
              height: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                homeText,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    letterSpacing: 1.0),
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Text(
                descriptionText,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1,
                    letterSpacing: 0.7),
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
            ),
            _CustomButton(
              text: 'Ruta del Sabor',
              color: const Color(0xFF00B2E3),
              onPressed: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            _CustomButton(
              text: 'Ruta de la Historia',
              color: const Color(0xFFF5B335),
              onPressed: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            _CustomButton(
              text: 'Ruta de la Sostenibilidad',
              color: const Color(0xFF45C2B1),
              onPressed: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            _CustomButton(
              text: 'Ruta de las Flores',
              color: const Color(0xFFBB77C9),
              onPressed: () {},
            ),
          ])),
        )),
      ]),
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function() onPressed;
  const _CustomButton(
      {required this.text, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Colors.transparent)))),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
