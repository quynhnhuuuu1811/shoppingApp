import 'package:flutter/material.dart';

class OptionAccountPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? toPage;
  final VoidCallback? onTap;

  OptionAccountPage({
    Key? key,
    required this.title,
    required this.icon,
    this.toPage,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title,
              style: TextStyle(
                fontSize: 22,
              )),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          onTap: onTap ?? () {
            if (toPage != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => toPage!),
              );
            }
          },
        ),
      ),
    );
  }
}
