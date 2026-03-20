import 'package:flutter/material.dart';
import 'package:responsive_ui/ui/side_menu.dart';

class ListProduct extends StatelessWidget {
  const ListProduct({super.key, required this.col});

  final int col;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: SideMenu(),
      body: GridView.count(
        // Classwork: Dựa trên kích thước màn hình (hoặc dọc/ngang)
        // Điều chỉnh spacing cho phù hợp: ngang=20, dọc=10
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: col,
        children: List.generate(12, (i) {
          return Card(child: Text('Product ${i + 1}'));
        }),
      ),
    );
  }
}

// 1 hướng tiếp cận để vấn đề --> lưu ý đang bị duplicate code
class ListProductHorizontal extends StatelessWidget {
  const ListProductHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home'),
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // ),
      body: Row(
        children: [
          // Menu
          SizedBox(width: 250, child: SideMenu()),
          VerticalDivider(width: 1),
          // Grid
          Expanded(
            child: GridView.count(
              // Classwork: Dựa trên kích thước màn hình (hoặc dọc/ngang)
              // Điều chỉnh spacing cho phù hợp: ngang=20, dọc=10
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 4,
              children: List.generate(12, (i) {
                return Card(child: Text('Product ${i + 1}'));
              }),
            ),
          ),
        ],
      ),
    );
  }
}
