import 'package:flutter/cupertino.dart';
import 'package:chemcheck/screen/licenses.dart';
import 'package:chemcheck/screen/field.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Home'),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(height: 200),
                  child: const Image(image: AssetImage('assets/icon.png')),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('有機化学'),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (context) =>
                                const Inorganic(field: '有機化学'),
                          ),
                        );
                      },
                    ),
                    CupertinoButton(
                      child: const Text('無機化学'),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (context) =>
                                const Inorganic(field: '無機化学'),
                          ),
                        );
                      },
                    ),
                    CupertinoButton(
                      child: const Text('高分子化学'),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (context) =>
                                const Inorganic(field: '高分子化学'),
                          ),
                        );
                      },
                    ),
                    CupertinoButton(
                      child: const Text('理論化学'),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (context) =>
                                const Inorganic(field: '理論化学'),
                          ),
                        );
                      },
                    ),
                    CupertinoButton(
                      child: const Text('化学基礎'),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (context) =>
                                const Inorganic(field: '化学基礎'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: CupertinoButton(
                    child: const Text('ライセンス'),
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute<void>(
                          builder: (context) => const Licenses(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
