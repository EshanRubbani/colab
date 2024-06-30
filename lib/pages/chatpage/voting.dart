import 'package:collab/extras/utils/Helper/voting/group_model.dart';
import 'package:collab/extras/utils/Helper/voting/voting_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class GroupChatScreen extends StatefulWidget {
  final String groupId;

  GroupChatScreen({required this.groupId});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final VotingService _votingService = VotingService();
  List<Member> _members = [];

  @override
  void initState() {
    super.initState();
    _loadGroupMembers();
  }

  void _loadGroupMembers() async {
    QuerySnapshot memberSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('members')
        .get();

    setState(() {
      _members = memberSnapshot.docs.map((doc) => Member(id: doc.id, name: doc['name'])).toList();
    });
  }

  void _initiateVoting() {
    _votingService.initiateVoting(widget.groupId);
  }

  void _castVote(String candidateId) {
    String voterId = 'your-voter-id'; // Replace with the actual voter ID
    _votingService.castVote(widget.groupId, voterId, candidateId);
  }

  void _displayWinner() async {
    await _votingService.displayWinner(widget.groupId);
    // Implement the display logic here (e.g., showDialog)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Voting'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _initiateVoting,
            child: Text('Start Voting'),
          ),
          ..._members.map((member) => ListTile(
                title: Text(member.name),
                trailing: ElevatedButton(
                  onPressed: () => _castVote(member.id),
                  child: Text('Vote'),
                ),
              )),
          ElevatedButton(
            onPressed: _displayWinner,
            child: Text('Show Winner'),
          ),
        ],
      ),
    );
  }
}
