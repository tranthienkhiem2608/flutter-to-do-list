import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskDialog extends StatefulWidget {
  final Function _addTask;

  AddTaskDialog(this._addTask);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _detailsController = TextEditingController();
  DateTime? _selectedDate;
  void _submitForm() {
    final todoDesc = _detailsController.text;
    if (todoDesc.isEmpty) {
      return;
    } else {
      widget._addTask(todoDesc, _selectedDate);
      Navigator.of(context).pop();
    }
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Provide details for your todo item.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: _detailsController,
                    decoration: InputDecoration(
                      labelText: 'Todo Details',
                    ),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _selectedDate == null
                              ? 'No Date Chosen'
                              : DateFormat.yMd().format(_selectedDate!),
                          style: TextStyle(fontSize: 20),
                        ),
                        TextButton(
                          onPressed: _showDatePicker,
                          child: AutoSizeText(
                            'Choose Date',
                            style: TextStyle(fontSize: 20),
                            maxLines: 1,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Color.fromARGB(255, 175, 15, 49)
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 19, 21, 44)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Add Todo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
