import 'package:flutter/material.dart';
import 'package:responsive_ui/ui/list_product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery -> hỗ trợ lấy thông tin liên quan kích thước, hướng device...
    final mq = MediaQuery.of(context);
    print('Width = ${mq.size.width}');
    print('Height = ${mq.size.height}');
    print('Aspect ratio = ${mq.size.aspectRatio}');
    print('Orientation = ${mq.orientation}');

    // Breakpoint
    final isWide = mq.size.width >= 600;

    // MediaQuery
    // return Scaffold(
    //   // body: mq.orientation == Orientation.landscape ? ListProduct(col: 4) : ListProduct(col: 2) // 1st
    //   body: isWide ? ListProduct(col: 4) : ListProduct(col: 2) // 2nd
    // );


    // LayoutBuilder
    // return Scaffold(
    //   body: LayoutBuilder(builder: (context, constraints) {
    //     print('LB: constraint maxWidth: ${constraints.maxWidth}');
    //
    //     if (constraints.maxWidth >= 600) {
    //       return ListProductHorizontal();
    //     } else {
    //       return ListProduct(col: 2);
    //     }
    //   }),
    // );

    // OrientationBuilder
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return ListProduct(col: 2);
        } else {
          return ListProductHorizontal();
        }
      }),
    );
  }
}
