import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class CustomDropDownBox extends StatefulWidget {
  const CustomDropDownBox({Key? key}) : super(key: key);

  @override
  State<CustomDropDownBox> createState() => _CustomDropDownBoxState();
}

class _CustomDropDownBoxState extends State<CustomDropDownBox> {
  String dropdownValue = '2021';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Year",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        horizontalSpaceRegular,
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          underline: const SizedBox(),
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: fkGreyText),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: <String>['2021', '2022']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
