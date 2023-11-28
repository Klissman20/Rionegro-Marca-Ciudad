import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';
import 'package:rionegro_marca_ciudad/domain/entities/event_entity.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/event_repository_provider.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/screens.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/events/event_listview.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsScreen extends ConsumerStatefulWidget {
  static const String name = 'events-screen';
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  List<EventEntity> events = [];

  Future<void> launchURL() async {
    const url = 'https://ciudadrionegro.co';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    ref
        .read(eventRepositoryProvider)
        .getEvents()
        .then((value) => setState(() => events = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover)),
        ),
        Positioned(
          child: Container(
            alignment: Alignment.bottomRight,
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      context.pushReplacementNamed(HomeScreen.name);
                    },
                    icon: const Icon(Icons.home_outlined, color: Colors.white)),
                IconButton(
                    onPressed: () {
                      context.goNamed(LoginScreen.name);
                    },
                    icon: const Icon(Icons.exit_to_app_rounded,
                        color: Colors.white))
              ],
            ),
          ),
        ),
        Positioned(
            top: 55,
            left: 20,
            child: InkWell(
                onTap: launchURL,
                child: Image.asset('assets/logo.png', height: 90))),
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Image.asset(
                'assets/rutas/logo_eventos.png',
                height: 70,
              )
            ],
          ),
        ),
        Positioned(
          top: 160,
          right: 100,
          left: 100,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: AppTheme.colorApp5),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                  child: Text(
                    'Eventos',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 200,
            left: 10,
            right: 10,
            bottom: 20,
            child: EventsListView(events: events)),
      ]),
    );
  }
}
