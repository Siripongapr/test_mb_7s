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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<String> fibonacciList = [];
  late ScrollController _controller;

  void generateFibonacci(int count) {
    BigInt a = BigInt.zero;
    BigInt b = BigInt.one;
    fibonacciList.clear();
    for (int i = 0; i < count; i++) {
      fibonacciList.add(BigIntToString(a));
      BigInt temp = a + b;
      a = b;
      b = temp;
    }
  }

  String BigIntToString(BigInt n) {
    String result = '';
    String strN = n.abs().toString();
    for (int i = 0; i < strN.length; i += 3) {
      int endIndex = (i + 3 < strN.length) ? i + 3 : strN.length;
      String part = strN.substring(i, endIndex);
      result += part;
    }
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
        title: Text(widget.title),
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
                  return Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListTile(
                          title: Text('Number ${fibonacciList[index]}'),
                          subtitle: Text('Index $index'),
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Icon(((BigInt.parse(fibonacciList[index])) %
                                      BigInt.parse('3')) ==
                                  BigInt.zero
                              ? Icons.circle
                              : ((BigInt.parse(fibonacciList[index])) %
                                          BigInt.parse('3')) ==
                                      BigInt.one
                                  ? Icons.square_outlined
                                  : Icons.close_outlined))
                    ],
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
