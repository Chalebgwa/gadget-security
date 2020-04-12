import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/widgets/nm_box.dart';

class DashCard extends StatelessWidget {
  const DashCard({Key key, this.label, this.icon, this.onTap})
      : super(key: key);

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: fCD,
            ),
            Text(
              label,
              style: TextStyle(
                color: fCD,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopButton extends StatelessWidget {
  const TopButton(
      {Key key, this.icon, this.label, this.lock = false, this.onTap})
      : super(key: key);

  final IconData icon;
  final String label;
  final bool lock;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        onPressed: onTap,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              //decoration: nMbox.copyWith(color:Colors.black.withOpacity(.5),),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  if (lock)
                    Positioned(
                      child: Icon(
                        FontAwesomeIcons.lock,
                        color: Colors.red,
                        size: 10,
                      ),
                      top: 5,
                      right: 5,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Hero(
                      tag: label,
                      child: Icon(icon, color: Colors.white.withOpacity(.3)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Hero(
                tag: "$label title",
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
