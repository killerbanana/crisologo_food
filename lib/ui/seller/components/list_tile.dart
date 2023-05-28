import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const MyListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEditPressed,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDeletePressed,
          ),
        ],
      ),
    );
  }
}
