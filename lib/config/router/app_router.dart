import 'package:go_router/go_router.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        name: MapScreen.name,
        path: '/map',
        builder: (context, state) {
          int category = state.extra as int;
          return MapScreen(category: category);
        }),
    GoRoute(
        name: HomeScreen.name,
        path: '/home',
        builder: (context, state) => const HomeScreen()),
    GoRoute(
        name: LoginScreen.name,
        path: '/login',
        builder: (context, state) => const LoginScreen()),
    GoRoute(
        name: RegisterScreen.name,
        path: '/register',
        builder: (context, state) => const RegisterScreen()),
    GoRoute(
        name: SplashScreenAnimated.name,
        path: '/',
        builder: (context, state) => const SplashScreenAnimated()),
    GoRoute(
        path: '/events',
        name: EventsScreen.name,
        builder: (context, state) => const EventsScreen()),
  ],
);
