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
        scaffoldBackgroundColor: Colors.white,
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Fibonacci Generater'),
      debugShowCheckedModeBanner: false,
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
  List<Fibonacci> fibonacciList = [];
  List<Fibonacci> fibonacciListSheet = [];
  int tapIndexMain = -1;
  int tapIndexBs = -1;

  late ScrollController _controller;
  late ScrollController _bsController;

  void generateFibonacci(int count) {
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
      formatted = BigIntToString(a);
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

  String BigIntToString(BigInt n) {
    String result = '';
    String strN = n.abs().toString();
    result = strN;
    return result;
  }

  void _scrollToIndex(int index) {
    _bsController.animateTo(
      index * 56,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print("reach the bottom");
        generateFibonacci(40);
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
    generateFibonacci(40);
    _controller = ScrollController();
    _bsController = ScrollController();
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
                        fibonacciListSheet
                            .sort((a, b) => a.index.compareTo(b.index));
                        tapIndexBs = fibonacciList[index].index;
                        fibonacciList.removeAt(index);
                        tapIndexMain = -1;
                        //wait bottomSheet build
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          _scrollToIndex(tapIndexBs);
                        });
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
                                    controller: _bsController,
                                    itemCount: fibonacciListSheet.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            fibonacciList
                                                .add(fibonacciListSheet[index]);
                                            fibonacciList.sort((a, b) =>
                                                a.index.compareTo(b.index));
                                            tapIndexMain =
                                                fibonacciListSheet[index].index;
                                            fibonacciListSheet.removeAt(index);
                                            tapIndexBs = -1;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: ListTile(
                                          tileColor:
                                              fibonacciListSheet[index].index ==
                                                      tapIndexBs
                                                  ? Colors.red
                                                  : Colors.transparent,
                                          title: Text(
                                            'Number: ${fibonacciListSheet[index].number}',
                                          ),
                                          subtitle: Text(
                                              'Index : ${fibonacciListSheet[index].index}'),
                                          trailing: Icon(
                                              fibonacciListSheet[index].icon),
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
                          width: MediaQuery.of(context).size.width * 1,
                          child: ListTile(
                            tileColor:
                                fibonacciList[index].index == tapIndexMain
                                    ? Colors.blue
                                    : Colors.transparent,
                            title: Text(
                              'Number ${fibonacciList[index].number}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle:
                                Text('Index ${fibonacciList[index].index}'),
                            trailing: Icon(fibonacciList[index].icon),
                          ),
                        ),
                        // SizedBox(
                        //     width: MediaQuery.of(context).size.width * 0.2,
                        //     child: Icon(fibonacciList[index].icon))
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
