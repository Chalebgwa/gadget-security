import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gsec/models/user.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class Header extends StatelessWidget {
  final Client user;
  const Header({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: AppBarClipper(),
            child: Container(
              color: Colors.black,
              child: Opacity(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/back3.jpg"),
                    ),
                  ),
                ),
                opacity: .4,
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            right: 20,
            child: CachedNetworkImage(
              imageUrl: user.imageUrl,
              imageBuilder: (context, provider) {
                return CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 35,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: provider,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 1,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Chip(
                  backgroundColor: Colors.green,
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "5.0",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
