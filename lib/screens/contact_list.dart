import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/contact.dart';
import 'contact_details.dart';

class ContactListScreen extends StatelessWidget {
  final List<Contact?> contacts;

  const ContactListScreen({required this.contacts, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              leading: CircleAvatar(
                radius: 23,
                backgroundColor: Theme.of(context).colorScheme.shadow,
                backgroundImage: _isValidImageData(contacts[index]?.avatar)
                    ? MemoryImage(contacts[index]!.avatar!)
                    : null,
                child: _isValidImageData(contacts[index]?.avatar)
                    ? null
                    : Text(
                        contacts[index]?.displayName![0] ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
              ),
              contentPadding: const EdgeInsets.all(16),
              tileColor: Theme.of(context).colorScheme.onSecondary,
              selectedTileColor: Colors.blue.withOpacity(0.3),
              title: Text(
                contacts[index]?.displayName ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ContactDetailsScreen(contact: contacts[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  bool _isValidImageData(Uint8List? imageData) {
    return imageData != null && imageData.isNotEmpty;
  }
}
