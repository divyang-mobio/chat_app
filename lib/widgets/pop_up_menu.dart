import 'package:flutter/material.dart';

import '../resources/resource.dart';

PopupMenuButton popupMenuButton() {
  return PopupMenuButton(
    itemBuilder: (context) => ListResources()
        .getPopUpData(context)
        .map(
          (e) => PopupMenuItem(
            onTap: e.onPressed,
            child: Row(children: [
              Icon(e.iconData, color: ColorResources().popUpMenuIconColor),
              const SizedBox(width: 10),
              Text(e.title)
            ]),
          ),
        )
        .toList(),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    offset: const Offset(-15, 15),
  );
}
