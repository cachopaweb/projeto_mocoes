// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Datepicker extends StatefulWidget {
  final void Function(String)? onChanged;

  const Datepicker({
    super.key,
    required this.onChanged,
  });

  @override
  State<Datepicker> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<Datepicker> {
  DateTime? selectedDate;
  final dateFmt = DateFormat('dd/MM/yyyy');

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
              hintText: selectedDate != null
                  ? dateFmt.format(DateTime.parse(
                      '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'))
                  : 'No date selected',
              border: const OutlineInputBorder()),
          onChanged: widget.onChanged,
          enabled: false,
        ),
        OutlinedButton(
            onPressed: _selectDate, child: const Text('Data do Status')),
      ],
    );
  }
}
