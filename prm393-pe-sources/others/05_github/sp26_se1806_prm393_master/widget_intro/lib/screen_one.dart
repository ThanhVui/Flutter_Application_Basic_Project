// Tao 1 statefulwidget

import 'package:flutter/material.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  String _fieldOne = '';
  TextEditingController _fieldTwoController = TextEditingController();
  bool _checkboxVal = false;
  int _radioValue = 1;

  @override
  void dispose() {
    _fieldTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          // gom 1 scroll view
          spacing: 6,
          children: [
            Text('Widgets', style: TextStyle(color: Colors.red, fontSize: 36)),
            Divider(),
            Text('Text Inputs', style: TextStyle(fontSize: 20)),
            TextField(
              decoration: InputDecoration(
                labelText: 'Field 1',
                hintText: 'Input your text', // placeholder
              ),
              onChanged: (value) => setState(() {
                // setState re-render lai UI
                _fieldOne = value;
              }),
            ),
            Text('You entered: $_fieldOne'),
            TextField(
              decoration: InputDecoration(labelText: 'Field 2'),
              controller: _fieldTwoController,
              onChanged: (v) => setState(() {}),
            ),
            Text('You entered: ${_fieldTwoController.text}'),
            Divider(),
            Text('Checkboxes', style: TextStyle(fontSize: 20)),
            Row(
              children: [
                Text('Checkbox #1'),
                Checkbox(value: false, onChanged: (v) {}), // false -> uncheck
                Checkbox(value: true, onChanged: (v) {}), // true -> checked
                Checkbox(value: null, tristate: true, onChanged: (v) {}),
              ],
            ),
            Text('Checkbox #2'),
            ListTile(
              title: Text('Label'),
              leading: Checkbox(value: true, onChanged: (v) {}),
            ),
            CheckboxListTile(
              title: Text('Checkbox (recommended way)'),
              value: _checkboxVal,
              onChanged: (v) {
                setState(() {
                  _checkboxVal = v!;
                  print(v);
                });
              },
            ),
            Divider(),
            Text('Radio', style: TextStyle(fontSize: 20)),
            RadioGroup<int>(
              onChanged: (v) => {
                setState(() {
                  print(v);
                  _radioValue = v!;
                })
              },
              groupValue: _radioValue,
              child: Column(
                children: [
                  RadioListTile(value: 1, title: Text('Option 1')),
                  RadioListTile(value: 2, title: Text('Option 2')),
                  RadioListTile(value: 3, title: Text('Option 3')),
                ],
              ),
            ),
            Text('Radio chosen: $_radioValue'),
            // Datetime picker (Sử dụng kiểu dữ liệu liên quan đến ngày tháng)
            // Slider
            Slider(value: 0.5, onChanged: (v) => {}),
            // Switch
            SwitchListTile(value: true, onChanged: (v) {}, title: Text('Switch'),)
            // Dropdown

          ],
        ),
      ),
    );
  }
}
