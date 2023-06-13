import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  const MessageTile(
      {super.key,
      required this.message,
      required this.sender,
      required this.sentByMe});
  final String message;
  final String sender;
  final bool sentByMe;
  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 10,
          right: widget.sentByMe ? 10 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        // margin: widget.sentByMe
        //     ? const EdgeInsets.only(left: 30)
        //     : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 6, bottom: 6, left: 15, right: 15),
        decoration: BoxDecoration(
            borderRadius: widget.sentByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color: widget.sentByMe
                ? Theme.of(context).primaryColor
                : Colors.grey[700]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   widget.sender,
            //   textAlign: TextAlign.start,
            //   style: TextStyle(
            //       fontSize: 13,
            //       // fontWeight: FontWeight.bold,
            //       color: widget.sentByMe
            //           ? Colors.black
            //           : Theme.of(context).primaryColor,
            //       letterSpacing: -0.5),
            // ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.message,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 18, color: Colors.white))
          ],
        ),
      ),
    );
  }
}