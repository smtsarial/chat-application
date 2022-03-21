import 'package:firebasedeneme/theme.dart';
import 'package:flutter/material.dart';

class asd extends StatelessWidget {
  const asd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const MyRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: Row(
          children: [
            _customRadioButton,
            if (title != null) title,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? PrimaryColor : null,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? PrimaryColor : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Text(
        leading,
        style: TextStyle(
          fontSize: 11,
          color: isSelected ? Colors.white : Colors.grey[600]!,
        ),
      ),
    );
  }
}
