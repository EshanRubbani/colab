import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/utils/Helper/chat/bubble.dart';
import 'package:Collab/extras/utils/Helper/chat/chat_service.dart';
import 'package:Collab/extras/utils/Helper/chat/profileavator.dart';
import 'package:Collab/extras/utils/Helper/firestore.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Chatpage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  Chatpage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final FirestoreService _firestore = FirestoreService();
  FocusNode myfocusnode = FocusNode();

  @override
  void initState() {
    super.initState();
    myfocusnode.addListener(() {
      if (myfocusnode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500), () => scrolldown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrolldown());
  }

  @override
  void dispose() {
    myfocusnode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrolldown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverID,
        _messageController.text,
        false
      );
    }
    _messageController.clear();
    scrolldown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        centerTitle: true,
        title: Text(widget.receiverEmail, style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

Widget _buildMessageList() {
  String senderId = FirebaseAuth.instance.currentUser!.uid;
  return StreamBuilder(
    stream: _chatService.getMessages(senderId, widget.receiverID),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Text("Error");
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        scrolldown();
        return const CircularProgressIndicator(
          color: KAppColors.kPrimary,
        );
      }

      // Attach the ScrollController here
      return ListView.builder(
        controller: _scrollController, 
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          return _buildMessageItem(
            snapshot.data!.docs[index],
            index > 0 ? snapshot.data!.docs[index - 1] : null,
          );
        },
      );
    },
  );
}


  Widget _buildMessageItem(DocumentSnapshot doc, DocumentSnapshot? previousDoc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Map<String, dynamic>? prevData = previousDoc?.data() as Map<String, dynamic>?;
    final user1 = FirebaseAuth.instance.currentUser!;
    final userIdentifier = user1.email ?? user1.phoneNumber!;
    bool isCurrentUser = data["senderID"] == _firestore.user!.uid;
    bool showAvatar = previousDoc == null || prevData?["senderID"] != data["senderID"];
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            FutureBuilder<String?>(
              future: isCurrentUser
                  ? _firestore.getUserProfileImage(userIdentifier)
                  : _firestore.getUserProfileImage(data["senderEmail"]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else {
                  return Profileavator(
                    profileUrl: snapshot.data ?? '',
                  );
                }
              },
            ),
          ChatBubble(
            isCurrentUser: isCurrentUser,
            message: data["message"],
            timestamp: data["timestamp"],
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 15, top: 20),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.attach_file, color: KAppColors.kPrimary, size: 28)),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey[300],
              ),
              child: TextField(
                focusNode: myfocusnode,
                onEditingComplete: () {
                  sendMessage();
                },
                controller: _messageController,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText: "Write Your Message",
                  suffixIcon: IconButton(onPressed: sendMessage, icon: const Icon(Icons.send, color: KAppColors.kPrimary)),
                  hintFadeDuration: const Duration(seconds: 1),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 15, top: 12),
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(147, 158, 158, 158),
                  ),
                ),
                obscureText: false,
              ),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.camera, color: KAppColors.kPrimary, size: 28)),
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.mic, color: KAppColors.kPrimary, size: 28)),
        ],
      ),
    );
  }
}
