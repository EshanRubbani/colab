import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/chat/bubble.dart';
import 'package:collab/extras/utils/Helper/chat/chat_service.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Chatpage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
 Chatpage({ super.key, required this.receiverEmail, required this.receiverID });

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  //chat and auth servoces
  final ChatService _chatService = ChatService();
  final FirestoreService _firestore = FirestoreService();


  //focus node for textfieldfocus
  FocusNode myfocusnode = FocusNode();

  @override
  void initState() {
    super.initState();
    //add listner to focus node
    myfocusnode.addListener((){
      if(myfocusnode.hasFocus){
        //cause a delay in opening keyboard and scrool down
        Future.delayed(Duration(milliseconds: 500),
        
        () => scrolldown() );
      }
    });


    Future.delayed(const  Duration(milliseconds: 500),
    () => scrolldown(),
    );
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
      curve: Curves.fastOutSlowIn
      );
  }

  //send message
  void sendMessage() async {
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(
        widget.receiverID, 
        _messageController.text,
        );
    }
    //after sending clear controller
    _messageController.clear();
    scrolldown();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        centerTitle: true
        ,
        title: Text(widget.receiverEmail,style: TextStyle(color: Colors.black),),
    ),
    body: Column(
      children: [
        //display all messages in chat room
        Expanded(child: _buildMessageList(),),

        // user input
        _buildUserInput()

      ],
    ),
    );
  }

    //build message list
  Widget _buildMessageList(){

    String senderId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderId, widget.receiverID),
      builder: (context, snapshot){
        //errors
        if(snapshot.hasError){
          return const Text("Error");
        }

        //loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator(
            color: KAppColors.kPrimary,
          );
        }


        //return List Veiw Builder

        return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );



  }
    );
  }

  //build Message item
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //message alignment
    //is current user?
    bool isCurrentUser = data["senderID"] == _firestore.user!.uid;

    

    //if message from current user set it to right

    //if message is from other user set it to left
    
    var alignment = isCurrentUser ? Alignment.centerRight :Alignment.centerLeft;

    
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            isCurrentUser: isCurrentUser,
            message: data["message"],
            timestamp: data["timestamp"]
          ), 

        ],
      ),
      );
  }

  //build user Input
  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20,left: 20,right: 15,top: 20),
      child: Row(
        children: [
          // text field should get most of the space
          IconButton(onPressed: (){}, icon: Icon(Icons.attach_file,color: KAppColors.kPrimary,size: 28,)),
          const SizedBox(width: 5,),
          Expanded(
            child: Container(
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey[300]

              ),
              child: TextField(
              focusNode: myfocusnode,
              onEditingComplete: () {
                sendMessage();
              },
                controller: _messageController,
                textAlign: TextAlign.start,
                decoration:  InputDecoration(

                  hintText: "Write Your Message",
                  suffixIcon: IconButton(onPressed: sendMessage, icon: const Icon(Icons.send,color: KAppColors.kPrimary,)),
                 

                  hintFadeDuration: const Duration(seconds: 1),
                  
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 15,top: 12),  
                  hintStyle: const TextStyle(
                     color: Color.fromARGB(147, 158, 158, 158),
                  )
                
                ),
                obscureText: false,
                
              ),
            )
          ),
      
      
          // camera button
          IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.camera, color: KAppColors.kPrimary,size: 28,)),
          

          // camera button
          IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.mic, color: KAppColors.kPrimary,size: 28,)),

        ],
      ),
    );
  }
}