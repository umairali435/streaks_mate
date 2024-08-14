import 'package:flutter/material.dart';
import 'package:streaksmate/utils/colors.dart';
import 'package:streaksmate/utils/constants.dart';
import 'package:streaksmate/widgets/streaks_container.dart';

class StreakDialog extends StatefulWidget {
  const StreakDialog({super.key, required this.onIconChange});

  final Function(int icon) onIconChange;

  @override
  State<StreakDialog> createState() => _StreakDialogState();
}

class _StreakDialogState extends State<StreakDialog> {
  List<Widget> getChildren(int st, int en, List<IconData> iconList) {
    List<Widget> children = [];
    for (int i = st; i < en; ++i) {
      children.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context, i);
            },
            child: StreakContainer(
              color: AppColors.primaryColor.withOpacity(0.2),
              onTap: () {
                Navigator.of(context).pop();
                widget.onIconChange(i);
              },
              child: Icon(
                iconList[i],
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ),
      );
    }
    return children;
  }

  List<TableRow> getTable(List<IconData> iconList) {
    List<TableRow> tableRow = [];
    tableRow.add(TableRow(children: getChildren(0, 4, iconList)));
    tableRow.add(TableRow(children: getChildren(4, 8, iconList)));
    tableRow.add(TableRow(children: getChildren(8, 12, iconList)));
    return tableRow;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16.0,
        ),
      ),
      backgroundColor: AppColors.redColor,
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Choose Icon',
              style: TextStyle(
                color: AppColors.secondaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: Table(
                children: getTable(AppConst.iconList),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
