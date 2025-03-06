import 'package:flutter/material.dart';
import 'package:nodelabs/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Profile", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
              backgroundColor: Colors.grey.shade800,
            ),
            SizedBox(height: 10),
            Text(user.name, style: TextStyle(color: Colors.white, fontSize: 20)),
            Text(user.email, style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
