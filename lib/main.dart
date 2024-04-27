import 'package:contact_clone/screens/contact_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart' as cs;

import 'models/contact.dart';
import 'utilities/db_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white12,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoSerifTextTheme(),
      ),
      home: const MyHomePage(title: 'Contact Clone'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    final List<Permission> permissions = [
      Permission.contacts,
      Permission.phone,
    ];

    final Map<Permission, PermissionStatus> permissionStatus =
        await permissions.request();

    if (permissionStatus[Permission.contacts] == PermissionStatus.granted &&
        permissionStatus[Permission.phone] == PermissionStatus.granted) {
      _retrieveContacts();
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<void> _retrieveContacts() async {
    try {
      final contacts = await cs.ContactsService.getContacts();
      for (final c in contacts) {
        final contact = _createContactFromContactService(c);
        await DBProvider.db.insertContact(contact);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving contacts: $e');
      }
    }
  }

  Contact _createContactFromContactService(cs.Contact c) {
    final emailAddress = c.emails
            ?.map((e) => EmailAddress(
                  email: e.value,
                  label: e.label,
                ))
            .toList() ??
        [];
    final phoneNumbers = c.phones
            ?.map((p) => PhoneNumber(
                  number: p.value,
                  label: p.label,
                ))
            .toList() ??
        [];
    final postalAddresses = c.postalAddresses
            ?.map((post) => PostalAddress(
                  street: post.street,
                  city: post.city,
                  region: post.region,
                  postalCode: post.postcode,
                  country: post.country,
                  label: post.label,
                ))
            .toList() ??
        [];

    return Contact(
      displayName: c.displayName ?? '',
      givenName: c.givenName ?? '',
      middleName: c.middleName ?? '',
      prefix: c.prefix ?? '',
      suffix: c.suffix ?? '',
      familyName: c.familyName ?? '',
      company: c.company ?? '',
      jobTitle: c.jobTitle ?? '',
      emails: emailAddress,
      phoneNumbers: phoneNumbers,
      postalAddresses: postalAddresses,
      avatar: c.avatar,
    );
  }

  void _handleInvalidPermissions(
      Map<Permission, PermissionStatus> permissionStatus) {
    final contactPermissionStatus = permissionStatus[Permission.contacts];
    final phonePermissionStatus = permissionStatus[Permission.phone];

    String message = '';

    if (contactPermissionStatus == PermissionStatus.denied ||
        phonePermissionStatus == PermissionStatus.denied) {
      message = 'Access to contact data or phone call denied';
    } else {
      message = 'Contact data or phone call permission not available on device';
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showContacts() async {
    if (!mounted) return; // Guard the use of State.context

    final fromDatabase = await DBProvider.db.getContacts();

    if (!mounted) return; // Guard the use of BuildContext

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactListScreen(contacts: fromDatabase),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Icon(
                Icons.contacts,
                size: 100,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: _showContacts,
                child: const Text('Show Contacts ...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
