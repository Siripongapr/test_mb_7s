import 'package:flutter/material.dart';
import 'package:test_mb_7s/controllers/fibonacci_controller.dart';
import 'package:test_mb_7s/model/fibonacci.dart';

class FibonacciPage extends StatefulWidget {
  const FibonacciPage({super.key, required this.title});

  final String title;

  @override
  State<FibonacciPage> createState() => _FibonacciPageState();
}

class _FibonacciPageState extends State<FibonacciPage> {
  FibonacciController fiboController = FibonacciController();
  List<Fibonacci> fibonacciList = [];
  List<Fibonacci> fibonacciListSheet = [];
  int tapIndexMain = -1;
  int tapIndexBs = -1;

  late ScrollController _controller;
  late ScrollController _bsController;

  void _scrollToIndexMain(int index) {
    _controller.animateTo(
      index * 56,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToIndexBs(int index) {
    _bsController.animateTo(
      index * 56,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print("reach the bottom");
        fiboController.generateFibonacci(40, fibonacciList);
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
    fiboController.generateFibonacci(40, fibonacciList);
    _controller = ScrollController();
    _bsController = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                        final tappedItemType = fibonacciList[index].icon;
                        setState(() {
                          fibonacciListSheet.add(fibonacciList[index]);
                          fibonacciListSheet
                              .sort((a, b) => a.index.compareTo(b.index));
                          tapIndexBs = fibonacciList[index].index;
                          fibonacciList.removeAt(index);
                          tapIndexMain = -1;
                          //wait bottomSheet build
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollToIndexBs(tapIndexBs);
                          });
                        });
                        final filteredList = fibonacciListSheet
                            .where((item) => item.icon == tappedItemType)
                            .toList();
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: ListView.builder(
                                      controller: _bsController,
                                      itemCount: filteredList.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              fibonacciList
                                                  .add(filteredList[index]);
                                              fibonacciList.sort((a, b) =>
                                                  a.index.compareTo(b.index));
                                              tapIndexMain =
                                                  filteredList[index].index;
                                              fibonacciListSheet
                                                  .remove(filteredList[index]);
                                              tapIndexBs = -1;
                                              _scrollToIndexMain(tapIndexMain);
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: ListTile(
                                            tileColor:
                                                filteredList[index].index ==
                                                        tapIndexBs
                                                    ? Colors.green
                                                    : Colors.transparent,
                                            title: Text(
                                              'Number: ${filteredList[index].number}',
                                            ),
                                            subtitle: Text(
                                                'Index : ${filteredList[index].index}'),
                                            trailing:
                                                Icon(filteredList[index].icon),
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
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
