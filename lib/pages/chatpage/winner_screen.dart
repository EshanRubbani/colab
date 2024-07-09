import 'package:Collab/extras/utils/Helper/voting/group_model.dart';
import 'package:Collab/extras/utils/Helper/voting/voting_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WinnerScreen extends StatefulWidget {
  final String groupId;

  const WinnerScreen({required this.groupId, Key? key}) : super(key: key);

  @override
  _WinnerScreenState createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> with SingleTickerProviderStateMixin {
  late final VotingService _votingService;
  String? _winner;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _votingService = VotingService();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _loadWinner();
  }

  Future<void> _loadWinner() async {
    final winner = await _votingService.tallyVotes(widget.groupId);
    setState(() {
      _winner = winner;
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Winner of the Vote'),
      ),
      body: Center(
        child: _winner == null
            ? CircularProgressIndicator()
            : FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'The Winner is:',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _winner!,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
