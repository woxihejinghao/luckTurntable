import 'package:flutter/material.dart';

typedef InputTextCallback = void Function(String? result);

class InputBottomSheet extends StatelessWidget {
  final String? text;
  final int? maxLength;
  final InputTextCallback? textCallback;
  const InputBottomSheet(
      {Key? key, this.text, this.maxLength, this.textCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController(text: text);
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 50),
      child: Container(
        height: 100,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: TextField(
              maxLength: maxLength,
              controller: editingController,
              autofocus: true,
              maxLines: 1,
              minLines: 1,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(hintText: "请输入内容"),
            )),
            TextButton(
              child: const Text(
                "确定",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                if (textCallback != null) {
                  textCallback!(editingController.text);
                }
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
