import '../../theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  // const PrimaryButton({Key? key}) : super(key: key);
  final String buttonText;
  PrimaryButton({required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.08,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: kPrimaryColor),
      child: Text(
        buttonText,
        style: textButton.copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
