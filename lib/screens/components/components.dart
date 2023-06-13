import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  const DrawerList(
      {super.key,
      required this.title,
      required this.icon,
      required this.press,
      required this.isSelected});

  final String title;
  final IconData icon;
  final Function() press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedColor: Theme.of(context).primaryColor,
      selected: isSelected,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      onTap: press,
      title: Text(title),
      leading: Icon(icon),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
    this.onPress,
    this.icon,
    this.color,
  });
  final Function()? onPress;
  final IconData? icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPress,
        icon: Icon(
          icon,
          color: color,
        ));
  }
}

class ProfileNameEmail extends StatelessWidget {
  const ProfileNameEmail({
    super.key,
    required this.title,
    required this.content,
  });

  // final ProfileScreen widget;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17),
        ),
        Text(
          content,
          style: const TextStyle(fontSize: 17),
        )
      ],
    );
  }
}
