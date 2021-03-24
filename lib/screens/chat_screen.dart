import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

final _firestore = FirebaseFirestore.instance;
User loggenInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageControler = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String msgText;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggenInUser = user;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
    ;
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
                messageStream();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageControler,
                      onChanged: (value) {
                        msgText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageControler.clear();
                      _firestore
                          .collection('messages')
                          .add({'text': msgText, 'sender': loggenInUser.email});
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

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data()['text'];
            final messageSender = message.data()['sender'];
            final currentUser = loggenInUser.email;

            final messageBubble = MessageBubble(
              msgText: messageText,
              msgSender: messageSender,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(

              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              children: messageBubbles,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
final bool isMe;
  const MessageBubble({this.msgText, this.msgSender,this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            msgSender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            elevation: 5.0,
            borderRadius:isMe? BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ):BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color:isMe? Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                msgText,
                style: TextStyle(fontSize: 15, color: isMe?Colors.white:Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
