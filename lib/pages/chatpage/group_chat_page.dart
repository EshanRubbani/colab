import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/chat/bubble.dart';
import 'package:collab/extras/utils/Helper/chat/chat_service.dart';
import 'package:collab/extras/utils/Helper/chat/profileavator.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupChatpage extends StatefulWidget {
  final String chatID;
  final String chatName;
  final bool isGroupChat;

  GroupChatpage({
    super.key,
    required this.chatID,
    required this.chatName,
    this.isGroupChat = false,
  });

  @override
  State<GroupChatpage> createState() => _GroupChatpageState();
}

class _GroupChatpageState extends State<GroupChatpage> {
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
        widget.chatID,
        _messageController.text,
        isGroup: widget.isGroupChat,
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
        title: Text(widget.chatName, style: TextStyle(color: Colors.black)),
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
      stream: widget.isGroupChat
          ? _chatService.getGroupMessages(widget.chatID)
          : _chatService.getMessages(senderId, widget.chatID),
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
                  ? _firestore.getUserProfileImage(_firestore.user!.email.toString())
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
