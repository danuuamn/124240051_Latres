import 'package:flutter/material.dart';
import '../models/character.dart';
import 'status_text.dart';

class CharacterTile extends StatelessWidget {
  const CharacterTile({
    super.key,
    required this.character,
    required this.onTap,
    this.trailing,
  });

  final Character character;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Image.network(
          character.image,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
        title: Text(
          character.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: StatusText(status: character.status),
        trailing: trailing,
      ),
    );
  }
}
