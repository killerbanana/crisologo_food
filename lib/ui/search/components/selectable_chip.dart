import 'package:flutter/material.dart';

class SelectableChip extends StatefulWidget {
  final String label;
  final ValueChanged<bool> onSelected;

  SelectableChip({
    required this.label,
    required this.onSelected,
  });

  @override
  _SelectableChipState createState() => _SelectableChipState();
}

class _SelectableChipState extends State<SelectableChip> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.label),
      selected: _isSelected,
      onSelected: (bool isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
        widget.onSelected(_isSelected);
      },
      selectedColor: Colors.indigoAccent,
      backgroundColor: Colors.grey[300],
      labelStyle: TextStyle(
        color: _isSelected ? Colors.white : Colors.black,
        fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
