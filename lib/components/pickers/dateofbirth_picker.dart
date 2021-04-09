import 'package:flutter/material.dart';

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
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1910),
      lastDate: DateTime.now(),
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
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_selectedDate == null
              ? 'Not Date Chosen!'
              : 'Picked Date: ${dateformat.format(_selectedDate)}'),
          FlatButton(
            child: Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _presentDatePicker,
            textColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
