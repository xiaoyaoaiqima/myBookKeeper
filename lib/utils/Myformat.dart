import 'package:flutter/material.dart';

import '../db/AccountBean.dart';

String formatDate(DateTime date) {
  return date.day.toString().padLeft(2, '0');
}

Widget buildResult(BuildContext context,AccountBean account) {
  return Row(
    children: [
      Image.asset(account.sImageId),
      const SizedBox(
        width: 5,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            account.typeName,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            account.note,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
      const Spacer(),
      Text(
        '￥${account.money}',
        style: TextStyle(
          color: (account.kind == 0) ? Colors.red : Colors.green,
        ),
      ),
    ],
  );
}