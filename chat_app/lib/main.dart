import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chat_app/features/home/Home.dart';
import 'package:chat_app/features/chat/Chat.dart';
void main() {
  runApp(const App());
}

final GoRouter _router = GoRouter (
  routes: <RouteBase>[
    GoRoute(
      path:"/",
      builder:(BuildContext context, GoRouterState state) {
        // return const HomeScreen();
        return const ChatScreen();
      },
      routes:<RouteBase>[
        GoRoute(
          path: "chat",
          builder:(BuildContext context, GoRouterState state) {
            return const ChatScreen();
          },
        ),
      ],
    ),
  ],
);

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}

