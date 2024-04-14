import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:chemcheck/model/list_category.dart';
import 'package:chemcheck/screen/question.dart';

final mukiUrl = dotenv.get('MUKI_URL');
final yuukiUrl = dotenv.get('YUUKI_URL');
final rironUrl = dotenv.get('RIRON_URL');
final koubunshiUrl = dotenv.get('KOUBUNSHI_URL');
final kisoUrl = dotenv.get('KISO_URL');

// カテゴリ一覧を取得して表示するs
class Inorganic extends StatefulWidget {
  final String field;
  const Inorganic({Key? key, required this.field}) : super(key: key);

  @override
  _InorganicState createState() => _InorganicState();
}

class _InorganicState extends State<Inorganic> {
  List<Category> categories = [];
  bool isLoading = true;

  // 分野によってURLを変える
  String get url {
    switch (widget.field) {
      case '無機化学':
        return mukiUrl;
      case '有機化学':
        return yuukiUrl;
      case '高分子化学':
        return koubunshiUrl;
      case '理論化学':
        return rironUrl;
      case '化学基礎':
        return kisoUrl;
      default:
        return kisoUrl;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  // カテゴリ一覧を取得
  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = jsonDecode(body)['categories'];
      final data =
          parsed.map<Category>((json) => Category.fromJson(json)).toList();
      setState(() {
        categories = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.field),
        ),
        child: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (categories.isEmpty && isLoading)
                const CupertinoActivityIndicator()
              else if (categories.isNotEmpty)
                CupertinoListSection(children: <Widget>[
                  for (var category in categories)
                    CupertinoListTile(
                      title: Text(category.name),
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    Question(link: category.url)));
                      },
                    ),
                ])
              else
                // ダイアログを出して戻るボタンを押すと前の画面に戻る
                CupertinoAlertDialog(
                  title: const Text('エラー'),
                  content: const Text('カテゴリ一覧を取得できませんでした'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      child: const Text('戻る'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
            ],
          ),
        )));
  }
}
