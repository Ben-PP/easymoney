import 'package:flutter/material.dart';

import './dialog_components/dialog_titlebar.dart';

class ShowJpgDialog extends StatelessWidget {
  const ShowJpgDialog({
    super.key,
    required this.title,
    required this.image,
  });
  final String title;
  final Image image;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          insetPadding: const EdgeInsets.all(20),
          //backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitleBar(title: title),
              Padding(
                padding: const EdgeInsets.all(0),
                child: image,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
