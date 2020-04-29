import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/auth.dart';

class ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profilePicUrl =
        Provider.of<Auth>(context, listen: false).user.photoUrl;

    return Material(
      elevation: 8.0,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Ink.image(
        image: profilePicUrl == null
            ? AssetImage('lib/assets/images/logo.png')
            : NetworkImage(profilePicUrl),
        fit: BoxFit.cover,
        width: 40.0,
        height: 40.0,
        child: InkWell(
          splashColor: Colors.black26,
          onTap: () {},
        ),
      ),
    );
  }
}
