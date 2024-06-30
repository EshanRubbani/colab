import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/voting/group_model.dart';

class VotingService {
  void initiateVoting(String groupId) {
    FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'votingStartTime': FieldValue.serverTimestamp(),
      // 'votingEndTime': FieldValue.serverTimestamp().add(Duration(hours: 24)),
    });
  }

  void castVote(String groupId, String voterId, String candidateId) {
    FirebaseFirestore.instance.collection('groups').doc(groupId).collection('votes').add({
      'voterId': voterId,
      'candidateId': candidateId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<String> tallyVotes(String groupId) async {
    QuerySnapshot votesSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('votes')
        .get();

    Map<String, int> voteCount = {};

    for (var doc in votesSnapshot.docs) {
      String candidateId = doc['candidateId'];
      if (voteCount.containsKey(candidateId)) {
        voteCount[candidateId] = voteCount[candidateId]! + 1;
      } else {
        voteCount[candidateId] = 1;
      }
    }

    String winnerId = voteCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return winnerId;
  }

  Future<void> displayWinner(String groupId) async {
    String winnerId = await tallyVotes(groupId);
    DocumentSnapshot winnerSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .doc(winnerId)
        .get();

    Member winner = Member(id: winnerSnapshot.id, name: winnerSnapshot['name']);
    // Display winner (e.g., showDialog, setState, etc.)
  }
}
