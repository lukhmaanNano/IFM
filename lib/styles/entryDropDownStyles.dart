import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'CommonTextStyle.dart';
import 'common Color.dart';

Widget dropDownValuesStyle(BuildContext context, String? val, double width) {
  return SizedBox(
    width: width,
    child: Text(
      val ?? '',
      style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
    ),
  );
}

Widget hintStyle(String? val) {
  return Text(
    val!,
    style: const TextStyle(
        fontSize: 14, color: grey100, overflow: TextOverflow.ellipsis),
  );
}

Widget headerName(String? val) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Text(val!, style: inputHeader),
        const Text('*', style: TextStyle(color: red)),
      ],
    ),
  );
}

Widget headerNonMandatoryName(String? val) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Text(val!, style: inputHeader),
      ],
    ),
  );
}

ButtonStyleData buttonStyle = ButtonStyleData(
    decoration: dropDownDecoration,
    height: 40,
    width: 200,
    padding: const EdgeInsets.symmetric(horizontal: 8.0));

DropdownStyleData dropDownStyle = DropdownStyleData(
  maxHeight: 200,
  decoration: dropDown,
);

MenuItemStyleData menuStyleData = const MenuItemStyleData(
  height: 30,
);

const dropDownSearchPadding = EdgeInsets.only(
  top: 8,
  bottom: 4,
  right: 8,
  left: 8,
);
