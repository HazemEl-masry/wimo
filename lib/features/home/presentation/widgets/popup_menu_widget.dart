import 'package:flutter/material.dart';

class PopupMenuWidget extends StatelessWidget {
  const PopupMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Row(
              children: [
                const Icon(Icons.settings),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                const Text("Settings"),
              ],
            ),
          ),
        ];
      },
    );
  }
}
