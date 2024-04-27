import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../models/contact.dart';

class ContactDetailsScreen extends StatelessWidget {
  final Contact? contact;

  const ContactDetailsScreen({required this.contact, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact?.displayName ?? 'Contact Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Avatar(
                avatar: contact?.avatar,
              ),
            ),
            const SizedBox(height: 20),
            ContactInformationRow(
              title: 'Display Name:',
              value: contact?.displayName ?? '',
            ),
            ContactInformationRow(
              title: 'Given Name:',
              value: contact?.givenName ?? '',
            ),
            ContactInformationRow(
              title: 'Middle Name:',
              value: contact?.middleName ?? '',
            ),
            ContactInformationRow(
              title: 'Family Name:',
              value: contact?.familyName ?? '',
            ),
            ContactInformationRow(
              title: 'Prefix:',
              value: contact?.prefix ?? '',
            ),
            ContactInformationRow(
              title: 'Suffix:',
              value: contact?.suffix ?? '',
            ),
            ContactInformationRow(
              title: 'Company:',
              value: contact?.company ?? '',
            ),
            ContactInformationRow(
              title: 'Job Title:',
              value: contact?.jobTitle ?? '',
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Emails'),
            if (contact?.emails != null)
              ...contact!.emails!.map((email) => ContactInformationRow(
                    title: email.label ?? 'Email:',
                    value: email.email ?? '',
                  )),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Phone Numbers'),
            if (contact?.phoneNumbers != null)
              ...contact!.phoneNumbers!.map((phoneNumber) => PhoneNumberRow(
                    number: phoneNumber.number ?? '',
                    label: phoneNumber.label ?? '',
                    onTap: () => _callNumber(context, phoneNumber.number ?? ''),
                  )),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Postal Addresses'),
            if (contact?.postalAddresses != null)
              ...contact!.postalAddresses!.map((postalAddress) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContactInformationRow(
                        title: 'Label:',
                        value: postalAddress.label ?? '',
                      ),
                      ContactInformationRow(
                        title: 'Street:',
                        value: postalAddress.street ?? '',
                      ),
                      ContactInformationRow(
                        title: 'City:',
                        value: postalAddress.city ?? '',
                      ),
                      ContactInformationRow(
                        title: 'Region:',
                        value: postalAddress.region ?? '',
                      ),
                      ContactInformationRow(
                        title: 'Postal Code:',
                        value: postalAddress.postalCode ?? '',
                      ),
                      ContactInformationRow(
                        title: 'Country:',
                        value: postalAddress.country ?? '',
                      ),
                      const SizedBox(height: 10),
                    ],
                  )),
          ],
        ),
      ),
    );
  }

  void _callNumber(BuildContext context, String number) {
    FlutterPhoneDirectCaller.callNumber(number);
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.avatar});

  final Uint8List? avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColor.withOpacity(0.5),
      ),
      child: _isValidImageData(avatar)
          ? CircleAvatar(
              backgroundImage: MemoryImage(avatar!),
            )
          : const Icon(
              Icons.person,
              size: 80,
              color: Colors.white,
            ),
    );
  }

  bool _isValidImageData(Uint8List? imageData) {
    return imageData != null && imageData.isNotEmpty;
  }
}

class ContactInformationRow extends StatelessWidget {
  const ContactInformationRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class PhoneNumberRow extends StatelessWidget {
  const PhoneNumberRow({
    super.key,
    required this.number,
    required this.label,
    required this.onTap,
  });

  final String number;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white70),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white70,
        ),
      ),
    );
  }
}
