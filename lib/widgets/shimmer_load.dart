import 'package:flutter/material.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    return FkContentBoxWidgets.body(context, 'home',
        itemList: [const ShimmerLoading()]);
  }
}
