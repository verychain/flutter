import 'package:flutter/material.dart';
import 'package:demo_flutter/model/type.dart';

class TradeSortDropdown extends StatelessWidget {
  final TradeSortType sortType;
  final ValueChanged<TradeSortType?> onChanged;

  const TradeSortDropdown({
    super.key,
    required this.sortType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      child: SizedBox(
        width: 80,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<TradeSortType>(
            value: sortType,
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            dropdownColor: Colors.white,
            icon: Icon(
              Icons.expand_more,
              color: Colors.grey.shade600,
              size: 18.0,
            ),
            items: [
              DropdownMenuItem(
                value: TradeSortType.price,
                child: Text('단위가격순', style: TextStyle(fontSize: 12.0)),
              ),
              DropdownMenuItem(
                value: TradeSortType.ranking,
                child: Text('등급순', style: TextStyle(fontSize: 12.0)),
              ),
              DropdownMenuItem(
                value: TradeSortType.totalAmount,
                child: Text('총액순', style: TextStyle(fontSize: 12.0)),
              ),
            ],
            onChanged: onChanged,
            style: TextStyle(fontSize: 12.0, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
