import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {
  final double size;

  LoadingComponent({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(size),
          child: SizedBox(
            child: CircularProgressIndicator(),
            height: size,
            width: size
          )
        )
      ]
    );
  }
}