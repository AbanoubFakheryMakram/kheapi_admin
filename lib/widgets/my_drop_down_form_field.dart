import 'package:flutter/material.dart';

class MyDropDownFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  final bool filled;
  final TextStyle titleStyle;
  final TextStyle itemStyle;
  final Icon icon;
  final InputBorder border;

  MyDropDownFormField({
    this.titleStyle = const TextStyle(
      color: Colors.white,
      fontSize: 22,
    ),
    this.icon,
    FormFieldSetter<dynamic> onSaved,
    this.border,
    FormFieldValidator<dynamic> validator,
    bool autovalidate = false,
    this.itemStyle = const TextStyle(
      color: Colors.black,
    ),
    this.titleText = 'Title',
    this.hintText = 'Select one option',
    this.required = false,
    this.errorText = 'Please select one option',
    this.value,
    this.dataSource,
    this.textField,
    this.valueField,
    this.onChanged,
    this.filled = true,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          autovalidate: autovalidate,
          initialValue: value == '' ? null : value,
          builder: (FormFieldState<dynamic> state) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InputDecorator(
                    decoration: InputDecoration(
                      focusedBorder: border,
                      enabledBorder: border,
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                      labelText: titleText,
                      labelStyle: titleStyle,
                      alignLabelWithHint: true,
                      filled: filled,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        icon: icon,
                        hint: Text(
                          hintText,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        value: value == '' ? null : value,
                        onChanged: (dynamic newValue) {
                          state.didChange(newValue);
                          onChanged(newValue);
                        },
                        items: dataSource.map((item) {
                          return DropdownMenuItem<dynamic>(
                            value: item[valueField],
                            child: Text(
                              item[textField],
                              textAlign: TextAlign.right,
                              style: itemStyle,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: state.hasError ? 5.0 : 0.0,
                  ),
                  Text(
                    state.hasError ? state.errorText : '',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.redAccent.shade700,
                      fontSize: state.hasError ? 12.0 : 0.0,
                    ),
                  ),
                ],
              ),
            );
          },
        );
}
