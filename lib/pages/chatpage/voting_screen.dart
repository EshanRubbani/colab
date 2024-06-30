import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collab/extras/utils/Helper/voting/voting_service.dart';

class VotingScreen extends StatefulWidget {
  final String groupName;
  final List<String> candidates;
  final String groupId;

  VotingScreen({required this.groupName, required this.candidates, required this.groupId});

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final userIdentifier = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.phoneNumber!;
  final VotingService _votingService = VotingService();
  String? selectedCandidate;
  bool hasVoted = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserHasVoted();
  }

  void _checkIfUserHasVoted() async {
    String? candidateId = await _votingService.getUserVote(widget.groupId, userIdentifier);
    if (candidateId != null) {
      setState(() {
        selectedCandidate = candidateId;
        hasVoted = true;
      });
    }
  }

  void _castOrUpdateVote() {
    if (hasVoted) {
      _votingService.updateVote(widget.groupId, userIdentifier, selectedCandidate!);
    } else {
      _votingService.castVote(widget.groupId, userIdentifier, selectedCandidate!);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You voted for $selectedCandidate')),
    );
    setState(() {
      selectedCandidate = null;
      hasVoted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.candidates.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RadioListTile<String>(
                      title: Text(
                        widget.candidates[index],
                        style: TextStyle(fontSize: 18),
                      ),
                      value: widget.candidates[index],
                      groupValue: selectedCandidate,
                      onChanged: (value) {
                        setState(() {
                          selectedCandidate = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedCandidate == null
                      ? null
                      : _castOrUpdateVote,
                  child: Text(
                    hasVoted ? 'Update Vote' : 'Cast Vote',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
