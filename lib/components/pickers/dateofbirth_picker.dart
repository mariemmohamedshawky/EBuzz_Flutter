import 'package:ebuzz/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:intl/intl.dart';

class DateOfBirthPicker extends StatefulWidget {
  final void Function(DateTime date) dateTimePickFn;

  DateOfBirthPicker(this.dateTimePickFn);
  @override
  _DateOfBirthPickerState createState() => _DateOfBirthPickerState();
}

class _DateOfBirthPickerState extends State<DateOfBirthPicker> {
  DateTime _selectedDate;

  void _presentDatePicker() {
    showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1910),
      lastDate: DateTime.now(),
      theme: ThemeData(
        primaryColor: HexColor("#970C0F"),
        accentColor: HexColor("#970C0F"),
        primarySwatch: grey,
      ),
    ).then((pickedDate) {
      setState(() {
        _selectedDate = pickedDate;
        widget.dateTimePickFn(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateformat = new DateFormat('yyyy-MM-dd');
    return Container(
      margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        children: [
          TextField(
            readOnly: true,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#970C0F")),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#970C0F")),
                ),
                labelText: 'Date of birth',
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: grey,
                ),
                hintText: _selectedDate == null
                    ? 'Not Date Chosen!'
                    : 'Date: ${dateformat.format(_selectedDate)}',
                hintStyle: TextStyle(
                  fontSize: 10,
                  color: primary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: primary,
                  onPressed: _presentDatePicker,
                )),
            // keyboardType: TextInputType.datetime,
          ),
        ],
      ),
    );
  }
}
