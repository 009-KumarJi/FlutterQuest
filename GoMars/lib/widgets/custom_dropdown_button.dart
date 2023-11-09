import 'package:flutter/material.dart';

class CustomDropDownButtonClass extends StatelessWidget {
  List<String> values;
  double width;

  CustomDropDownButtonClass({required this.values, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.8,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(53, 53, 53, 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        dropdownColor: const Color.fromRGBO(53, 53, 53, 1.0),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17.5,
          fontWeight: FontWeight.w500,
        ),
        underline: Container(),
        value: values.first,
        onChanged: (_) {},
        items: values.map(
              (e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          },
        ).toList(),
      ),
    );
  }
}
