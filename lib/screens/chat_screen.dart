import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textmessagecontroller = TextEditingController();
  final _ath = FirebaseFirestore.instance;
  late String msg;
  final _auth = FirebaseAuth.instance;
  User? loggedinuser;
  List<Widget> messagewidgets = [];
  @override
  void initState() {
    super.initState();
    getuser();
  }

  void getuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedinuser = user;
        });
        print(loggedinuser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesstream() async {
    await for (var snapshots in _ath.collection('messages').snapshots()) {
      for (var message in snapshots.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              messagesstream();
              // Implement logout functionality
              //_auth.signOut();
              // Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _ath.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue,
                    ),
                  );
                }
                final messages = snapshot.data?.docs.reversed;
                messagewidgets.clear();
                for (var message in messages!) {
                  var fn = message.data() as Map<String, dynamic>;

                  final messagetext = fn['text'];
                  final messagesender = fn['sender'];
                  if (messagetext != null && messagesender != null) {
                    final messagewidget = Messagebubble(
                      sender: messagesender,
                      text: messagetext,
                    );

                    messagewidgets.add(messagewidget);
                  }
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children: messagewidgets,
                  ),
                );

                // Return an empty container when there's no data
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textmessagecontroller,
                      onChanged: (value) {
                        // Do something with the user input.
                        msg = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textmessagecontroller.clear();
                      // Implement send functionality.
                      _ath.collection('messages').add({
                        'text': msg,
                        'sender': loggedinuser?.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Messagebubble extends StatelessWidget {
  Messagebubble({this.sender, this.text});
  late String? sender;
  late String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$sender',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
            color: Colors.blue,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                child: Text(
                  '$text',
                  style: TextStyle(fontSize: 15.0),
                )),
          ),
        ],
      ),
    );
  }
}
