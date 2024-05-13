import 'package:flutter/material.dart';
import 'package:test_mb_7s/model/fibonacci.dart';

class FibonacciController {
  void generateFibonacci(int count, List<Fibonacci> fibonacciList) {
    BigInt a = fibonacciList.isEmpty
        ? BigInt.zero
        : BigInt.parse(fibonacciList[fibonacciList.length - 2].number);
    BigInt b = fibonacciList.isEmpty
        ? BigInt.one
        : BigInt.parse(fibonacciList.last.number);

    String formatted;
    IconData icon;
    int startIndex = fibonacciList.isEmpty ? 0 : fibonacciList.last.index + 1;
    int currentIndex = startIndex;

    while (count > 0) {
      formatted = bigIntToString(a);
      BigInt.parse(formatted) % BigInt.parse('3') == BigInt.zero
          ? icon = Icons.circle
          : BigInt.parse(formatted) % BigInt.parse('3') == BigInt.one
              ? icon = Icons.square_outlined
              : icon = Icons.close;

      if (!fibonacciList.any((fibo) => fibo.number == formatted) ||
          formatted == '1') {
        fibonacciList.add(Fibonacci(currentIndex, formatted, icon));
        count--;
        currentIndex++;
      }
      BigInt temp = a + b;
      a = b;
      b = temp;
    }
  }

  String bigIntToString(BigInt n) {
    String result = '';
    String strN = n.abs().toString();
    result = strN;
    return result;
  }
}
