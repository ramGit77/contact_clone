import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/contact.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database?> initDB() async {
    try {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final database = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await _createTables(database);
      return database;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing database: $e');
      }
      return null;
    }
  }

  Future<void> _createTables(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS contact (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          displayName TEXT,
          givenName TEXT,
          middleName TEXT,
          prefix TEXT,
          suffix TEXT,
          familyName TEXT,
          company TEXT,
          jobTitle TEXT,
          avatar BLOB
      )
      ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS email_address (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          contact_id INTEGER,
          email TEXT,
          label TEXT,
          FOREIGN KEY (contact_id) REFERENCES contact(id)
      )
      ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS phone_number (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          contact_id INTEGER,
          number TEXT,
          label TEXT,
          FOREIGN KEY (contact_id) REFERENCES contact(id)
      )
      ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS postal_address (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          contact_id INTEGER,
          street TEXT,
          city TEXT,
          region TEXT,
          postalCode TEXT,
          country TEXT,
          label TEXT,
          FOREIGN KEY (contact_id) REFERENCES contact(id)
      )
      ''');
  }

  Future<void> insertContact(Contact contact) async {
    try {
      final db = await database;
      final contactId = await db.insert(
        'contact',
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await _insertEmails(db, contactId, contact.emails);
      await _insertPhoneNumbers(db, contactId, contact.phoneNumbers);
      await _insertAddresses(db, contactId, contact.postalAddresses);
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting contact: $e');
      }
    }
  }

  Future<void> _insertEmails(
      Database db, int contactId, List<EmailAddress>? emails) async {
    if (emails != null) {
      for (final e in emails) {
        await db.insert(
          'email_address',
          {'contact_id': contactId, 'email': e.email, 'label': e.label},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<void> _insertPhoneNumbers(
      Database db, int contactId, List<PhoneNumber>? phoneNumbers) async {
    if (phoneNumbers != null) {
      for (final phoneNumber in phoneNumbers) {
        await db.insert(
          'phone_number',
          {
            'contact_id': contactId,
            'number': phoneNumber.number,
            'label': phoneNumber.label
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<void> _insertAddresses(
      Database db, int contactId, List<PostalAddress>? addresses) async {
    if (addresses != null) {
      for (final address in addresses) {
        await db.insert(
          'postal_address',
          {
            'contact_id': contactId,
            'street': address.street,
            'city': address.city,
            'region': address.region,
            'postalCode': address.postalCode,
            'country': address.country,
            'label': address.label
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<List<Contact?>> getContacts() async {
    try {
      final db = await database;
      final contactMaps = await db.query('contact');
      final contacts = <Contact?>[];

      for (final contactMap in contactMaps) {
        final int contactId = contactMap['id'] as int;
        final emails = await _getEmails(db, contactId);
        final phoneNumbers = await _getPhoneNumbers(db, contactId);
        final addresses = await _getAddresses(db, contactId);

        final contact = Contact(
          id: contactId,
          displayName: contactMap['displayName'] as String?,
          givenName: contactMap['givenName'] as String?,
          middleName: contactMap['middleName'] as String?,
          prefix: contactMap['prefix'] as String?,
          suffix: contactMap['suffix'] as String?,
          familyName: contactMap['familyName'] as String?,
          company: contactMap['company'] as String?,
          jobTitle: contactMap['jobTitle'] as String?,
          emails: emails,
          phoneNumbers: phoneNumbers,
          postalAddresses: addresses,
          avatar: contactMap['avatar'] as Uint8List?,
        );

        contacts.add(contact);
      }
      return contacts;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting contacts: $e');
      }
      return [];
    }
  }

  Future<List<EmailAddress>> _getEmails(Database db, int contactId) async {
    final emailMaps = await db.query(
      'email_address',
      where: 'contact_id = ?',
      whereArgs: [contactId],
    );
    return emailMaps.map((emailMap) => EmailAddress.fromMap(emailMap)).toList();
  }

  Future<List<PhoneNumber>> _getPhoneNumbers(Database db, int contactId) async {
    final phoneMaps = await db.query(
      'phone_number',
      where: 'contact_id = ?',
      whereArgs: [contactId],
    );
    return phoneMaps.map((phoneMap) => PhoneNumber.fromMap(phoneMap)).toList();
  }

  Future<List<PostalAddress>> _getAddresses(Database db, int contactId) async {
    final addressMaps = await db.query(
      'postal_address',
      where: 'contact_id = ?',
      whereArgs: [contactId],
    );
    return addressMaps
        .map((addressMap) => PostalAddress.fromMap(addressMap))
        .toList();
  }
}
