// About app widget class

import 'package:deixa/utils/call_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deixa/presentation/shared_widgets/trns_text.dart';

class AboutTile extends StatelessWidget {
  const AboutTile({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          CallFunctions.launchUrlFxn(url);
        } catch (e) {
          print(e);
        }
      },
      child: ListTile(
        title: TrnsText(title: title),
        trailing: Icon(
          CupertinoIcons.forward,
          size: 15,
        ),
      ),
    );
  }
}
