import 'package:flutter/material.dart';
import './second_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
      children: [
        Text('最初のページ'),
        IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondPage()));
        }, icon: Icon(Icons.arrow_forward_ios))
      ],
    )));
  }
}
