import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/home/home_screen.dart';

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20.0, right: 20, left: 20, top: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/welcome.png',
                          height: 80,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Gracias por utilizar nuestra aplicación',
                          style: TextStyle(
                              color: AppTheme.colorApp3,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          """Esperamos que te ayude a disfrutar de tu visita a este hermoso municipio de Antioquia.

En esta aplicación encontrarás información sobre:""",
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Lugares turísticos',
                          style: TextStyle(
                              color: AppTheme.colorApp2,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          """El centro histórico, la Casa de la Convención, la Concatedral de San Nicolás el Magno, el Museo de Artes de Rionegro, etc.""",
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Eventos culturales',
                          style: TextStyle(
                              color: AppTheme.colorApp5,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          """El Festival Internacional de Teatro de Rionegro, el Festival de la Empanada, etc.""",
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Opciones de alojamiento y restaurantes',
                          style: TextStyle(
                              color: AppTheme.colorApp3,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          """El Festival Internacional de Teatro de Rionegro, el Festival de la Empanada, etc.""",
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppTheme.colorApp2)),
                            child: const Text(
                              'Iniciar sesión',
                              style: TextStyle(color: Colors.white),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              context.goNamed(HomeScreen.name);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF00B2E3))),
                            child: const Text(
                              'Continuar como invitado',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                ))),
        Positioned(
            top: 75,
            left: 90,
            right: 80,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: AppTheme.colorApp3,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Bienvenido',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            )),
        Positioned(
            top: 60,
            left: 20,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                  color: AppTheme.colorApp3,
                  borderRadius: const BorderRadius.all(Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset(
                  'assets/logo.png',
                  height: 80,
                ),
              ),
            )),
      ],
    );
  }
}
