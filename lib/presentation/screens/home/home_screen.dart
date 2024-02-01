import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';
import 'package:rionegro_marca_ciudad/infrastructure/models/device_model.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/auth_repository_provider.dart';

import 'package:rionegro_marca_ciudad/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String name = 'home-screen';
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final String _tag = "Turismo Rionegro";
  String _beaconResult = 'Not Scanned Yet.';
  //int _nrMessagesReceived = 0;
  var isRunning = false;
  final List<String> _results = [];
  bool _isInForeground = true;
  DateTime? _lastNotificationTime;

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    // final DarwinInitializationSettings initializationSettingsDarwin =
    //     DarwinInitializationSettings(
    //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: null);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    beaconEventsController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> initPlatformState() async {
    // Check and request necessary permissions
    if (await Permission.location.isGranted) {
      // Location permission is granted, continue with initialization
      initBeaconMonitoring();
    } else {
      // Location permission is not granted, request it
      await Permission.location.request();
    }
  }

  Future<void> initBeaconMonitoring() async {
    // Check and request necessary permissions
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Localizacion en segundo plano",
          message:
              "TurismoRionegro recoje datos de ubicación para una mejor experiencia");

      //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
      await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
    }

    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        //print("Method: ${call.method}");
        if (call.method == 'scannerReady') {
          //_showNotification("Beacons monitoring started..");
          await BeaconsPlugin.startMonitoring();
          setState(() {
            isRunning = true;
          });
        } else if (call.method == 'isPermissionDialogShown') {
          _showNotification(
              "Prominent disclosure message is shown to the user!");
        }
      });
    }
    // if (Platform.isIOS) {
    //   _showNotification("Beacons monitoring started..");
    //   await BeaconsPlugin.startMonitoring();
    //   setState(() {
    //     isRunning = true;
    //   });
    // }

    BeaconsPlugin.listenToBeacons(beaconEventsController);

    BeaconsPlugin.addRegion("test", "B9407F30-F5F8-466E-AFF9-25556B57FE6D");
    // await BeaconsPlugin.addRegion("e71d15069da696876c127e6c9bfa1e15",
    //     "B9407F30-F5F8-466E-AFF9-25556B57FE6D");

    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25");
    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");

    BeaconsPlugin.setForegroundScanPeriodForAndroid(
        foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);

    BeaconsPlugin.setBackgroundScanPeriodForAndroid(
        backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);

    beaconEventsController.stream.listen(
        (data) {
          if (data.isNotEmpty && isRunning) {
            setState(() {
              _beaconResult = data;
              _results.add(_beaconResult);
              //_nrMessagesReceived++;
            });
            final mdata = DeviceData.fromJson(jsonDecode(data));

            if (!_isInForeground) {
              if (mdata.macAddress == "CA:0E:FD:72:2C:4A") {
                if (mdata.distance < 5) {
                  _showNotification(
                      "Bienvenido. Se encuentra en una zona de turismo inteligente. para conocer mas da clic aquí");
                }
              }
              if (mdata.macAddress == "E2:EE:94:93:32:7F") {
                if (mdata.distance < 5) {
                  _showNotification(
                      "Bienvenido. Se encuentra en una zona de turismo inteligente. para conocer mas da clic aquí");
                }
              }
              if (mdata.macAddress == "FF:1D:37:71:42:E3") {
                if (mdata.distance < 5) {
                  _showNotification(
                      "Bienvenido. Se encuentra en una zona de turismo inteligente. para conocer mas da clic aquí");
                }
              }
              return;
            }

            // if (mdata.macAddress == "CA:0E:FD:72:2C:4A") {
            //   if (mdata.distance < 5) {
            //     _showNotification("beacon1 esta cerca");
            //   }
            // }
            // if (mdata.macAddress == "E2:EE:94:93:32:7F") {
            //   if (mdata.distance < 5) {
            //     _showNotification("beacon2 esta cerca");
            //   }
            // }

            print("Beacons DataReceived: " + data);
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);

    if (!mounted) return;
  }

  void _showNotification(String subtitle) async {
    var rng = Random();

    // Check if enough time has passed since the last notification
    if (_lastNotificationTime == null ||
        DateTime.now().difference(_lastNotificationTime!) >
            const Duration(seconds: 15)) {
      // Enough time has passed, show the notification
      // Future.delayed(const Duration(seconds: 1)).then((result) async {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'your channel id', 'your channel name',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker');
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      await flutterLocalNotificationsPlugin.show(
          rng.nextInt(100000), _tag, subtitle, platformChannelSpecifics,
          payload: 'item x');

      // Update the last notification time
      _lastNotificationTime = DateTime.now();
      // });
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              // Navigator.of(context, rootNavigator: true).pop();
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SecondScreen(payload),
              //   ),
              // );
            },
          )
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  Widget build(BuildContext context) {
    String homeText =
        """Una ciudad verde, histórica y desarrollada que conserva las tradiciones antioqueñas y conecta la región con el mundo.""";

    String descriptionText =
        'Rionegro te ofrece la oportunidad de explorar su rica historia, disfrutar de su belleza natural, degustar la gastronomía local y conectarte con el mundo.';
    
    _launchURLContact() async {
    const url = 'https://ciudadrionegro.co/contacto';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  
  }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.colorApp,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 40.0,
        actions: [
          IconButton(
            onPressed: () async {
              showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
              
                          barrierLabel: 'Location permissions are permanently denied, we cannot request permissions.',
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return AlertDialog(
                              title: const Text('Aviso!'),
                              content: const Text(
                                'Estas a punto de cerrar de sesion. ¿Estas seguro?'
                              ),
                              actions: [
                                TextButton(onPressed: () async{
                                  await ref.read(authRepositoryProvider).signOut();
                                  context.goNamed(LoginScreen.name);
                                  } , child: const Text('Cerrar Sesion')),
                                TextButton(onPressed: () async{
                                  await ref.read(authRepositoryProvider).signOut();
                                  _launchURLContact();
                                  context.goNamed(LoginScreen.name);
                                  
                                  } , child: const Text('Cerrar Sesion y solicitar borrar datos')),
                              ]
                            );
                              
                          }
                        );
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
          padding: const EdgeInsets.only(top: 50),
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
              padding: const EdgeInsets.only(
                  top: 10, bottom: 30, left: 40, right: 40),
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
              color: AppTheme.colorApp1,
              onPressed: () {
                context.pushNamed(MapScreen.name, extra: 1);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            _CustomButton(
              text: 'Ruta de la Historia',
              color: AppTheme.colorApp2,
              onPressed: () {
                context.pushNamed(MapScreen.name, extra: 2);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            _CustomButton(
              text: 'Ruta de la Sostenibilidad',
              color: AppTheme.colorApp3,
              onPressed: () {
                context.pushNamed(MapScreen.name, extra: 3);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            _CustomButton(
              text: 'Ruta de las Flores',
              color: AppTheme.colorApp4,
              onPressed: () {
                context.pushNamed(MapScreen.name, extra: 4);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            _CustomButton(
              text: 'Festividades y eventos',
              color: AppTheme.colorApp5,
              onPressed: () {
                context.pushNamed(EventsScreen.name);
              },
            ),
            const SizedBox(
              height: 40,
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
