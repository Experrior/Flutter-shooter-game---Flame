import 'package:archerer/home.dart';
import 'package:archerer/main.dart';
import 'package:archerer/records.dart';
import 'package:go_router/go_router.dart';

// // GoRouter configuration
final gameRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
      GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GamePage(),
    ),
    GoRoute(
      path: '/scores',
      builder: (context, state) => const HighScoreListPage(),
    ),
  ],
);