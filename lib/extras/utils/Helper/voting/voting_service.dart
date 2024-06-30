import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/voting/group_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VotingService {
  void initiateVoting(String groupId) {
    final Timestamp now = Timestamp.now();
    final Timestamp endTime = Timestamp.fromDate(
      now.toDate().add(Duration(hours: 24)),
    );
    print('inside voting service');
    FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'votingStartTime': now,
      'votingEndTime': endTime,
    });
  }

  void castVote(String groupId, String voterId, String candidateId) {
    FirebaseFirestore.instance.collection('groups').doc(groupId).collection('votes').add({
      'voterId': voterId,
      'candidateId': candidateId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    Get.snackbar(
      'Success',
      'Your Vote has been successfully cast. You have voted for $candidateId',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
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


  void updateVote(String groupId, String voterId, String newCandidateId) async {
    QuerySnapshot votesSnapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(groupId)
      .collection('votes')
      .where('voterId', isEqualTo: voterId)
      .get();

    if (votesSnapshot.docs.isNotEmpty) {
      // Assuming each voter can cast only one vote, so we take the first result
      DocumentSnapshot voteDoc = votesSnapshot.docs.first;
      voteDoc.reference.update({
        'candidateId': newCandidateId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Get.snackbar(
        'Success',
        'Your vote has been successfully updated. You have voted for $newCandidateId',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'No existing vote found for this voter.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<String?> getUserVote(String groupId, String voterId) async {
    QuerySnapshot votesSnapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(groupId)
      .collection('votes')
      .where('voterId', isEqualTo: voterId)
      .get();

    if (votesSnapshot.docs.isNotEmpty) {
      return votesSnapshot.docs.first['candidateId'];
    }
    return null;
  }
}
