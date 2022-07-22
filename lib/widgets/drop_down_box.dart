import 'package:flutter/material.dart';
import 'package:fuko_app/core/years.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class CustomDropDownBox extends StatefulWidget {
  const CustomDropDownBox({Key? key}) : super(key: key);

  @override
  State<CustomDropDownBox> createState() => _CustomDropDownBoxState();
}

class _CustomDropDownBoxState extends State<CustomDropDownBox> {
  String dropdownValue = currentYear;

  late Future<GetYears> retrieveYears;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveYears = fetchYears();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: retrieveYears,
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    "Year",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  horizontalSpaceRegular,
                  DropdownButton<dynamic>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    underline: const SizedBox(),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: fkGreyText),
                    onChanged: (dynamic? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    // ignore: prefer_const_literals_to_create_immutables
                    items: snapshot.data!.years
                        .map<DropdownMenuItem<dynamic>>((dynamic value) {
                      return DropdownMenuItem<dynamic>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Expanded(
                // padding: const EdgeInsets.all(20.0),
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                    child: Text(
                  snapshot.error != null
                      ? "Failed to load data"
                      : "Data not available...",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: fkGreyText),
                )),
                Container()
              ],
            ));
            ;
          }
          return Container(
              padding: const EdgeInsets.all(20.0),
              child: const Center(
                  child: Text(
                "Loading Amount...",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: fkGreyText),
              )));
        });
  }
}
