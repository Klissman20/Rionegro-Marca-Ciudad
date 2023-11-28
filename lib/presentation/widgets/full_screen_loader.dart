import 'package:flutter/material.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Cargando datos',
      'Obteniendo posición',
      'Fijando anclajes',
      'Espere por favor',
    ];
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.colorApp,
        child: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Cargando',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(
                height: 10,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: getLoadingMessages(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Cargando...',
                          style: TextStyle(color: Colors.white, fontSize: 14));
                    }
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    );
                  })
            ]),
          ),
        ),
      ),
    );
  }
}
