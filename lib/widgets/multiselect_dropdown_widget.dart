import 'package:flutter/material.dart';

class MultiselectDropdown<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final String Function(T) itemAsString;
  final void Function(List<T>) onChanged;
  final String hintText;

  const MultiselectDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.itemAsString,
    required this.onChanged,
    this.hintText = "Select Items",
  });

  @override
  _MultiselectDropdownState<T> createState() => _MultiselectDropdownState<T>();
}

class _MultiselectDropdownState<T> extends State<MultiselectDropdown<T>> {
  late List<T> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  void _openMultiSelectDialog() async {
    final selected = await showDialog<List<T>>(
      context: context,
      builder: (context) {
        final tempSelected = List<T>.from(_selectedItems);
        return AlertDialog(
          title: Text(widget.hintText),
          content: SingleChildScrollView(
            child: Column(
              children: widget.items.map((item) {
                final isChecked = tempSelected.contains(item);
                return CheckboxListTile(
                  value: isChecked,
                  title: Text(widget.itemAsString(item)),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        tempSelected.add(item);
                      } else {
                        tempSelected.remove(item);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, _selectedItems),
              child: Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, tempSelected),
              child: Text("OK"),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedItems = selected;
        widget.onChanged(_selectedItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMultiSelectDialog,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _selectedItems.isEmpty
              ? widget.hintText
              : _selectedItems.map(widget.itemAsString).join(', '),
        ),
      ),
    );
  }
}
