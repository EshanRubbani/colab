import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Assuming correct path

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final Timestamp timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = formatTimestamp(timestamp);

    return Align( 
      // Use Align for proper bubble positioning
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8,right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //display profile dp avatar

            //displat chat bubble
            Container(
              padding: const EdgeInsets.all(12), 
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10), 
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75, 
              ),
              decoration: BoxDecoration(
                color: isCurrentUser ? KAppColors.kPrimary : KAppColors.kDarkGrey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                children: [
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 6), // Space between message and timestamp
                  
                ],
              ),
            ),
            //display time
            Text(
                formattedTime,
                style: const TextStyle(
                  color: Colors.grey, // Subtler timestamp color
                  fontSize: 8,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String formatTimestamp(Timestamp timestamp) {
  final dateTime = timestamp.toDate(); // Directly get DateTime from Timestamp

  return DateFormat('h:mm a').format(dateTime); // Simplified formatting
}
