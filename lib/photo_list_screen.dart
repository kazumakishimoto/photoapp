import 'package:flutter/material.dart';
import 'package:photoapp/photo_view_screen.dart';

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  late int _currentIndex;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    // PageViewで表示されているWidgetの番号を持っておく
    _currentIndex = 0;
    // PageViewの表示を切り替えるのに使う
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo App'),
        actions: [
          // ログアウト用ボタン
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        // 表示が切り替わったとき
        onPageChanged: (int index) => _onPageChanged(index),
        children: [
          PhotoGridView(
            // コールバックを設定しタップした画像のURLを受け取る
            onTap: (imageURL) => _onTapPhoto(imageURL),
          ),
          PhotoGridView(
            // コールバックを設定しタップした画像のURLを受け取る
            onTap: (imageURL) => _onTapPhoto(imageURL),
          ),
        ],
      ),
      // 画像追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: Icon(Icons.add),
      ),
      // 画面下部のボタン部分
      bottomNavigationBar: BottomNavigationBar(
        // BottomNavigationBarItemがタップされたときの処理
        //   0: フォト
        //   1: お気に入り
        onTap: (int index) => _onTapBottomNavigationItem(index),
        // 現在表示されているBottomNavigationBarItemの番号
        //   0: フォト
        //   1: お気に入り
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'フォト',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'お気に入り',
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    // PageViewで表示されているWidgetの番号を更新
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTapBottomNavigationItem(int index) {
    // PageViewで表示するWidgetを切り替える
    _controller.animateToPage(
      // 表示するWidgetの番号
      //   0: 全ての画像
      //   1: お気に入り登録した画像
      index,
      // 表示を切り替える時にかかる時間（300ミリ秒）
      duration: Duration(milliseconds: 300),
      // アニメーションの動き方
      //   この値を変えることで、アニメーションの動きを変えることができる
      //   https://api.flutter.dev/flutter/animation/Curves-class.html
      curve: Curves.easeIn,
    );
    // PageViewで表示されているWidgetの番号を更新
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTapPhoto(String imageURL) {
    // 最初に表示する画像のURLを指定して、画像詳細画面に切り替える
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoViewScreen(imageURL: imageURL),
      ),
    );
  }
}

class PhotoGridView extends StatelessWidget {
  const PhotoGridView({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  // onTapプロパティを追加
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    // ダミー画像一覧
    final List<String> imageList = [
      'https://placehold.jp/400x300.png?text=0',
      'https://placehold.jp/400x300.png?text=1',
      'https://placehold.jp/400x300.png?text=2',
      'https://placehold.jp/400x300.png?text=3',
      'https://placehold.jp/400x300.png?text=4',
      'https://placehold.jp/400x300.png?text=5',
    ];

    // GridViewを使いタイル状にWidgetを表示する
    return GridView.count(
      // 1行あたりに表示するWidgetの数
      crossAxisCount: 2,
      // Widget間のスペース（上下）
      mainAxisSpacing: 8,
      // Widget間のスペース（左右）
      crossAxisSpacing: 8,
      // 全体の余白
      padding: const EdgeInsets.all(8),
      // 画像一覧
      children: imageList.map((String imageURL) {
        // Stackを使いWidgetを前後に重ねる
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              // Widgetをタップ可能にする
              child: InkWell(
                // タップしたらコールバックを実行する
                onTap: () => onTap(imageURL),
                child: Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 画像の上にお気に入りアイコンを重ねて表示
            //   Alignment.topRightを指定し右上部分にアイコンを表示
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => {},
                color: Colors.white,
                icon: Icon(Icons.favorite_border),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}