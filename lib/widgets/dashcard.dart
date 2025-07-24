import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/widgets/nm_box.dart';

class DashCard extends StatelessWidget {
  const DashCard({super.key, this.label, this.icon, this.onTap});

  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
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
              label ?? '',
              style: const TextStyle(
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
  const TopButton({
    super.key, 
    required this.icon, 
    required this.label, 
    this.lock = false, 
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool lock;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(60, 80),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  if (lock)
                    const Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(
                        FontAwesomeIcons.lock,
                        color: Colors.red,
                        size: 10,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Hero(
                      tag: label,
                      child: Icon(
                        icon, 
                        color: Colors.white.withOpacity(.8),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Hero(
                tag: "$label title",
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
