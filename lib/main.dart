import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Fibonacci Generater'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int fiboIndex = 0;
  List<Fibonacci> fibonacciList = [];
  List<Fibonacci> fibonacciListSheet = [];

  late ScrollController _controller;

  void generateFibonacci(int count) {
    BigInt a = BigInt.zero;
    BigInt b = BigInt.one;
    String formatted;
    IconData icon;
    fibonacciList.clear();
    for (int i = 0; i < count; i++) {
      formatted = BigIntToString(a);
      BigInt.parse(formatted) % BigInt.parse('3') == BigInt.zero
          ? icon = Icons.circle
          : BigInt.parse(formatted) % BigInt.parse('3') == BigInt.one
              ? icon = Icons.square_outlined
              : icon = Icons.close;
      fibonacciList.add(
        Fibonacci(i, formatted, icon),
      );
      BigInt temp = a + b;
      a = b;
      b = temp;
    }
  }

  String BigIntToString(BigInt n) {
    String result = '';
    String strN = n.abs().toString();
    result = strN;
    return result;
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print("reach the bottom");
        fiboIndex = fiboIndex + 40;
        generateFibonacci(fiboIndex);
        print(fibonacciList.length);
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fiboIndex = fiboIndex + 40;
    generateFibonacci(fiboIndex);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: fibonacciList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        fibonacciListSheet.add(fibonacciList[index]);
                        fibonacciList.removeAt(index);
                      });
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: fibonacciListSheet.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          'index: ${fibonacciListSheet[index].index} Number: ${fibonacciListSheet[index].number}',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ListTile(
                            title: Text(
                              'Number ${fibonacciList[index].number}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle:
                                Text('Index ${fibonacciList[index].index}'),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Icon(fibonacciList[index].icon))
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Fibonacci {
  final int index;
  final String number;
  final IconData icon;
  Fibonacci(this.index, this.number, this.icon);
}
