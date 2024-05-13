import 'package:flutter/material.dart';
import 'package:test_mb_7s/screen/fibonacci_page.dart';

class RouterScreen {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/fibonacciPage':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/fibonacciPage'),
            builder: (_) => const FibonacciPage(title: 'Fibonacci Generater'));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
