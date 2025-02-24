import 'package:flutter/material.dart';

final GlobalKey<State> alertKey = GlobalKey<State>();

BuildContext? dContext;

showAlert(String title, String message, BuildContext context, List<Widget>? actions) async {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }

  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      dContext = dialogContext;
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
                Colors.white,
                Color(0xF3E0F5D5),
              ],
              stops: [0, 0.1, 0.9, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontFamily: 'SourceSans3',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                message,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontFamily: 'SourceSans3',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16.0),
              if (actions != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions.map((button) {
                    if (button is TextButton) {
                      return TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext); // Always pop with dialogContext
                          if (button.onPressed != null) {
                            button.onPressed!(); // Call original action if needed
                          }
                        },
                        child: button.child!,
                      );
                    }
                    return button;
                  }).toList(),
                ),
            ],
          ),
        ),
      );
    },
  );
}
