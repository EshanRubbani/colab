import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/chat/bubble.dart';
import 'package:collab/extras/utils/Helper/chat/chat_service.dart';
import 'package:collab/extras/utils/Helper/chat/profileavator.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/pages/chatpage/voting_screen.dart';
import 'package:collab/pages/chatpage/winner_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';

class GroupChatpage extends StatefulWidget {
  final String chatID;
  final String chatName;
  final bool isGroupChat;

  GroupChatpage({
    super.key,
    required this.chatID,
    required this.chatName,
    this.isGroupChat = true,
  });

  @override
  State<GroupChatpage> createState() => _GroupChatpageState();
}

class _GroupChatpageState extends State<GroupChatpage> {
  DateTime? countdownEndTime;
  DateTime? votingStartTime;
  late Timer _timer;
  Duration remainingTime = Duration();
  final Map<String, String?> _profileImageCache = {};
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final FirestoreService _firestore = FirestoreService();
  FocusNode myfocusnode = FocusNode();

  @override
  void initState() {
    super.initState();
    fetchTimes();
    myfocusnode.addListener(() {
      if (myfocusnode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500), scrolldown);
      }
    });
    Future.delayed(const Duration(milliseconds: 500), scrolldown);
  }

  @override
  void dispose() {
    myfocusnode.dispose();
    _messageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void fetchTimes() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.chatID)
        .get();
    Timestamp endTimeTimestamp = snapshot['votingEndTime'];
    Timestamp startTimeTimestamp = snapshot['votingStartTime'];
    setState(() {
      countdownEndTime = endTimeTimestamp.toDate();
      votingStartTime = startTimeTimestamp.toDate();
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdownEndTime != null) {
        setState(() {
          remainingTime = countdownEndTime!.difference(DateTime.now());
        });
      }
    });
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
          widget.chatID, _messageController.text, true);
      _messageController.clear();
      scrolldown();
    }
  }

  void navigateToVotingScreen() async {
    print('inside navigate to voting scren');
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('groups').doc(widget.chatID).get();
    List<dynamic> members = snapshot['members'];
    List<String> candidates = members.cast<String>();

    Get.to(VotingScreen(groupName: widget.chatName, candidates: candidates, groupId: widget.chatID));
  }
  Widget buildCountdown() {
    return Center(
      child: countdownEndTime == null
          ? CircularProgressIndicator()
          : GestureDetector(
            onTap: () {
             navigateToVotingScreen();
            },
            child: Column(
              children: [
                TimerCountdown(
                    format: CountDownTimerFormat.daysHoursMinutesSeconds,
                    endTime: countdownEndTime!,
                    onEnd: () {
                      AlertDialog(
                      content: const Text("Voting has been Ended. Click to see the results"),
                      actions: [
                        TextButton(
                onPressed: () {
                //  Get.offAll(ProfilePage());
                },
                child: const Text('results'),
                        ),
                      ],
                    );
                    },
                    timeTextStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    Get.to(WinnerScreen(groupId: widget.chatID,));
                  }, child: Text("Results"))
              ],
            ),
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

  Widget _buildMessageItem(
      DocumentSnapshot doc, DocumentSnapshot? previousDoc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Map<String, dynamic>? prevData =
        previousDoc?.data() as Map<String, dynamic>?;

    bool isCurrentUser = data["senderID"] == _firestore.user!.uid;
    bool showAvatar =
        previousDoc == null || prevData?["senderID"] != data["senderID"];
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    final user = FirebaseAuth.instance.currentUser!;
    final userIdentifier = user.email ?? user.phoneNumber!;
    final senderEmail = data["senderEmail"];

    Future<String?> _getProfileImage(String userId) async {
      if (_profileImageCache.containsKey(userId)) {
        return _profileImageCache[userId];
      } else {
        final profileImageUrl = await _firestore.getUserProfileImage(userId);
        setState(() {
          _profileImageCache[userId] = profileImageUrl;
        });
        return profileImageUrl;
      }
    }

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            FutureBuilder<String?>(
              future: _getProfileImage(
                  isCurrentUser ? userIdentifier : senderEmail),
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
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.attach_file,
                  color: KAppColors.kPrimary, size: 28)),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey[300],
              ),
              child: TextField(
                focusNode: myfocusnode,
                onEditingComplete: sendMessage,
                controller: _messageController,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText: "Write Your Message",
                  suffixIcon: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send, color: KAppColors.kPrimary)),
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
          IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.camera,
                  color: KAppColors.kPrimary, size: 28)),
          IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.mic,
                  color: KAppColors.kPrimary, size: 28)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasVotingStarted =
        votingStartTime != null && DateTime.now().isAfter(votingStartTime!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        centerTitle: true,
        title: Text(widget.chatName, style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          if (hasVotingStarted)
            Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildCountdown(),
              ),
            ),
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }
}
