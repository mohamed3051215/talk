import '../../../core/constants/colors.dart';
import '../../../core/constants/country_data.dart';
import '../../../core/constants/fonts.dart';
import '../general%20widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({Key? key, required this.controller, this.controllerx})
      : super(key: key);
  final TextEditingController controller;
  final controllerx;
  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late List<Map<String, String>> countryData2;
  String text = "+20";
  List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];
  @override
  void initState() {
    super.initState();
    handleCountryData();
  }

  handleCountryData() {
    countryData2 = countryData;
    setState(() {
      items = countryData2.map<DropdownMenuItem<String>>((e) {
        return DropdownMenuItem(
          child: CustomText(
            e["code"]!,
            color: lightPurple,
          ),
          value: e["dial_code"],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            child: DropdownButton<String>(
              onChanged: (value) {
                setState(() {
                  text = value!;
                });
                String dialCode = countryData2.where((element) {
                  return element["code"] == value;
                }).toList()[0]["dial_code"]!;
                widget.controllerx.dialCode = dialCode;
              },
              value: text,
              isExpanded: true,
              items: items,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            height: 60,
            width: Get.width - 60 - 68,
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  fillColor: textFieldColor,
                  filled: true,
                  hintText: "Phone",
                  hintStyle: TextStyle(
                      color: lightPurple.withOpacity(.5),
                      fontSize: 18,
                      fontFamily: rRegular),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
